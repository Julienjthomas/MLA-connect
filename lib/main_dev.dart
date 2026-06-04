import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/app_flavor.dart';
import 'initializer.dart';

void main() async {
  await Initializer().init(AppFlavor.dev, () => runApp(const MlaConnectApp()));
}
