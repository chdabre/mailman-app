import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mailman/bloc/address/bloc.dart';
import 'package:mailman/bloc/auth/bloc.dart';
import 'package:mailman/bloc/jobs/bloc.dart';
import 'package:mailman/routes/onboarding/get_credentials_screen.dart';
import 'package:mailman/routes/onboarding/get_started_screen.dart';
import 'package:mailman/routes/onboarding/login_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final GetIt getIt = GetIt.instance;

class SignUpModal {
  static SignUpModal? _instance;

  bool _signupInProgress = false;

  SignUpModal._();

  static SignUpModal get instance => _instance ??= SignUpModal._();

  void _onComplete() {
    _signupInProgress = false;
  }

  void startSignUp({
    required BuildContext context,
  }) {

    if (!_signupInProgress) {
      _signupInProgress = true;
      showCupertinoModalBottomSheet(
          expand: true,
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) => const Material(
            child: Scaffold(
              body: SafeArea(
                child: OnboardingFlow(),
              ),
            ),
          )
      ).whenComplete(_onComplete);
    }
  }
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final authBloc = getIt<AuthenticationBloc>();
  late PageController _pageController;
  final List<Widget> _views = [];

  Widget? _getInitialScreen() {
    if (authBloc.state is Unauthenticated) {
      return _buildGetStartedScreen();
    }

    return _buildGetCredentialsScreen();
  }

  Widget _buildGetStartedScreen() {
    return GetStartedScreen(
      onLoginPressed: () => _pushView(_buildLoginSignupScreen(true)),
      onSignUpPressed: () => _pushView(_buildLoginSignupScreen(false)),
    );
  }

  Widget _buildLoginSignupScreen(bool willLogin) {
    return LoginSignupScreen(
      willLogin: willLogin,
      onAuthCompleted: _authCompleted,
    );
  }

  void _authCompleted() {
    getIt<AddressBloc>().add(RefreshAddressList());
    getIt<JobsBloc>().add(RefreshJobsList());
    _pushView(_buildGetCredentialsScreen());
  }

  Widget _buildGetCredentialsScreen() {
    return GetCredentialsScreen(
        onCredentialsReceived: () => Navigator.pop(context)
    );
  }

  void _pushView(Widget view) {
    _views.add(view);
    setState(() {});
    _pageController.animateToPage(_views.length - 1,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut
    );
  }

  @override
  void initState() {
    _pageController = PageController();

    var initialScreen = _getInitialScreen();
    if (initialScreen != null) {
      _views.add(initialScreen);
    } else {
      Navigator.pop(context);
    }

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _views.length,
      itemBuilder: (_, index) => _views[index],
    );
  }
}