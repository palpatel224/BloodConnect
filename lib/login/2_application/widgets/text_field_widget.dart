import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final IconData? prefixIcon;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
    this.prefixIcon,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.obsecureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Icon(widget.prefixIcon,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    size: 22),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        suffixIcon: widget.obsecureText
            ? Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
      ),
      obscureText: widget.obsecureText ? !_passwordVisible : false,
    );
  }
}
