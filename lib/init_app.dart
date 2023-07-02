import 'package:Alemeno/util/config/environment.dart';
import 'package:easy_localization/easy_localization.dart';

initApp(EnvironmentType env) async {
  Environment.init(env);
  await EasyLocalization.ensureInitialized();
}
