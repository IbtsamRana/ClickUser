
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {

  LanguageCubit():super(Locale('en')){
   setLanguage();
  }

  void setLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString('language') == 'hi'){
      emit(Locale('hi'));
    }else if(preferences.getString('language') == 'en'){
      emit(Locale('en'));
    }else if(preferences.getString('language') == 'es'){
      emit(Locale('es'));
    }else{
      emit(Locale('en'));
    }

  }

  void selectLanguage(dynamic code) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', '${code}');
    emit(Locale('${code}'));
  }

  void selectEngLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'en');
    emit(Locale('en'));
  }

  void selectSpanishLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'es');
    emit(Locale('es'));
  }

  void selectHindiLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'hi');
    emit(Locale('hi'));
  }



}
