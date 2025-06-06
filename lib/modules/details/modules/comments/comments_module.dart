import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo/modules/details/modules/comments/comments_page.dart';

 class CommentsPhotoModule extends Module {
  @override
  void binds(i) {
  }

  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      child: (context) => CommentsPhoto()
    );
  }
}