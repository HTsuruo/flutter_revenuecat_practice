import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_revenuecat_practice/logger.dart';
import 'package:flutter_revenuecat_practice/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

class SimplePurchasePage extends ConsumerWidget {
  const SimplePurchasePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authenticator);
    final purchase = ref.watch(purchaseStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Demo'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authRepository).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: colorScheme.primary.withOpacity(.2),
            padding: const EdgeInsets.all(8),
            child: Text('uid: ${user?.uid}'),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user == null)
                    OutlinedButton(
                      onPressed: () async {
                        final userCredential = await ref
                            .read(progressController)
                            .executeWithProgress(
                              () => ref.read(authRepository).signInWithGoogle(),
                            );
                        logger.fine(userCredential?.user?.uid);
                      },
                      child: const Text('Google Sign in'),
                    ),
                  if (user != null)
                    OutlinedButton(
                      onPressed: () async {
                        await Purchases.purchaseProduct('test_product_id');
                      },
                      child: const Text('HOGE'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}