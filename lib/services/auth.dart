import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/user.dart';
import 'package:flutter_laravel/services/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  User _user;
  static int _role;
  static int get role=>_role;
  static String _token;
  bool get authenticated => _isLoggedIn;
  User get user => _user;
  static String get token =>_token;
  int _id;
  int get id=>_id;

  final storage = new FlutterSecureStorage();

  //store user 
    Future <bool> store({Map creds}) async {
    // print(creds['email']);

    // print(data);
    try{
      Dio.Response response = await dio().post('/user',data: creds);
      Map data ={
        'email': creds['email'],
        'password': creds['password'],
        'device_name': 'mobile',
      
      };
      this.login(creds: data);
      // print(data);
      _token=data.toString();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
  Future <bool> login({Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      String token = response.data.toString();
       print(response.data);
       this.tryToken(token: token);
       return true;
    } catch (e) {
      print(e);
      return false;
      
    }
  }

  void tryToken({String token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggedIn = true;
        _role=response.data['role'];
        _id=response.data["id"];
        print(_id);
        // print(response.data['role']);
        this._user = User.fromJson(response.data);
        _token = token;
        this.storeToken(token: token);
        notifyListeners();
        // print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({String token}) async {
    this.storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    this._user = null;
    this._isLoggedIn = false;
    _token = null;
    await storage.delete(key: 'token');
  }

}
