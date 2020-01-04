import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/blocs/categories_bloc.dart';
import 'package:mega_dot_pk/pages/splash_screen_page.dart';
import 'package:mega_dot_pk/utils/app_theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MegaDotPKApp());

class MegaDotPKApp extends StatefulWidget {
  @override
  _MegaDotPKAppState createState() => _MegaDotPKAppState();
}

class _MegaDotPKAppState extends State<MegaDotPKApp> {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<CartBLOC>(create: (_) => CartBLOC()),
          ChangeNotifierProvider<CategoriesBLOC>(
              create: (_) => CategoriesBLOC()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.data(),
          home: SplashScreenPage(),
        ),
      );
}
