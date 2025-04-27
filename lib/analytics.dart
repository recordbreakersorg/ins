import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics? analytics;
Future<void> intializeAnalytics() async {
  analytics = FirebaseAnalytics.instance;
}

Future<void> logEvent({
  required String name,
  Map<String, Object>? parameters,
}) async {
  if (analytics == null) {
    return;
  }
  await analytics!.logEvent(name: name, parameters: parameters);
}

Future<void> setUserId(String userId) async {
  if (analytics == null) {
    return;
  }
  await analytics!.setUserId(id: userId);
}

Future<void> setUserProperty({
  required String name,
  required String value,
}) async {
  if (analytics == null) {
    return;
  }
  await analytics!.setUserProperty(name: name, value: value);
}

Future<void> screen(String screenName) async {
  if (analytics == null) {
    return;
  }
  await analytics!.logScreenView(screenName: screenName);
}

Future<void> signin(String username, String method) async {
  if (analytics == null) {
    return;
  }
  await analytics!.setUserId(id: username);
  await analytics!.setUserProperty(name: 'username', value: username);
  await analytics!.logLogin(loginMethod: method);
}

Future<void> signout() async {
  if (analytics == null) {
    return;
  }
  await analytics!.setUserId(id: null);
  await analytics!.setUserProperty(name: 'username', value: null);
}

Future<void> signup(String username, String method) async {
  if (analytics == null) {
    return;
  }
  await analytics!.setUserId(id: username);
  await analytics!.setUserProperty(name: 'username', value: username);
  await analytics!.logSignUp(signUpMethod: method);
}

Future<void> schoolProfile(String schoolName) async {
  if (analytics == null) {
    return;
  }
  await analytics!.logEvent(
    name: 'view_school_profile',
    parameters: {'school_name': schoolName},
  );
  await FirebaseAnalytics.instance.logBeginCheckout(
    value: 10.0,
    currency: 'USD',
    items: [
      AnalyticsEventItem(itemName: 'Socks', itemId: 'xjw73ndnw', price: 10.0),
    ],
    coupon: '10PERCENTOFF',
  );
}

Future<void> schoolApply(String schoolName) async {
  if (analytics == null) {
    return;
  }
  await analytics!.logEvent(
    name: 'school_apply',
    parameters: {'school_name': schoolName},
  );
}

Future<void> schoolApplySubmit(String schoolName) async {
  if (analytics == null) {
    return;
  }
  await analytics!.logEvent(
    name: 'school_apply',
    parameters: {'school_name': schoolName},
  );
}
