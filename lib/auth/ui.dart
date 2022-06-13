import 'package:flutter/material.dart';
import 'package:le_bon_mot/auth/authenticator.dart';
import 'package:le_bon_mot/shared/form-inputs.dart';

const _signUpLabel = "SIGN UP";
const _signInLabel = "SIGN IN";

// AuthWrapper ensures user is connected
class AuthWrapper extends StatelessWidget {
  final Widget child;
  final Authenticator authenticator;

  const AuthWrapper(
      {Key? key, required this.child, required this.authenticator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthStatus>(
      stream: authenticator.authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<AuthStatus> snapshot) {
        switch (snapshot.data) {
          case null:
          case AuthStatus.initializing:
            return const Center(child: CircularProgressIndicator());
          case AuthStatus.connected:
            return child;
          case AuthStatus.disconnected:
            return Center(child: SignForm(authenticator: authenticator));
        }
      },
    );
  }
}

enum AuthFormStatus {
  signIn,
  signUp,
}

class SignForm extends StatefulWidget {
  final Authenticator authenticator;

  const SignForm({Key? key, required this.authenticator}) : super(key: key);

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  AuthFormStatus _status = AuthFormStatus.signIn;
  String _error = "";
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _sign() async {
    // ignore user interaction if still loading from previous interaction
    if (_loading) return;
    final fn = _status == AuthFormStatus.signIn ? _signIn : _signUp;
    try {
      setState(() => _loading = true);
      await fn();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    return widget.authenticator.signInWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _confirmPassword.text) {
      const errMsg = "Password and confirmation does not match";
      return setState(() => _error = errMsg);
    }
    return widget.authenticator.signUpWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSize(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 300),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormInput.email(controller: _email),
                  FormInput.password(controller: _password),
                  if (_status == AuthFormStatus.signUp)
                    FormInput.password(
                      controller: _confirmPassword,
                      labelText: "Confirm password",
                    ),
                  Container(height: 24.0),
                  _submitButton(),
                  _switchStatusButton(),
                  if (_error.isNotEmpty) _errorMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  _switchStatus() {
    setState(() {
      if (_status == AuthFormStatus.signIn) {
        _status = AuthFormStatus.signUp;
      } else {
        _status = AuthFormStatus.signIn;
      }
      _error = "";
    });
  }

  Widget _errorMessage() {
    return Text(_error, style: const TextStyle(color: Colors.red));
  }

  Widget _switchStatusButton() {
    return TextButton(
      onPressed: _switchStatus,
      child: _switchStatusText(),
    );
  }

  Widget _submitButton() {
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
          onPressed: _sign,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _submitButtonText(),
              if (_loading)
                Row(
                  children: [
                    Container(width: 12.0),
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
            ],
          )),
    );
  }

  Widget _submitButtonText() {
    if (_status == AuthFormStatus.signIn) {
      return const Text(_signInLabel);
    }
    return const Text(_signUpLabel);
  }

  Widget _switchStatusText() {
    const style = TextStyle(color: Colors.grey);
    if (_status == AuthFormStatus.signIn) {
      return const Text(_signUpLabel, style: style);
    }
    return const Text(_signInLabel, style: style);
  }
}
