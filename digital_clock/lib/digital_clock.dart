// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/widget/background.dart';
import 'package:digital_clock/widget/clock_thick.dart';
import 'package:digital_clock/widget/flare_animation.dart';
import 'package:digital_clock/widget/time_widget.dart';
import 'package:digital_clock/widget/top_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

enum _Element {
  backgroundPrimary,
  backgroundSecondary,
  textPrimary,
  textSecondary,
  tickColor,
  tickColorHighlight
}
enum _day { morning, afternoon, evening, night }

final _darkTheme = {
  _Element.backgroundPrimary: Color(0xFF28313B),
  _Element.backgroundSecondary: Color(0xFF485461),
  _Element.textPrimary: Color(0xFF00bfa5),
  _Element.textSecondary: Color(0xFF00bfa5),
  _Element.tickColor: Color(0xFF00bfa5),
  _Element.tickColorHighlight: Color(0xFF1de9b6),
};

final _sunriseTheme = {
  _Element.backgroundPrimary: Color(0xFF7C98B3),
  _Element.backgroundSecondary: Color(0xFF637081),
  _Element.textPrimary: Color(0xFF00bfa5),
  _Element.textSecondary: Color(0xFFFBFBFB),
  _Element.tickColor: Color(0xFF00bfa5),
  _Element.tickColorHighlight: Color(0xFFFBFBFB),
};
final _cloudyTheme = {
  _Element.backgroundPrimary: Color(0xFF1E3B70),
  _Element.backgroundSecondary: Color(0xFF29539B),
  _Element.textPrimary: Color(0xFF00bfa5),
  _Element.textSecondary: Color(0xFF00bfa5),
  _Element.tickColor: Color(0xFF00bfa5),
  _Element.tickColorHighlight: Color(0xFFa7ffeb),
};
final _sunsetTheme = {
  _Element.backgroundPrimary: Color(0xFFA40606),
  _Element.backgroundSecondary: Color(0xFFD98324),
  _Element.textPrimary: Color(0xFF00bfa5),
  _Element.textSecondary: Color(0xFFFBFBFB),
  _Element.tickColor: Color(0xFF00bfa5),
  _Element.tickColorHighlight: Color(0xFF1de9b6),
};
final _nightTheme = {
  _Element.backgroundPrimary: Color(0xFF2A5470),
  _Element.backgroundSecondary: Color(0xFF4C4177),
  _Element.textPrimary: Color(0xFF00bfa5),
  _Element.textSecondary: Color(0xFFa7ffeb),
  _Element.tickColor: Color(0xFF00bfa5),
  _Element.tickColorHighlight: Color(0xFFa7ffeb),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String _location;
  String _temperature;
  WeatherCondition _weatherCondition;
  _day _today = _day.morning;
  String _flare;
  String _background = "third_party/img/sunrise.jpg";

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _location = widget.model.location;
      _temperature = widget.model.temperatureString;
      _weatherCondition = widget.model.weatherCondition;
    });
    _getFlarePath();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
    final hour = int.parse(DateFormat('s').format(_dateTime));

    String background = "third_party/img/night.jpg";
    _day now = _day.night;
    if (hour <= 15) {
      now = _day.morning;
      background = "third_party/img/sunrise.jpg";
    } else if (hour <= 30) {
      now = _day.afternoon;
      background = "third_party/img/cloudy.jpg";
    } else if (hour <= 45) {
      now = _day.evening;
      background = "third_party/img/sunset.jpg";
    }
    setState(() {
      _today = now;
      _background = background;
    });
    _getFlarePath();
  }

  void _getFlarePath() {
    String path = "third_party/flare/sunny_day.flr";
    bool day = _today != _day.night;
    switch (_weatherCondition) {
      case WeatherCondition.cloudy:
        path = day
            ? "third_party/flare/cloudy_day.flr"
            : "third_party/flare/cloudy_night.flr";
        break;
      case WeatherCondition.foggy:
        path = "third_party/flare/foggy.flr";
        break;
      case WeatherCondition.rainy:
        path = day
            ? "third_party/flare/heavy_rainy_day.flr"
            : "third_party/flare/heavy_rainy_night.flr";
        break;
      case WeatherCondition.snowy:
        path = "third_party/flare/snowy.flr";
        break;
      case WeatherCondition.sunny:
        path = day
            ? "third_party/flare/sunny_day.flr"
            : "third_party/flare/moon.flr";
        break;
      case WeatherCondition.thunderstorm:
        path = "third_party/flare/thunder_rainy.flr";
        break;
      case WeatherCondition.windy:
        path = "third_party/flare/windy.flr";
        break;
    }
    setState(() {
      _flare = path;
    });
  }

  getLightThemeColors() {
    var colors;
    switch (_today) {
      case _day.morning:
        colors = _sunriseTheme;
        break;
      case _day.afternoon:
        colors = _cloudyTheme;
        break;
      case _day.evening:
        colors = _sunsetTheme;
        break;
      case _day.night:
        colors = _nightTheme;
        break;
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('s').format(_dateTime);
    final format = DateFormat('a').format(_dateTime);
    final date = DateFormat('d MMM y, E').format(_dateTime).toUpperCase();
    final fontSize = size.width * 0.15;
    final fontSize2 = size.width * 0.03;

    final colors = Theme.of(context).brightness == Brightness.light
        ? getLightThemeColors()
        : _darkTheme;

    final defaultStyle = TextStyle(
      color: colors[_Element.textPrimary],
      fontFamily: 'Bitter',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    );
    final defaultStyle2 = defaultStyle.copyWith(
        fontFamily: 'Economica',
        fontSize: fontSize2,
        color: colors[_Element.textSecondary]);
    double flareSize = fontSize - 1.4 * fontSize2;
    double flarePadding = 0;

    if (_weatherCondition == WeatherCondition.windy) {
      flareSize = flareSize / 1.3;
      flarePadding = flareSize * 0.25;
    }
    if (_weatherCondition == WeatherCondition.thunderstorm) {
      flareSize = flareSize * 1.4;
      flarePadding = flareSize * 0.1;
    }

    if (_weatherCondition == WeatherCondition.rainy ||
        _weatherCondition == WeatherCondition.cloudy) {
      flareSize = flareSize / 1.2;
      flarePadding = flareSize * 0.2;
    }
    final margin = size.width * 0.02;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Background(
          path: _background,
          lightMode: Theme.of(context).brightness == Brightness.light,
          colorPrimary: colors[_Element.backgroundPrimary],
          colorSecondary: colors[_Element.backgroundSecondary],
          child: Stack(
            children: <Widget>[
              //painter
              CustomPaint(
                size: size,
                painter: ClockThick(
                    second: int.parse(second),
                    tickColor: colors[_Element.tickColor],
                    tickColorHighlight: colors[_Element.tickColorHighlight]),
              ),
              //flare
              FlareAnimation(
                  margin: margin,
                  size: size,
                  padding: flarePadding,
                  flareSize: flareSize,
                  flare: _flare),
              //Temperature and Location
              TopPanel(
                  margin: margin,
                  temperature: _temperature,
                  defaultStyle2: defaultStyle2,
                  location: _location),
              // Time
              TimeWidget(
                  hour: hour, defaultStyle: defaultStyle, minute: minute),
              // Date
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: margin * 10),
                  child: Text(date, style: defaultStyle2)),
              //Time format
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: margin * 13),
                  child: AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: widget.model.is24HourFormat ? 0 : 1,
                      child: Text(format, style: defaultStyle2))),
            ],
          ),
        ));
  }
}
