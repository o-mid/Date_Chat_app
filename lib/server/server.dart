import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class Server {
  // Public Data
  static bool? isConnected;
  static bool? isConnecting;

  // Internal Sokcet Data
  static List<int>? _buffer;
  // ignore: close_sinks
  static Socket? _clientSoket;

  // Private Variables
  static int? _remotePort;
  static String? _remoteIp;
  static final _eorMark = '<?EOR/>';

  // Data holders for routing and events
  static final _serverConnectedHandlers = <Function>[];
  static final _serverDisconnectedHandlers = <Function>[];
  static final _serverRouteMessageHandlers = <Function(String, String)>[];

  static Future<void> initializeServer(String ip, int port) async {
    // Setup local Vars
    _remoteIp = ip;
    _remotePort = port;

    _buffer = <int>[];
    isConnected = false;
    isConnecting = false;
  }

  static Future<bool> connect() async {
    try {
      if (isConnected!) return true;
      // if (isConnecting) return false;

      isConnecting = true;

      // Connect then Send the DeviceId Token
      _clientSoket = await Socket.connect(_remoteIp, _remotePort!);

      // Hook RECV event listner
      _clientSoket!.listen(
        _onRecvData,
        onDone: _onDisconnected,
        onError: _onError,
        cancelOnError: true,
      );

      // Update Local Data
      _onConnected();
      return true;
    } on SocketException catch (_) {
      _onDisconnected();
      return false;
    } on ConcurrentModificationError {
      connect();
      return false;
    } catch (e) {
      _onDisconnected();
      return false;
    }
  }

  static Future<void> disconnect() async {
    await _clientSoket!.close();

    _onDisconnected();
  }

  static void onServerConnectedCall(Function handler) {
    _serverConnectedHandlers.add(handler);
  }

  static void onServerDisconnectedCall(Function handler) {
    _serverDisconnectedHandlers.add(handler);
  }

  static void onServerRouteMessageCall(Function(String, String) handler) {
    _serverRouteMessageHandlers.add(handler);
  }

  static void removeServerRouteMessageCall(Function(String, String) handler) {
    _serverRouteMessageHandlers.remove(handler);
  }

  static Future sendRequest(String route, Object payload) async {
    if (isConnected!) {
      var msg = payload.runtimeType == String ? payload : json.encode(payload);

      var pkgBytes = utf8.encode(route + _eorMark + msg.toString());

      var prefix = Uint8List(2)
        ..buffer.asByteData().setUint16(0, pkgBytes.length + 2, Endian.big);

      _clientSoket!.add(prefix.toList() + pkgBytes);
    }
  }

  static void _onConnected() {
    isConnected = true;
    isConnecting = false;

    for (var handler in _serverConnectedHandlers) {
      try {
        handler();
      } catch (e) {
        _serverConnectedHandlers.remove(handler);
      }
    }
  }

  static void _onDisconnected() {
    isConnected = false;
    isConnecting = false;

    for (var handler in _serverDisconnectedHandlers) {
      try {
        handler();
      } catch (e) {
        print(e);
        _serverConnectedHandlers.remove(handler);
      }
    }
  }

  static void _onError(e) {
    _onDisconnected();
  }

  static void _onRecvData(List<int> bytes) {
    _buffer!.addAll(bytes);

    while (_buffer!.length > 2) {
      var prefix = Uint8List.fromList(_buffer!);
      var pkgLen = prefix.buffer.asByteData().getUint16(0, Endian.big);

      if (pkgLen > 0 && _buffer!.length >= pkgLen) {
        // GOT VALID MESSAGE
        var pkgBytes = _buffer!.sublist(2, pkgLen);
        var pkgString = utf8.decode(pkgBytes, allowMalformed: true);
        var msgIdx = pkgString.indexOf(_eorMark);

        if (msgIdx > 0) {
          _onRouteMessage(pkgString.substring(0, msgIdx),
              pkgString.substring(msgIdx + _eorMark.length));
        }

        _buffer!.removeRange(0, pkgLen);
      } else {
        return;
      }
    }
  }

  static void _onRouteMessage(String route, String message) {
    // Emit data to the router
    for (var handler in _serverRouteMessageHandlers) {
      try {
        handler(route, message);
      } catch (e) {
        _serverConnectedHandlers.remove(handler);
      }
    }
  }
}
