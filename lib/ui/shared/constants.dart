import 'package:flutter/material.dart';

const Color appColor = Colors.amber;

const BoxDecoration colorBox = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [const Color(0xFFFF8F00), const Color(0xFFFFc107)],
  ),
);

bool isLoading = false;
