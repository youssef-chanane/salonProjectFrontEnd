import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_laravel/services/dio.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Service extends ChangeNotifier{
  String _token;
  final storage = new FlutterSecureStorage();
  List<dynamic> _services;
  List<dynamic> get services =>_services;

    //store service 
  void store({Map creds}) async {
    print(creds);

    try{
      _token=Auth.token;
      print(_token);
      Dio.Response response = await dio().post('/service',data: creds,
            options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

    }catch(e){
      print(e.toString());
    }
  }
  void show(int id) async {
    Dio.Response response = await dio().get('/service/$id');
    _services=response.data;
    // Dio.Response response2=await dio().get('salon/1');
    print(response.data);
    // print(response2.data);
  }
    void destroy(int id) async {
    Dio.Response response =await dio().delete('/service/$id');
    print(_services);
    }
}