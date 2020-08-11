import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/http_exception.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryTime;
  String userId;
  Timer authTimer;

  bool get isAuth
  {
    return tokedId!=null;
  }

  String get tokedId
  {
    if(token!=null && expiryTime!=null && expiryTime.isAfter(DateTime.now()))
      {
        return token;
      }
    return null;
  }

  Future<void> signUp(String email,String pass) async {
    print(email);
    print(pass);
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDKJHH7rEH7IdX1XhLMx_hQITNvMugINXw';
   try{
     final res = await http.post(url,body: jsonEncode({
       'email':email.trim(),
       'password':pass.trim(),
       'returnSecureToken' : true
     }));
     if(jsonDecode(res.body)['error'] != null)
       {
         print(jsonDecode(res.body)['error']['message']);
         throw HttpException(jsonDecode(res.body)['error']['message']);
       }
     token = jsonDecode(res.body)['idToken'];
     userId = jsonDecode(res.body)['localId'];
     expiryTime = DateTime.now().add(Duration(seconds: int.parse(jsonDecode(res.body)['expiresIn'])));
     autoLogin();
     autoLogout();
     notifyListeners();
   }
    catch(error)
    {
      print(error);
      throw error;
    }

  }

  Future<void> login(String email,String pass) async {
    print(email);
    print(pass);
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDKJHH7rEH7IdX1XhLMx_hQITNvMugINXw';
    try{
      final res = await http.post(url,body: jsonEncode({
        'email':email.trim(),
        'password':pass.trim(),
        'returnSecureToken' : true
      }));
      if(jsonDecode(res.body)['error'] != null)
      {
        print(jsonDecode(res.body)['error']['message']);
        throw HttpException(jsonDecode(res.body)['error']['message']);
      }
      token = jsonDecode(res.body)['idToken'];
      userId = jsonDecode(res.body)['localId'];
      expiryTime = DateTime.now().add(Duration(seconds: int.parse(jsonDecode(res.body)['expiresIn'])));
      autoLogin();
      autoLogout();
      notifyListeners();
    }
    catch(error)
    {
      print(error);
      throw error;
    }
  }

  Future<void> autoLogin() async
  {
    final prefs = await SharedPreferences.getInstance();
    var userData = jsonEncode({
      'tokenId' : token,
      'userId' : userId,
      'expiryTime' : expiryTime.toIso8601String()
    });
    prefs.setString('userData', userData);
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('userData'));
    var expiryDTime = DateTime.parse(userData['expiryTime']);
    if(!prefs.containsKey('userData'))
      {
        return Future<bool>.value(false);
      }
    else if(expiryDTime.isBefore(DateTime.now()))
      {
        return Future<bool>.value(false);
      }
    token = userData['tokenId'];
    userId= userData['userId'];
    expiryTime = expiryDTime;
    autoLogout();
    notifyListeners();
    return Future<bool>.value(true);
  }
  Future<void> logout() async
  {
    final prefs = await SharedPreferences.getInstance();
    token=null;
    expiryTime=null;
    userId=null;
    if(authTimer != null)
    {
      authTimer.cancel();
      authTimer =null;
    }
    prefs.clear();
    notifyListeners();
  }



  void autoLogout()
  {
    var timeToExpiry = expiryTime.difference(DateTime.now()).inSeconds;
    if(authTimer != null)
      {
        authTimer.cancel();
      }
    else{
      authTimer =Timer(Duration(seconds: timeToExpiry), logout);
    }
  }
}