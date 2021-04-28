import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:news/src/blocs/login_bloc/login_cubit.dart';
import 'package:news/src/ui/reset-password/reset_password_page.dart';
import 'package:news/src/ui/sign_up/sign_up_page.dart';
import 'package:news/src/utils/app_localizations.dart';
import '../dialogs/message_dialog.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          MessageDialog.showMessageDialog(
            context: context,
            title: AppLocalizations.of(context)
                .translate('incorrect_credentials_title'),
            body: AppLocalizations.of(context)
                .translate('incorrect_credentials_body'),
          );
        } else if (state.status.isSubmissionSuccess && !state.emailVerified) {
          MessageDialog.showMessageDialog(
            context: context,
            title: AppLocalizations.of(context)
                .translate('email_not_verified_title'),
            body: AppLocalizations.of(context)
                .translate('email_not_verified_body'),
          );
        }
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('login'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _EmailInput(),
                SizedBox(height: 8.0),
                _PasswordInput(),
                SizedBox(height: 8.0),
                _LoginButton(),
                SizedBox(height: 16.0),
                _GoogleLoginButton(),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacement(ResetPasswordPage.route()),
                  child: Text(
                    AppLocalizations.of(context).translate('reset_password'),
                  ),
                ),
                SizedBox(height: 24.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(SignUpPage.route()),
                  child:
                      Text(AppLocalizations.of(context).translate('sign_up')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: AppLocalizations.of(context).translate('email'),
            helperText: '',
            errorText: state.email.invalid
                ? AppLocalizations.of(context).translate('invalid_email')
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.vpn_key),
              labelText: AppLocalizations.of(context).translate('password'),
              helperText: '',
              errorText: state.password.invalid
                  ? AppLocalizations.of(context).translate('invalid_password')
                  : null,
            ),
            onSubmitted: (value) async {
              if (state.status.isValidated)
                await context.read<LoginCubit>().logInWithCredentials();
            });
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? CircularProgressIndicator()
            : Container(
                width: 200,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    primary: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      AppLocalizations.of(context).translate('log_in'),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  onPressed: state.status.isValidated
                      ? () async {
                          await context
                              .read<LoginCubit>()
                              .logInWithCredentials();
                        }
                      : null,
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: Key('loginForm_googleLogin_raisedButton'),
      label: Text(
        'Google',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: theme.accentColor,
      ),
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
      ),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}
