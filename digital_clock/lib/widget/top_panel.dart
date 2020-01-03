import 'package:flutter/cupertino.dart';

class TopPanel extends StatelessWidget {
  const TopPanel({
    Key key,
    @required this.margin,
    @required String temperature,
    @required this.defaultStyle2,
    @required String location,
  })  : _temperature = temperature,
        _location = location,
        super(key: key);

  final double margin;
  final String _temperature;
  final TextStyle defaultStyle2;
  final String _location;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: margin * 5.5),
      child: Column(
        children: <Widget>[
          //Temperature
          Text(
            _temperature,
            style: defaultStyle2,
          ),
          //Location
          Text(
            _location,
            style: defaultStyle2,
          ),
        ],
      ),
    );
  }
}
