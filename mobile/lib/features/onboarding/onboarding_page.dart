import 'package:flutter/material.dart';

import 'widgets/onboarding_appbar.dart';
import 'widgets/onboarding_button.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_logo.dart';

class OnboardingPage
    extends StatelessWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingAppBar(),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: const [
                  OnboardingLogo(),
                  SizedBox(height: 30),
                  OnboardingContent(),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(
                24,
              ),
              child:
                  OnboardingButton(
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}