import 'package:flutter/material.dart';

class UiHelper {
  String ValidateInput(String? key) {
    return 'wrong';
  }

  static CustomTextField(
      TextEditingController controllerPass,
      String text,
      String labText,
      IconData icondata,
      bool toHide,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextFormField(
        controller: controllerPass,
        obscureText: toHide,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.green[100],
            hintText: text,
            labelText: labText,
            suffix: Icon(icondata),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      ),
    );
  }

  static CustomButton(VoidCallback voidCallback, String text) {
    return SizedBox(
      height: 40,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          voidCallback();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700], foregroundColor: Colors.black),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static CustomAlerbox(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  static customTitle() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'chit',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: 'Chat',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  static customMessageBox(String message,String time){
      return RichText(
        text: TextSpan(
          style: const TextStyle( fontSize: 15),
          children: [
            TextSpan(
              text: message,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            WidgetSpan(

              child: Transform.translate(
                offset: const Offset(4, 3),
                child: Text(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
