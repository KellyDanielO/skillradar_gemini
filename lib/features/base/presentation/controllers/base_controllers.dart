import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../constants/enums.dart';
import '../provider/providers.dart';

class BaseController {
  Future<void> fetchFeedData({required WidgetRef ref}) async {
    String? accessToken = await AppHelpers().getData('access_token');
    String? refreshToken = await AppHelpers().getData('refresh_token');
    ref.read(feedStateNotifierProvider.notifier).change(FeedState.loading);

    final globalUser = ref.read(gobalUserNotifierProvider);
    if (globalUser!.skills.isNotEmpty) {
      ref.read(baseListenerProvider.notifier).getFeedData(
          ref: ref, accessToken: accessToken!, refreshToken: refreshToken!);
    }
  }
}
