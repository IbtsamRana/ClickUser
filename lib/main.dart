import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Auth/MobileNumber/UI/phone_number.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/language_cubit.dart';
import 'package:user/providerlist/offerlistprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Firebase.initializeApp();
  } catch (e) {}
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = prefs.getBool('islogin');
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kMainTextColor.withOpacity(0.5),
  ));
  runApp(
      Phoenix(child: (result != null && result) ? GoMarketHome() : GoMarket()));
}

class GoMarket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider<NotificationListCubit>(
          create: (context) => NotificationListCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return MaterialApp(
            builder: (context, child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaleFactor: 1.0),
                child: child,
              );
            },
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'),
              const Locale('hi'),
              const Locale('es'),
            ],
            locale: locale,
            theme: appTheme,
            home: PhoneNumber_New(),
            initialRoute: PageRoutes.loginRoot,
            routes: PageRoutes().routes(),
          );
        },
      ),
    );

    //   BlocProvider<LanguageCubit>(
    //   create: (context) => LanguageCubit(),
    //   child:
    // );
  }
}

class GoMarketHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(),
          ),
          BlocProvider<NotificationListCubit>(
            create: (context) => NotificationListCubit(),
          ),
        ],
        child: BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (_, locale) {
              return MaterialApp(
                builder: (context, child) {
                  final MediaQueryData data = MediaQuery.of(context);
                  return MediaQuery(
                    data: data.copyWith(textScaleFactor: 1.0),
                    child: child,
                  );
                },
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  const AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en'),
                  const Locale('hi'),
                  const Locale('es'),
                ],
                locale: locale,
                theme: appTheme,
                home: HomeOrderAccount(),
                initialRoute: PageRoutes.homeOrderAccountPage,
                routes: PageRoutes().routes(),
              );
            },
          ),
        ));
  }
}

// class GoMarketHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<LanguageCubit>(
//       create: (context) => LanguageCubit(),
//       child: BlocBuilder<LanguageCubit, Locale>(
//         builder: (_, locale) {
//           return MaterialApp(
//             builder: (context, child) {
//               final MediaQueryData data = MediaQuery.of(context);
//               return MediaQuery(
//                 data: data.copyWith(textScaleFactor: 1.0),
//                 child: child,
//               );
//             },
//             debugShowCheckedModeBanner: false,
//             localizationsDelegates: [
//               const AppLocalizationsDelegate(),
//               GlobalMaterialLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//             ],
//             supportedLocales: [
//               const Locale('en'),
//               const Locale('hi'),
//               const Locale('es'),
//             ],
//             locale: locale,
//             theme: appTheme,
//             home: HomeOrderAccount(),
//             initialRoute: PageRoutes.homeOrderAccountPage,
//             routes: PageRoutes().routes(),
//           );
//         },
//       ),
//     );
//   }
// }
