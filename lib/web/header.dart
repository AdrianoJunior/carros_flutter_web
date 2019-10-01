import 'package:carros_flutter_web/app_model.dart';
import 'package:carros_flutter_web/imports.dart';
import 'package:carros_flutter_web/pages/login/usuario.dart';
import 'package:carros_flutter_web/pages/senha/alterar_senha_page.dart';
import 'package:carros_flutter_web/pages/usuarios/meus_dados_page.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  GlobalKey _menuState = GlobalKey();

  Size get size => MediaQuery.of(context).size;

  Usuario get user => AppModel.get(context).user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FlutterLogo(
        size: 50,
      ),
      title: Text(
        "Carros ${size.width}/${size.height}",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      trailing: _right(),
    );
  }

  _right() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "${user?.nome}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(
          width: 20,
        ),
        InkWell(
          child: CircleAvatar(
            backgroundImage: NetworkImage("${user?.urlFoto}"),
          ),
          onTap: () {
            // abre o popup menu
            dynamic state = _menuState.currentState;
            state.showButtonMenu();
          },
        ),
        PopupMenuButton<String>(
          key: _menuState,
          padding: EdgeInsets.zero,
          onSelected: (value) {
            _onClickOptionMenu(context, value);
          },
          child: Icon(
            Icons.arrow_drop_down,
            size: 28,
            color: Colors.white,
          ),
          itemBuilder: (BuildContext context) => _getActions(),
        ),
      ],
    );
  }

  _getActions() {
    return <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: "meus_dados",
        child: Text("Meus dados"),
      ),
      PopupMenuItem<String>(
        value: "alterar_senha",
        child: Text("Alterar senha"),
      ),
      PopupMenuItem<String>(
        value: "logout",
        child: Text("Logout"),
      ),
    ];
  }

  void _onClickOptionMenu(context, String value) {
    print("_onClickOptionMenu $value");
    if ("logout" == value) {
      logout(context);
    } else if ("meus_dados" == value) {
      Usuario user = AppModel.get(context).user;
      PagesModel.get(context).push(PageInfo("Meus Dados", MeusDadosPage(user)));
    } else if ("alterar_senha" == value) {
      PagesModel.get(context).push(PageInfo("Alterar Senha", AlterarSenhaPage()));
    } else {}
  }
}

// global
void logout(context) {
  Usuario.clear();

  push(context, LoginPage(), replace: true);

  PagesModel.get(context).popAll();
}
