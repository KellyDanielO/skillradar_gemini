import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider_classes.dart';

final buttonLoadingNotifierProvider = StateNotifierProvider<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});