import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonButton extends StatefulWidget {
  final double height;
  final int buttonMaxLines;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final bool loadingAnimation;
  final Border border;
  final BorderRadius borderRadius;
  final Icon buttonIcon;
  final Function onTap;
  final Duration animationDuration;
  final Color buttonColor;
  final Color pressedButtonColor;
  final Color pressedIconColor;
  final Color pressedTextColor;
  final Color textColor;
  final Color iconColor;
  final Color loadingColor;
  final double buttonTextFontSize;
  final FontStyle buttonTextFontStyle;
  final FontWeight buttonTextFontWeight;
  final EdgeInsets buttonPadding;

  CommonButton(
      {@required this.onTap,
        @required this.buttonText,
        @required this.buttonColor,
        this.buttonTextStyle,
        this.height = 50,
        this.loadingAnimation = false,
        this.pressedButtonColor,
        this.borderRadius,
        this.border,
        this.animationDuration,
        this.buttonIcon,
        this.iconColor,
        this.textColor,
        this.pressedIconColor,
        this.pressedTextColor,
        this.buttonTextFontSize,
        this.buttonTextFontStyle,
        this.buttonTextFontWeight,
        this.buttonPadding,
        this.buttonMaxLines = 1,
        this.loadingColor});

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

enum ButtonState { INITIAL_STATE, START_LOADING_STATE, END_LOADING_STATE }

class _CommonButtonState extends State<CommonButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  BorderRadius get _borderRadius => widget.borderRadius;
  BorderRadius _borderRadiusForLoading;

  bool get _loadingAnimation => widget.loadingAnimation;

  Border get _border => widget.border;

  Function get _onTap => widget.onTap;

  double get _height => widget.height;
  double _progressWidth;

  Icon get _buttonIcon => widget.buttonIcon;

  String get _buttonText => widget.buttonText;

  double get _buttonTextFontSize => widget.buttonTextFontSize;

  FontStyle get _buttonTextFontStyle => widget.buttonTextFontStyle;

  FontWeight get _buttonTextFontWeight => widget.buttonTextFontWeight;

  Color get _buttonColor => widget.buttonColor;

  Color get _pressedButtonColor => widget.pressedButtonColor;

  Color get _pressedIconColor => widget.pressedIconColor;

  Color get _pressedTextColor => widget.pressedTextColor;

  Color get _iconColor => widget.iconColor;

  Color get _textColor => widget.textColor;

  Color get _loadingColor => widget.loadingColor;

  Duration get _animationDuration => widget.animationDuration;

  EdgeInsets get _buttonPadding => widget.buttonPadding;

  int get _buttonMaxLines => widget.buttonMaxLines;

  ButtonState _buttonState;
  Color _actualButtonColor;
  Color _actualIconColor;
  Color _actualTextColor;

  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _buttonState = ButtonState.INITIAL_STATE;
    _actualButtonColor = _buttonColor;
    _actualIconColor = _iconColor != null ? _iconColor : Colors.black;
    _actualTextColor = _textColor != null ? _textColor : Colors.black;
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    _animationController.addListener(() {
      double controllerValue = _animationController.value;
      double _animHeight = _height * controllerValue;
      double _auxWidth = MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width * controllerValue);
      if (controllerValue < 0.9) {
        setState(() {
          _borderRadiusForLoading = BorderRadius.circular(_animHeight);
          _progressWidth = _auxWidth <= _height ? _height : _auxWidth;
        });
      } else if (controllerValue == 1.0) {
        setState(() {
          _borderRadiusForLoading = BorderRadius.circular(_height);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: _globalKey,
        onTap: () {
          setState(() {
            _onTap();
            if (_loadingAnimation) {
              _buttonState = ButtonState.START_LOADING_STATE;
              _animationController.forward();
            }
          });
        },
        onTapDown: (details) {
          if (_pressedButtonColor != null)
            setState(() {
              _updateColors(true);
            });
        },
        onTapUp: (details) {
          _onTap;
          if (_pressedButtonColor != null)
            setState(() {
              _updateColors(false);
            });
        },
        onVerticalDragStart: (DragStartDetails details) {
          if (_pressedButtonColor != null)
            setState(() {
              _updateColors(true);
            });
        },
        onHorizontalDragStart: (DragStartDetails details) {
          if (_pressedButtonColor != null)
            setState(() {
              _updateColors(true);
            });
        },
        onVerticalDragEnd: (DragEndDetails details) {
          if (_pressedButtonColor != null)
            setState(() {
              _updateColors(false);
            });
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (_pressedButtonColor != null)
            setState(() {
              _updateColors(false);
            });
        },
        child: Container(
          padding: (_buttonPadding != null) ? _buttonPadding : null,
          decoration: (_buttonState != ButtonState.START_LOADING_STATE)
              ? _setBoxDecoration()
              : _setBoxDecorationForLoadingView(),
          height: _height,
          width: (_buttonState == ButtonState.INITIAL_STATE)
              ? MediaQuery.of(context).size.width
              : _progressWidth,
          child: (_buttonState == ButtonState.INITIAL_STATE)
              ? _setButtonContent()
              : _loadingView(),
        ));
  }

  _updateColors(bool pressed) {
    if (!pressed) {
      _actualButtonColor = _buttonColor;
      _actualTextColor = _textColor;
      _actualIconColor = _iconColor;
    } else {
      _actualButtonColor = _pressedButtonColor;
      _actualTextColor = _pressedTextColor;
      _actualIconColor = _pressedIconColor;
    }
  }

  _setBoxDecoration() => BoxDecoration(
      borderRadius: _borderRadius != null ? _borderRadius : BorderRadius.zero,
      border: _border == null ? null : _border,
      shape: BoxShape.rectangle,
      color: _actualButtonColor);

  _setButtonContent() => AnimatedContainer(
    duration: _animationDuration,
    width: MediaQuery.of(context).size.width,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        (_buttonIcon != null) ? _getButtonIcon() : Container(),
        _getButtonText()
      ],
    ),
  );

  _loadingView() => Container(
    padding: EdgeInsets.all(8),
    height: _height,
    width: _height,
    child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              (_loadingColor != null) ? _loadingColor : Colors.blue),
        )),
  );

  _setBoxDecorationForLoadingView() => BoxDecoration(
      border: _border,
      color: _buttonColor,
      shape: BoxShape.rectangle,
      borderRadius: _borderRadiusForLoading);

  _getButtonIcon() => Container(
    margin: EdgeInsets.only(left: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          _buttonIcon.icon,
          color: _actualIconColor,
        ),
      ],
    ),
  );

  _getButtonText() => Expanded(
    child: Container(
      margin: EdgeInsets.only(right: 16, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_buttonText,
              maxLines: _buttonMaxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: _actualTextColor,
                  fontWeight: (_buttonTextFontWeight != null)
                      ? _buttonTextFontWeight
                      : null,
                  fontStyle: (_buttonTextFontStyle != null)
                      ? _buttonTextFontStyle
                      : null,
                  fontSize: (_buttonTextFontSize != null)
                      ? _buttonTextFontSize
                      : null))
        ],
      ),
    ),
  );
}
