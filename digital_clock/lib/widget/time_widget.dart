import 'package:flutter/cupertino.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    Key key,
    @required this.hour,
    @required this.defaultStyle,
    @required this.minute,
  }) : super(key: key);

  final String hour;
  final TextStyle defaultStyle;
  final String minute;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              hour,
              style: defaultStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(':', style: defaultStyle),
            ),
            Text(
              minute,
              style: defaultStyle,
            ),
          ],
        ),
      ),
    );
  }
}
