import 'package:flutter/material.dart';
import 'package:renrakusen/home/views/home.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const Home(),
};
