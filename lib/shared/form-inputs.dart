import 'package:flutter/material.dart';
import 'package:le_bon_mot/validate/validate.dart';

class FormInput {
  static Widget email({
    Key? key,
    bool autofocus = false,
    TextEditingController? controller,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autofocus: autofocus,
      validator: Validate.email,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "jon@doe.org",
      ),
    );
  }

  static Widget password({
    Key? key,
    TextEditingController? controller,
    String? labelText = "Password",
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      validator: Validate.password,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
