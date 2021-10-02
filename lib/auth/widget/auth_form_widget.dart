import 'package:flutter/material.dart';

class AuthFormWidget extends StatefulWidget {
  final Function(
    String email,
    String password,
    String username,
    bool isLogin,
  ) submitFunction;
  final bool isLoading;

  const AuthFormWidget({required this.submitFunction, required this.isLoading});

  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Can\'t be blank';
    if (!email.contains('@')) return 'Email isn\'t valid';

    return null;
  }

  String? _validateUserName(String? username) {
    if (username == null || username.isEmpty) return 'Can\'t be blank';
    if (username.length < 4) return 'Too short name. At least 4 characters';

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Can\'t be blank';
    if (password.length < 8) return 'Too short name. At least 8 characters';

    return null;
  }

  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _username = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    print('validation result: $isValid');

    if (isValid) {
      _formKey.currentState?.save();
      widget.submitFunction(
        _email.trim(),
        _password.trim(),
        _username.trim(),
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (email) => (_email = email ?? ''),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: _validateUserName,
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (username) => (_username = username ?? ''),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: _validatePassword,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (password) => (_password = password ?? ''),
                  ),
                  SizedBox(height: 16),
                  if (widget.isLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Log In' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogin
                            ? 'Create an account'
                            : 'I already have an account',
                      ),
                      onPressed: () {
                        setState(() => _isLogin = !_isLogin);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
