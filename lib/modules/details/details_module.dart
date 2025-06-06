import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo/modules/details/modules/comments/comments.dart';
import 'package:photo/modules/details/modules/photo_details/photo_details_module.dart';

import '../../core/core.dart';

class DetailsModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module(Routes.detailsPhoto, module: DetailsPhotoModule());
    r.module(Routes.commentsPhoto, module: CommentsPhotoModule());
  }
}