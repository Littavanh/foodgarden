

import 'package:foodgarden/style/color.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key, required this.onPressed}) : super(key: key);
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
            tooltip: 'ເບິ່ງລາຍລະອຽດ',
            iconSize: 20,
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: const Icon(Icons.remove_red_eye, color: primaryColor)));
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key, required this.onPressed}) : super(key: key);
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
            tooltip: 'ລົບ',
            iconSize: 35,
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: const Icon(Icons.cancel, color: Colors.red)));
  }
}
class ConfirmButton extends StatelessWidget {
  const ConfirmButton({Key? key, required this.onPressed}) : super(key: key);
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
            tooltip: 'ຢືນຢັນ',
            iconSize: 35,
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: const Icon(Icons.task_alt, color: primaryColor)));
  }
}
