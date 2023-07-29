import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frappuccino/core/router/router.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isEmailValid = useState(false);
    final redirecting = useState(false);

    final emailController = useTextEditingController();
    final client = ref.watch(supabaseClientProvider);
    final authStateSubscription =
        useMemoized(() => client.auth.onAuthStateChange, []);

    Future<void> signIn() async {
      final email = emailController.text;
      if (email.isEmpty) {
        return;
      }
      try {
        isLoading.value = true;
        await client.auth.signInWithOtp(
          email: email.trim(),
          emailRedirectTo: kIsWeb
              ? null
              : Platform.isIOS
                  ? 'net.ysf-frappuccino.frappuccino://login-callback'
                  : 'net.ysf_frappuccino.frappuccino://login-callback',
        );
        if (context.mounted) {
          emailController.clear();
          // メール送信完了ダイアログ
          await showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('メール送信完了'),
              content: const Text('メールを送信しました。メール内のリンクをタップしてログインしてください。'),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } on AuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: ${error.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('予期せぬエラーが発生しました。時間を置いて再度お試しください。\n$error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
      isLoading.value = false;
    }

    useEffect(
      () {
        WidgetsBinding.instance.endOfFrame.then((_) {
          authStateSubscription.listen((event) {
            if (redirecting.value) {
              return;
            }
            final session = event.session;
            if (session != null) {
              redirecting.value = true;
              context.go(const HomeRoute().location);
            }
          });
        });
        isLoading.addListener(() {
          if (isLoading.value) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            Navigator.of(context).pop();
          }
        });
        emailController.addListener(() {
          isEmailValid.value =
              EmailValidator.validate(emailController.text.trim());
        });
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('YSF Frappuccinoにログインするためには、登録時に使用したメールアドレスを入力してください。'),
          const SizedBox(height: 18),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'メールアドレス'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'メールアドレスを入力してください';
              }
              if (!EmailValidator.validate(value)) {
                return 'メールアドレスの形式が正しくありません';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // outlined
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: !isLoading.value && isEmailValid.value ? signIn : null,
            child: Text(isLoading.value ? '処理中...' : 'メールでログイン'),
          ),
        ],
      ),
    );
  }
}
