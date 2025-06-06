import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo/modules/details/details.dart';
import '../core/core.dart';
import '../modules/modules.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r.module(Routes.home, module: HomeModule());
    r.module(Routes.details, module: DetailsModule());
  }
}
