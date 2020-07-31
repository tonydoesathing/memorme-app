import 'package:flutter/material.dart';

class FullscreenTextField extends StatefulWidget {
  final String text;
  final void Function(String value) onSave;

  FullscreenTextField({Key key, this.text, this.onSave}) : super(key: key);

  @override
  _FullscreenTextFieldState createState() => _FullscreenTextFieldState();
}

class _FullscreenTextFieldState extends State<FullscreenTextField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      _controller.value = TextEditingValue(
        text: widget.text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: widget.text.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.text != null ? Text("Edit Story") : Text("New Story"),
        actions: <Widget>[
          IconButton(
            key: Key('Check_icon'),
            icon: Icon(Icons.check),
            onPressed: () {
              if (widget.onSave != null) {
                widget.onSave(_controller.value.text);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              key: Key('Textfield'),
              controller: _controller,
              autofocus: true,
              maxLines: null,
              autocorrect: true,
            ),
          )
        ],
      ))),
    );
  }
}
