import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shine_schedule/widgets/toast.dart';
part 'opt_provider.g.dart';

@riverpod
class OptVerify extends _$OptVerify {
  @override
  FutureOr<String> build() {
    return "";
  }

  Future<String?> resendOtp({required String email}) async {}

  Future<String?> confirmOtp(
      {required String email, required String otp}) async {}
}
