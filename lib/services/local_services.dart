
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/modules/events/models/event_list_model.dart';
import '../models/single_product.dart';
import '../models/user_model.dart';
import '../models/logged_in_user_model.dart';
import '../app/modules/userPersonalData/models/user_personal_data_model.dart';

class LocalServices {
  // Keys
  static const _keyToken = 'token';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static const _keyRememberUser = 'rememberUser';
  static const _keyUser = 'user';
  static const _keyUserData = 'userData';
  static const _keyLoggedInUser = 'loggedInUser';
  static const _key2FaCompletedStatus = 'is2faCompleted';
  static const _keyFavouriteEvents = 'favouriteEvents';
  static const _keyFavouriteProducts = 'favouriteProducts';
  static const _keyReferral = 'referral_code';
  static const _keyReferralHandled = 'referral_handled';

  // ------------------ TOKEN ------------------
  static Future<void> storeToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
    } catch (e) {
      print("Error storing token: $e");
    }
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) ?? "";
  }

  // ------------------ 2FA ------------------
  static Future<void> store2FaCompletedStatus(bool status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key2FaCompletedStatus, status);
    } catch (e) {
      print("Error storing 2FA status: $e");
    }
  }

  static Future<bool> get2FaCompletedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key2FaCompletedStatus) ?? false;
  }


  // ---------------- Referral ----------------
  static Future<void> storeReferral(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyReferral, code);
    await prefs.setBool(_keyReferralHandled, false);
  }

  static Future<String?> getReferral() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyReferral);
  }

  static Future<void> markReferralHandled() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReferralHandled, true);
  }

  static Future<bool> isReferralHandled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyReferralHandled) ?? false;
  }

  static Future<void> clearReferralData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyReferral);
    await prefs.remove(_keyReferralHandled);
  }



  // ------------------ EMAIL & PASSWORD ------------------
  static Future<void> storeEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? "";
  }

  static Future<void> storePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, password);
  }

  static Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword) ?? "";
  }

  static Future<void> storeRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberUser, value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberUser) ?? false;
  }

  // ------------------ USER OBJECTS ------------------
  static Future<void> storeUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, json.encode(user.toJson()));
    } catch (e) {
      print("Error storing User: $e");
    }
  }

  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_keyUser);
      if (value == null) return null;
      return UserModel.fromJson(json.decode(value));
    } catch (e) {
      print("Error getting User: $e");
      return null;
    }
  }

  static Future<void> storeUserData(UserData userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserData, json.encode(userData.toJson()));
    } catch (e) {
      print("Error storing UserData: $e");
    }
  }

  static Future<UserData?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_keyUserData);
      if (value == null) return null;
      return UserData.fromJson(json.decode(value));
    } catch (e) {
      print("Error getting UserData: $e");
      return null;
    }
  }

  static Future<void> storeLoggedInUser(LoggedInUserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLoggedInUser, json.encode(user.toJson()));
    } catch (e) {
      print("Error storing LoggedInUser: $e");
    }
  }

  static Future<LoggedInUserModel?> getLoggedInUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_keyLoggedInUser);
      if (value == null) return null;
      return LoggedInUserModel.fromJson(json.decode(value));
    } catch (e) {
      print("Error getting LoggedInUser: $e");
      return null;
    }
  }

  // ------------------ GENERIC FAVOURITE ------------------
  static Future<void> addOrUpdateFavourite<T>(
      String key,
      T item,
      T Function(Map<String, dynamic>) fromJson,
      Map<String, dynamic> Function(T) toJson,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);
      List<T> currentList = [];
      if (jsonString != null) {
        final List decoded = json.decode(jsonString);
        currentList = decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }

      final index = currentList.indexWhere((e) => toJson(e)["id"] == toJson(item)["id"]);
      if (index != -1) currentList.removeAt(index);
      else currentList.add(item);

      await prefs.setString(key, json.encode(currentList.map((e) => toJson(e)).toList()));
    } catch (e) {
      print("Error in addOrUpdateFavourite: $e");
    }
  }

  static Future<List<T>> getFavourite<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);
      if (jsonString == null) return [];
      final List decoded = json.decode(jsonString);
      return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error in getFavourite: $e");
      return [];
    }
  }

  static Future<void> addOrUpdateFavouriteEvent(SingleEvent event) async {
    await addOrUpdateFavourite<SingleEvent>(
      _keyFavouriteEvents,
      event,
          (json) => SingleEvent.fromJson(json),
          (event) => event.toJson(),
    );
  }

  static Future<List<SingleEvent>> getFavouriteEvents() async {
    return await getFavourite<SingleEvent>(
      _keyFavouriteEvents,
          (json) => SingleEvent.fromJson(json),
    );
  }

  static Future<void> addOrUpdateFavouriteProduct(SingleProduct product) async {
    await addOrUpdateFavourite<SingleProduct>(
      _keyFavouriteProducts,
      product,
          (json) => SingleProduct.fromJson(json),
          (product) => product.toJson(),
    );
  }

  static Future<List<SingleProduct>> getFavouriteProducts() async {
    return await getFavourite<SingleProduct>(
      _keyFavouriteProducts,
          (json) => SingleProduct.fromJson(json),
    );
  }

  // ------------------ DELETE ------------------
  static Future<void> deleteAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print("Error deleting all data: $e");
    }
  }

  static Future<void> deleteDataBasedOnRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_keyRememberUser) ?? false;

      String? email = rememberMe ? prefs.getString(_keyEmail) : null;
      String? password = rememberMe ? prefs.getString(_keyPassword) : null;

      await prefs.clear();

      if (rememberMe) {
        if (email != null) await prefs.setString(_keyEmail, email);
        if (password != null) await prefs.setString(_keyPassword, password);
        await prefs.setBool(_keyRememberUser, true);
      }
    } catch (e) {
      print("Error deleting data based on remember me: $e");
    }
  }
}
