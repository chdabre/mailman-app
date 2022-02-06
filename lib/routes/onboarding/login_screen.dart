import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/bloc/auth/bloc.dart';
import 'package:mailman/components/alert.dart';
import 'package:mailman/components/terms_button.dart';
import 'package:mailman/utils/validation.dart';

final GetIt getIt = GetIt.instance;

class LoginSignupScreen extends StatefulWidget {
  final bool willLogin;
  final void Function()? onAuthCompleted;

  const LoginSignupScreen({
    Key? key,
    this.willLogin = false,
    this.onAuthCompleted,
  }) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authBloc = getIt<AuthenticationBloc>();
  bool _signUp = true;

  void _switchMode() {
    _signUp = !_signUp;
    setState(() {});
  }

  void _loginAction(String username, String password) {
    _authBloc.add(
        Login(username, password)
    );
  }

  void _signupAction(String email, String password) {
    _authBloc.add(
        SignUp(email, password)
    );
  }

  @override
  void initState() {
    _signUp = !widget.willLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: _signUp ?
        UsernamePasswordForm(
          switchMode: _switchMode,
          onAuthCompleted: widget.onAuthCompleted,
          submitButtonPressed: _signupAction,
          title: AppLocalizations.of(context)!.loginCreateAccountTitle,
          submitButtonText: AppLocalizations.of(context)!.loginCreateAccountSubmitButton,
          switchModeText: AppLocalizations.of(context)!.loginSwitchToLoginButton,
        ) :
        UsernamePasswordForm(
          switchMode: _switchMode,
          onAuthCompleted: widget.onAuthCompleted,
          submitButtonPressed: _loginAction,
          title: AppLocalizations.of(context)!.loginLoginTitle,
          submitButtonText:AppLocalizations.of(context)!.loginLoginSubmitButton,
          switchModeText: AppLocalizations.of(context)!.loginSwitchToSignUpButton,
        )
    );
  }
}

class UsernamePasswordForm extends StatefulWidget {
  final void Function()? onAuthCompleted;
  final void Function() switchMode;
  final void Function(String username, String password) submitButtonPressed;
  final String title;
  final String submitButtonText;
  final String switchModeText;

  const UsernamePasswordForm({
    Key? key,
    required this.switchMode,
    required this.submitButtonPressed,
    required this.title,
    required this.submitButtonText,
    required this.switchModeText,
    this.onAuthCompleted
  }) : super(key: key);

  @override
  _UsernamePasswordFormState createState() => _UsernamePasswordFormState();
}

class _UsernamePasswordFormState extends State<UsernamePasswordForm> {
  final _authBloc = getIt<AuthenticationBloc>();

  final _formKey = GlobalKey<FormState>();
  final _scopeNode = FocusScopeNode();

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _hasError = false;
  String? _errorMessage = "";

  void _submitButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _hasError = false;
      widget.submitButtonPressed(_usernameController.text, _passwordController.text);
    }
    setState(() {});
  }

  void _formInputChanged() {
    _hasError = false;
    setState(() {});
  }

  void _switchModePressed() {
    _hasError = false;
    widget.switchMode.call();
  }

  void _authListener(BuildContext context, AuthenticationState state) {
    if (state is Authenticated) {
      widget.onAuthCompleted?.call();
    }

    if (state is LoginResult) {
      if (state.success == false) {
        _hasError = true;
        _errorMessage = state.errorMessage;
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: _authBloc,
      listener: _authListener,
      builder: (_, authState) {
        return LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(widget.title, style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      Text(AppLocalizations.of(context)!.loginDescription),
                      const SizedBox(height: 24.0,),
                      FocusScope(
                        node: _scopeNode,
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: _formInputChanged,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                validator: emailValidator(context),
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _scopeNode.nextFocus,
                                decoration: InputDecoration(
                                    label: Text(AppLocalizations.of(context)!.formFieldEmail),
                                    border: const OutlineInputBorder()
                                ),
                              ),
                              const SizedBox(height: 16.0,),
                              TextFormField(
                                validator: nonEmptyStringValidator(context),
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: _submitButtonPressed,
                                decoration: InputDecoration(
                                  label: Text(AppLocalizations.of(context)!.formFieldPassword),
                                  border: const OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                              if (_hasError) ...[
                                Alert(errorMessage: _errorMessage),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                                    child: Text(AppLocalizations.of(context)!.loginTermsLabel, style: Theme.of(context).textTheme.caption,),
                                  ),
                                ),
                                const VerticalDivider(width: 0, indent: 4, endIndent: 4,),
                                const TermsButton()
                              ],
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                              ),
                              onPressed: authState is LoggingIn ? null : _submitButtonPressed,
                              child: Text(widget.submitButtonText.toUpperCase())
                          ),
                          TextButton(
                            onPressed: authState is LoggingIn ? null : _switchModePressed,
                            child: Text(widget.switchModeText,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
}