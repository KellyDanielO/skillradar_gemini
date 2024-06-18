import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/sizes.dart';

class SetupAccountScreen extends ConsumerStatefulWidget {
  const SetupAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetupAccountScreenState();
}

class _SetupAccountScreenState extends ConsumerState<SetupAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( 
          'Set Up Account',
          style: TextStyle(
            fontSize: AppSizes.mediumSize,
          ),
        ),
      ),
    );
  }
}
