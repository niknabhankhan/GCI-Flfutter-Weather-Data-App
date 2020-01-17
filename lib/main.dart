import 'package:flutter/material.dart';
import './ui/homepage.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Weather',
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    )
  );
}