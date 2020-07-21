import 'package:flutter/material.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:lightning_chat/screens/login_screen.dart';
import 'package:lightning_chat/screens/registration_screen.dart';
import 'package:lightning_chat/screens/welcome_screen.dart';

class Routage {
  final WidgetBuilder widgetBuilder;
  Routage({
    this.widgetBuilder,
  }) : assert(widgetBuilder != null);
}

final Map<String, Routage> routageTable = {
  WelcomeScreen.sName: Routage(
    widgetBuilder: (context) => WelcomeScreen(),
  ),
  ChatScreen.sName: Routage(
    widgetBuilder: (context) => ChatScreen(),
  ),
  LoginScreen.sName: Routage(
    widgetBuilder: (context) => LoginScreen(),
  ),
  RegistrationScreen.sName: Routage(
    widgetBuilder: (context) => RegistrationScreen(),
  ),
};

enum NavigationStyle {
  rightToLeft,
  bottomToTop,
}

enum NavigationType {
  normal,
  replace,
}

class RouterState {
  final List<String> stack = [];
  String currentRoutage;
  RouterState(this.currentRoutage);

  bool isCurrent(String routage) {
    return routage == currentRoutage;
  }

  bool isContain(String routage) {
    return stack.contains(routage);
  }

  void push(String routage) {
    stack.add(currentRoutage);
    currentRoutage = routage;
  }

  void replace(String routage) {
    stack.removeRange(0, stack.length);
    currentRoutage = routage;
  }

  void pop() {
    currentRoutage = stack.last;
    stack.removeLast();
  }
}

class Router {
  final Map<String, Routage> _routageTable = routageTable;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;
  RouterState _routerState = RouterState(null);

  PageRoute _pageRouteFrom(
      WidgetBuilder widgetBuilder, NavigationStyle navigationStyle) {
    if (navigationStyle == NavigationStyle.rightToLeft) {
      return MaterialPageRoute(builder: widgetBuilder, fullscreenDialog: true);
    } else if (navigationStyle == NavigationStyle.bottomToTop) {
      return MaterialPageRoute(builder: widgetBuilder);
    }
    return null;
  }

  Future<void> navigate<T>(
    String path, {
    NavigationStyle navigationStyle = NavigationStyle.rightToLeft,
    NavigationType navigationType = NavigationType.normal,
  }) async {
    assert(navigationStyle != null);
    assert(navigationType != null);
    if (_routerState.isCurrent(path)) {
      return;
    }
    if (_routerState.isContain(path)) {
      while (_routerState.isContain(path)) {
        _routerState.pop();
        _navigator.pop();
      }
      return;
    }
    final routage = _routageTable[path];
    final pageRoute = _pageRouteFrom(routage.widgetBuilder, navigationStyle);
    if (navigationType == NavigationType.normal) {
      _routerState.push(path);
      await _navigator.push(pageRoute);
    } else if (navigationType == NavigationType.replace) {
      _routerState.replace(path);
      await _navigator.pushAndRemoveUntil(pageRoute, (value) => value == null);
    }
  }
}
