import 'package:flutter/material.dart';

// No Cubit here, no Colors.red, no @JsonSerializable(), no ChangeNotifier.
/* EdgeInsets.all(8) and Text('Olá') in a block comment
   /* nested: SizedBox(height: 16) */
*/
class CubitTest {}
const note = 'Cubit and Colors.red and ChangeNotifier are only text here';
const map = {'title': 'Olá mundo', 'text': 'Texto'};
const key = Key('submit_button');

Widget build() => Column(children: [
  Text(AppStrings.title),
  Text('${count}'),
  Text('$count'),
  Text(':'),
  Text('12:30'),
  Container(color: Colors.transparent, padding: EdgeInsets.zero),
  SizedBox(height: spacing.md),
  Text('${map['x']}'),
]);

void log() {
  debugPrint('texto solto de log');
}
