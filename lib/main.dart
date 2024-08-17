import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_time/layout/shop_layout.dart';
import 'package:shopping_time/modules/login/shop_login.dart';
import 'package:shopping_time/shared/Bloc_observer.dart';
import 'package:shopping_time/shared/network/local/cache_helper.dart';
import 'package:shopping_time/shared/network/remote/dio_helper.dart';
import 'package:shopping_time/shared/styles/themes.dart';

import 'layout/shop_cubit/shop_cubit.dart';
import 'modules/on_boarding/on_boarding_screen.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized(); //saved small things

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');
  String? token = CacheHelper.getData(key: 'token');
  print(token);


  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  if(onBoarding != null)
  {
    if(token != null) {
      widget = const ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
      }
  else
    {
      widget = const OnBoardingScreen();
    }


  isDark ??= false;

  runApp( MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget
{

  final bool? isDark;
  final Widget? startWidget;
  final String? token = CacheHelper.getData(key: 'token');

  MyApp({
    super.key,
    this.isDark,
    this.startWidget,

  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
        ShopCubit(token: token)
          ..getHomeData()
          ..getCategories()
          ..getFavorites()
          ..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        // // //themeMode: ShopCubit.get(context).isDark
        // //     ? ThemeMode.dark
        // //     : ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}


