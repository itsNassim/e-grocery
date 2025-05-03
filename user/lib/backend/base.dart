import 'package:hive/hive.dart';
import 'package:user/backend/auth/auth.dart';

const String baseUrl = 'http://10.0.2.2:8000/api';

Future<String?> getToken() async {
  final box = Hive.box("mybox");
  final token = box.get('token');
  final refreshToken = token["refresh"];
  final accessToken = await refreshAccessToken(refreshToken);
  return accessToken;
}
