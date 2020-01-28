import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonButton extends StatefulWidget {
  final double height;
  final int buttonMaxLines;
  final double iconSize;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final bool loadingAnimation;
  final Border border;
  final BorderRadius borderRadius;
  final Icon buttonIcon;
  final AssetImage buttonImageAsset;
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
  final ButtonState buttonState;
  final bool showOnlyCircleProgressBarOnClick;
  final bool keepPressed;

  CommonButton({
    @required this.onTap,
    @required this.buttonText,
    @required this.buttonColor,
    this.buttonTextStyle,
    this.height = 50,
    this.iconSize = 24,
    this.loadingAnimation = false,
    this.pressedButtonColor,
    this.borderRadius,
    this.border,
    this.animationDuration = const Duration(seconds: 1),
    this.buttonIcon,
    this.buttonImageAsset,
    this.iconColor,
    this.textColor,
    this.pressedIconColor,
    this.pressedTextColor,
    this.buttonTextFontSize,
    this.buttonTextFontStyle,
    this.buttonTextFontWeight,
    this.buttonPadding,
    this.buttonMaxLines = 1,
    this.loadingColor,
    this.keepPressed = false,
    this.showOnlyCircleProgressBarOnClick = false,
    this.buttonState = ButtonState.INITIAL_STATE,
  });

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

enum ButtonState {
  INITIAL_STATE,
  START_LOADING_STATE,
  END_LOADING_STATE,
}

class _CommonButtonState extends State<CommonButton>
    with TickerProviderStateMixin {
  BorderRadius get _borderRadius => widget.borderRadius;

  bool get _loadingAnimation => widget.loadingAnimation;

  bool get _keepPressed => widget.keepPressed;

  bool get _showOnlyCircleProgressBarOnClick =>
      widget.showOnlyCircleProgressBarOnClick;

  Border get _border => widget.border;

  Function get _onTap => widget.onTap;

  double get _height => widget.height;

  Icon get _buttonIcon => widget.buttonIcon;

  AssetImage get _buttonImageAsset => widget.buttonImageAsset;

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

  double get _iconSize => widget.iconSize;

  ButtonState get _buttonState => widget.buttonState;

  AnimationController _animationController;
  BorderRadius _borderRadiusForLoading;
  double _progressWidth;
  Color _actualButtonColor;
  Color _actualIconColor;
  Color _actualTextColor;
  bool _alreadyPressed;
  bool _changeColorOnTap;

  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _handleAnimations();
    _actualButtonColor = _buttonColor;
    _actualIconColor = _iconColor != null ? _iconColor : Colors.black;
    _actualTextColor = _textColor != null ? _textColor : Colors.black;
    _alreadyPressed = false;
    _changeColorOnTap = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _handleAnimations();
    return GestureDetector(
        key: _globalKey,
        onTap: () {
          setState(() {
            _onTap();
            if (_keepPressed == true) {
              _changeColorOnTap = !_changeColorOnTap;
              _updateColors(_changeColorOnTap);
            }
            if (_loadingAnimation == true &&
                _buttonState == ButtonState.INITIAL_STATE &&
                _showOnlyCircleProgressBarOnClick == false)
              _animationController.forward();
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
          decoration: (_buttonState == ButtonState.START_LOADING_STATE)
              ? _setBoxDecorationForLoadingView()
              : _setBoxDecoration(),
          height: _height,
          width: (_showOnlyCircleProgressBarOnClick == false)
              ? _progressWidth
              : double.infinity,
          child: (_buttonState == ButtonState.INITIAL_STATE ||
                  _buttonState == ButtonState.END_LOADING_STATE)
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
            (_buttonIcon != null || _buttonImageAsset != null)
                ? _getButtonIcon()
                : Container(),
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
            (_buttonIcon != null)
                ? Icon(
                    _buttonIcon.icon,
                    color: _actualIconColor,
                    size: _iconSize,
                  )
                : ImageIcon(
                    _buttonImageAsset,
                    color: _actualIconColor,
                    size: _iconSize,
                  )
          ],
        ),
      );

  _getButtonText() => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: 16, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                (_buttonIcon != null || _buttonImageAsset != null)
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
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

  void _handleAnimations() {
    if (!_showOnlyCircleProgressBarOnClick) {
      if (_buttonState == ButtonState.INITIAL_STATE &&
          _alreadyPressed == false) {
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
              _alreadyPressed = true;
              print('Initial: $_buttonState');
            });
          }
        });
      } else if (_buttonState == ButtonState.START_LOADING_STATE &&
          _alreadyPressed == true) {
        _animationController =
            AnimationController(vsync: this, duration: _animationDuration);
        _animationController.addListener(() {
          double controllerValue = _animationController.value;
          double _animHeight = _height - (40 * controllerValue);
          double _auxWidth =
              MediaQuery.of(context).size.width * controllerValue;
          if (controllerValue < 0.9) {
            setState(() {
              _borderRadiusForLoading = BorderRadius.circular(_animHeight);
              _progressWidth = _auxWidth <= _height ? _height : _auxWidth;
            });
          } else if (controllerValue == 1.0) {
            setState(() {
              _borderRadiusForLoading = BorderRadius.circular(10);
              _alreadyPressed = false;
              print('StartLoading $_buttonState');
            });
          }
        });
        if (_showOnlyCircleProgressBarOnClick == false)
          _animationController.forward();
      } else if (_buttonState == ButtonState.END_LOADING_STATE &&
          _alreadyPressed == false) {
        _animationController.forward();
      }
    } else {
      _borderRadiusForLoading = _borderRadius;
    }
  }
}
