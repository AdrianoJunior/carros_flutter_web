import 'package:carros_flutter_web/app_model.dart';
import 'package:carros_flutter_web/colors.dart';
import 'package:carros_flutter_web/pages/login/login_bloc.dart';
import 'package:carros_flutter_web/pages/login/usuario.dart';
import 'package:carros_flutter_web/utils/alert.dart';
import 'package:carros_flutter_web/utils/api_response.dart';
import 'package:carros_flutter_web/widgets/app_button.dart';
import 'package:carros_flutter_web/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

abstract class LoginCallback {
  cadastrar();

  esqueciSenha();

  loginOk(Usuario user);
}

class LoginForm extends StatefulWidget {
  LoginCallback callback;
  bool showTitle;

  LoginForm({@required this.callback, this.showTitle = false});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginCallback get callback => widget.callback;

  bool get showTitle => widget.showTitle;

  AppModel get app => AppModel.get(context);

  final _formKey = GlobalKey<FormState>();

  final _loginBloc = LoginBloc();

  final _tLogin = TextEditingController(text: "admin");

  final _tSenha = TextEditingController(text: "123");

  final _focusSenha = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          showTitle
              ? Container(
                  child: Center(
                    child: Text(
                      "Carros",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Container(),
          AppTextField(
            label: "Login",
            hint: "Digite o login",
            controller: _tLogin,
            validator: (s) => _validateLogin(s),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            nextFocus: _focusSenha,
          ),
          SizedBox(height: 10),
          AppTextField(
            label: "Senha",
            hint: "Digite a senha",
            controller: _tSenha,
            password: true,
            validator: _validateSenha,
            keyboardType: TextInputType.number,
            focusNode: _focusSenha,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Manter logado",
                    style: TextStyle(color: AppColors.blue, fontSize: 14),
                  ),
                  Checkbox(
                    value: true,
                    onChanged: (b) => print(b),
                  ),
                ],
              ),
              InkWell(
                onTap: _onClickEsqueciSenha,
                child: Center(
                  child: Text(
                    "Esqueci a senha",
                    style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: StreamBuilder<bool>(
              stream: _loginBloc.progress.stream,
              initialData: false,
              builder: (context, snapshot) {
                return AppButton(
                  "Login",
                  onPressed: _onClickLogin,
                  showProgress: snapshot.data,
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ainda não é cadastrado?",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.underline),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: _onClickCadastrar,
                child: Center(
                  child: Text(
                    "Crie uma conta",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onClickLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tSenha.text;

    print("Login: $login, Senha: $senha");

    ApiResponse<Usuario> response =
        await _loginBloc.login(context, login, senha);
    print(response);

    if (response.ok) {
      Usuario user = response.result;
      callback.loginOk(user);
    } else {
      alert(context, response.msg);
    }
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Digite o login";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter pelo menos 3 números";
    }
    return null;
  }

  void _onClickEsqueciSenha() {
    callback.esqueciSenha();
  }

  void _onClickCadastrar() {
    callback.cadastrar();
  }

  @override
  void dispose() {
    super.dispose();

    _loginBloc.dispose();
  }
}
