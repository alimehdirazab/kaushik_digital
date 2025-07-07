import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveProfile({
    int? userId,
    String? name,
    String? email,
    String? userImage,
    String? phone,
    String? userAddress,
    String? refrenceId,
    String? msg,
    String? success,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setInt('userId', userId);
    }
    await prefs.setString('name', name ?? '');
    await prefs.setString('email', email ?? '');
    await prefs.setString('userImage', userImage ?? '');
    await prefs.setString('phone', phone ?? '');
    await prefs.setString('userAddress', userAddress ?? '');
    await prefs.setString('refrenceId', refrenceId ?? '');
    await prefs.setString('msg', msg ?? '');
    await prefs.setString('success', success ?? '');
  }

  static Future<Map<String, dynamic>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getInt('userId'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'userImage': prefs.getString('userImage'),
      'phone': prefs.getString('phone'),
      'userAddress': prefs.getString('userAddress'),
      'refrenceId': prefs.getString('refrenceId'),
      'msg': prefs.getString('msg'),
      'success': prefs.getString('success'),
    };
  }

  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('userImage');
    await prefs.remove('phone');
    await prefs.remove('userAddress');
    await prefs.remove('refrenceId');
    await prefs.remove('msg');
    await prefs.remove('success');
  }
}
