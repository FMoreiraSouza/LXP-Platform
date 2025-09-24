import 'package:flutter/widgets.dart';

abstract class PageDependency {
  void init();

  StatefulWidget getPage();
}
