// ignore: unused_import
import 'dart:ui';

import 'package:socket_io_client/socket_io_client.dart' as IO;


class ChartaServices {
  IO.Socket? _socket;

  
  void conectare() {
    _socket = IO.io('http://192.168.1.24:3200', 
      IO.OptionBuilder()
      .setTransports(['websocket'])
      .enableAutoConnect()
      .build()
      );

    _socket!.onConnect((_) {
      _socket!.on('CLIENT_JOINED', (payload){
        //TODO: ______________

      });

      _socket!.on('CLIENT_LEFT', (payload){
        //TODO: ______________
      });

      _socket!.on('CLIENT_MOVED', (payload){
        //TODO: ______________
      });

      _socket!.on('GET_CLIENTS', (payload){
        //TODO: ______________
      });

    });

  _socket!.connect();
  }

  void finire() {
    _socket!.disconnect();
    _socket?.dispose();
    _socket = null;
  }

}