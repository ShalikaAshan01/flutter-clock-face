import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';

class FlareAnimation extends StatelessWidget {
  const FlareAnimation({
    Key key,
    @required this.margin,
    @required this.size,
    @required this.flareSize,
    @required String flare,
    this.padding = 0,
  })  : _flare = flare,
        super(key: key);

  final double margin;
  final double padding;
  final Size size;
  final double flareSize;
  final String _flare;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: margin),
      width: size.width,
      child: AnimatedContainer(
        padding: EdgeInsets.only(top: padding),
        duration: Duration(seconds: 1),
        height: flareSize,
        width: flareSize,
        child: FlareActor(
          _flare,
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'go',
        ),
      ),
    );
  }
}
