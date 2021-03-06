import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:news/src/App.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/models/category/category.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:news/src/models/user/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = BlocObserver();

  if (!kIsWeb) {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();

    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(AppUserAdapter())
      ..registerAdapter(ArticleAdapter())
      ..registerAdapter(SourceAdapter())
      ..registerAdapter(CategoryAdapter());
  } else {
    Hive
      ..initFlutter()
      ..registerAdapter(AppUserAdapter())
      ..registerAdapter(ArticleAdapter())
      ..registerAdapter(SourceAdapter())
      ..registerAdapter(CategoryAdapter());
  }

  await Hive.openBox<AppUser>('user');

  FlavorConfig(
    name: "UAT",
    color: Colors.blue,
    location: BannerLocation.topStart,
  );

  runApp(
    new BlocProvider(
      create: (_) => LanguageBloc()..add(LanguageLoadStarted()),
      child: App(),
    ),
  );
}
