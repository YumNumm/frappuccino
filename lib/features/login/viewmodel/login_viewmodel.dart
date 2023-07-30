import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:frappuccino/core/foundation/result.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

@riverpod
LoginViewModel loginViewModel(LoginViewModelRef ref) => LoginViewModel(ref);

class LoginViewModel {
  LoginViewModel(this.ref);

  final LoginViewModelRef ref;

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    }
    if (!EmailValidator.validate(value)) {
      return 'メールアドレスの形式が正しくありません';
    }
    return null;
  }

  Future<Result<void, Exception>> signIn(String email) async {
    try {
      final client = ref.read(supabaseClientProvider);
      await client.auth.signInWithOtp(
        email: email.trim(),
        emailRedirectTo:
            kIsWeb ? null : 'net.yumnumm.frappuccino://login-callback',
      );
      return const Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
