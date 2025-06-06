import 'package:flutter_modular/flutter_modular.dart';
import 'photo_details.dart';

 class DetailsPhotoModule extends Module {
  @override
  void binds(i) {
  }

  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const DetailsPhoto()
    );
  }
}