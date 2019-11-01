import 'package:carros_flutter_web/imports.dart';
import 'package:carros_flutter_web/pages/chart/charts_page.dart';
import 'package:carros_flutter_web/routes.dart';
import 'package:fluro/fluro.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => AppModel(),
        ),
        ChangeNotifierProvider(
          builder: (context) => PagesModel(),
        )
      ],
      child: MyMaterialApp(),
    );
  }
}

final router = Router();

class MyMaterialApp extends StatelessWidget {

  MyMaterialApp() {
    final router = Router();
    Routes.configureRoutes(router);
    App.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme(context),
      onGenerateRoute: App.router.generator,
    );
  }

  _theme(context) {
    AppModel app = AppModel.get(context, listen: true);

    bool admin = app.user == null || app.user.isAdmin();

    return admin ? _themeAdmin() : _themeUser();
  }

  _themeUser() {
    return ThemeData(
      fontFamily: "Raleway",
      primaryColor: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.blue[600],
      textTheme: TextTheme(
        body1: TextStyle(
          color: AppColors.blue,
          fontSize: 18,
        ),
      ),
    );
  }

  _themeAdmin() {
    return ThemeData(
      fontFamily: "Raleway",
      primaryColor: AppColors.blue,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.blue[600],
      textTheme: TextTheme(
        body1: TextStyle(
          color: AppColors.blue,
          fontSize: 22,
        ),
      ),
    );
  }
}
