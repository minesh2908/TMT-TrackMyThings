import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrence {
  Future<void> setUserNameSF(String? userName) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('userName', userName!);
  }

  Future<String> getUserNameSF() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('userName') ?? 'empty';
  }

  Future<bool> deleteUserNameSF() async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove('userName');
  }

  Future<void> setLoggedIn({required bool loggedIn}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('loggedIn', loggedIn);
  }

  Future<bool> getLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('loggedIn') ?? false;
  }

  Future<bool> deleteLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove('loggedIn');
  }
}

class AppPref {
  AppPref._();

  static SharedPreferences? _pref;

  static Future<void> init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  static Future<bool> save(AppPrefKey key, dynamic value) async {
    // log('PreferenceKey $key, Value: $value, Type: ${value.runtimeType}');

    if (value == null) {
      return false;
    }

    switch (value.runtimeType) {
      case String:
        return _pref!.setString(key.name, value as String);
      case int:
        return _pref!.setInt(key.name, value as int);
      case bool:
        return _pref!.setBool(key.name, value as bool);
      case double:
        return _pref!.setDouble(key.name, value as double);
      case const (List<String>):
        return _pref!.setStringList(key.name, value as List<String>);
    }

    //log('PreferenceKey return false');
    return false;
  }

  static dynamic get(AppPrefKey key, dynamic defaultValue) {
    final value = _pref!.get(key.name) ?? defaultValue;
    //log('PreferenceKey $key Value: $value');
    return value;
  }

  static Future<bool> remove(AppPrefKey key) async {
    return _pref!.remove(key.name);
  }

  static Future<bool> clear() async {
    return _pref!.clear();
  }
}

enum AppPrefKey {
  displayName('displayName'),
  email('email'),
  phoneNumber('phoneNumber'),
  uid('logout'),
  defaultWarrantyPeriod('defaultWarrantyPeriod'),
  sortProductBy('sortProductBy'),
  darkTheme('darkTheme'),
  language('language'),
  filterValue('filterValue');

  const AppPrefKey(this.name);

  final String name;
}

class AppPrefHelper {
  static Future<bool> setUID({required String uid}) async {
    return AppPref.save(AppPrefKey.uid, uid);
  }

  static String getUID() {
    final uid = AppPref.get(AppPrefKey.uid, '') as String;
    // log('uid: $uid');
    return uid;
  }

  static Future<bool> setDisplayName({required String displayName}) async {
    return AppPref.save(AppPrefKey.displayName, displayName);
  }

  static String getDisplayName() {
    final displayName = AppPref.get(AppPrefKey.displayName, '') as String;
    // log('displayName: $displayName');
    return displayName;
  }

  static Future<bool> setDarkTheme({required bool darkTheme}) async {
    return AppPref.save(AppPrefKey.darkTheme, darkTheme);
  }

  static bool getDarkTheme() {
    final darkTheme = AppPref.get(AppPrefKey.darkTheme, false) as bool;
    // log('displayName: $displayName');
    return darkTheme;
  }

  static Future<bool> setPhoneNumber({required String phoneNumber}) async {
    return AppPref.save(AppPrefKey.phoneNumber, phoneNumber);
  }

  static String getPhoneNumber() {
    final phoneNumber = AppPref.get(AppPrefKey.phoneNumber, '') as String;
    // log('displayName: $displayName');
    return phoneNumber;
  }

  static Future<bool> setEmail({required String email}) async {
    return AppPref.save(AppPrefKey.email, email);
  }

  static String getEmail() {
    final email = AppPref.get(AppPrefKey.email, '') as String;
    // log('displayName: $displayName');
    return email;
  }

  static Future<bool> setLanguage({required String language}) async {
    return AppPref.save(AppPrefKey.language, language);
  }

  static String getLanguage() {
    final language = AppPref.get(AppPrefKey.language, 'en') as String;

    return language;
  }

  static Future<bool> setFilterValue({required String filterValue}) async {
    return AppPref.save(AppPrefKey.filterValue, filterValue);
  }

  static String getFilterValue() {
    final filterValue = AppPref.get(AppPrefKey.filterValue, '1') as String;

    return filterValue;
  }

  static Future<bool> setSortProductBy({required String sortProductBy}) async {
    return AppPref.save(AppPrefKey.sortProductBy, sortProductBy);
  }

  static String getSortProductBy() {
    final sortProductBy =
        AppPref.get(AppPrefKey.sortProductBy, 'Warranty end date') as String;

    return sortProductBy;
  }

  static Future<bool> setDefaultWarrantyPeriod({
    required String defaultWarrantyPeriod,
  }) async {
    return AppPref.save(
      AppPrefKey.defaultWarrantyPeriod,
      defaultWarrantyPeriod,
    );
  }

  static String getDefaultWarrantyPeriod() {
    final defaultWarrantyPeriod =
        AppPref.get(AppPrefKey.defaultWarrantyPeriod, '') as String;

    return defaultWarrantyPeriod;
  }

  static Future<void> signOut() async {
    await AppPref.remove(AppPrefKey.uid);
    await AppPref.remove(AppPrefKey.displayName);
    await AppPref.remove(AppPrefKey.email);
    await AppPref.remove(AppPrefKey.phoneNumber);
    await AppPref.remove(AppPrefKey.defaultWarrantyPeriod);
  }
}
