import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthStatus extends _$AuthStatus {
  bool? status;
  @override
  FutureOr<bool?> build() async {
    return authStatus();
  }

  Future<bool?> authStatus() async {
    return await SharedPreferenced().getLoginStatus();
  }
}
