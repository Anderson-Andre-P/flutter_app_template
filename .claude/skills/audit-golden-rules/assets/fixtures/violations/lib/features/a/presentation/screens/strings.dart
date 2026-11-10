import 'package:flutter/material.dart';

Widget build() => Column(children: [
  Text('Olá mundo'),
  Text(AppStrings.title),
  Text('${count}'),
  Text(':'),
  TextField(decoration: InputDecoration(hintText: 'Digite o nome')),
  ElevatedButton(onPressed: f, child: Text('OK')),
]);
