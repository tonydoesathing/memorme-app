import 'package:flutter/material.dart';

/// An animated indicator to show that the app is loading something
class LoadingIndicator extends StatelessWidget {
  final double width;
  final double height;
  const LoadingIndicator({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // if we have a width and height, create a sized box component
      child: (width != null && height != null)
          ? SizedBox(
              width: width,
              height: height,
              child: CircularProgressIndicator(
                value: null,
              ),
            )
          //otherwise, just create the widget
          : CircularProgressIndicator(
              value: null,
            ),
    );
  }
}
