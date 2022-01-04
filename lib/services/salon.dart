

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_laravel/screens/display/salons_screen.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:flutter_laravel/services/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Salon extends ChangeNotifier{
    String _token;
    static  List<dynamic> _salons;
    static List<dynamic> get salons =>_salons;
    final storage = new FlutterSecureStorage();

  //store salon 
    void store({Map creds}) async {
    print(creds);

    try{
      _token=Auth.token;
      print(_token);
      Dio.Response response2 = await dio().put('/user/upgradetosalon',
            options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      Dio.Response response = await dio().post('/salon',data: creds,
            options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

      // /user/upgradetosalon
    }catch(e){
      print(e.toString());
    }
  }
  void index() async{
    Dio.Response response = await dio().get('/salon');
    _salons=response.data;
  }
}