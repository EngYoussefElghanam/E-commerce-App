import 'package:flutter/material.dart';

extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 6;
  }

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get toTitleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}

extension DoubleExtensions on double {
  String get toCurrencyString {
    return '\$${toStringAsFixed(2)}';
  }

  String get toCompactCurrency {
    if (this >= 1000000) {
      return '\$${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '\$${(this / 1000).toStringAsFixed(1)}K';
    }
    return toCurrencyString;
  }
}

extension DateTimeExtensions on DateTime {
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

extension WidgetExtensions on Widget {
  Widget withPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  Widget withCenter() {
    return Center(child: this);
  }

  Widget withExpanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  Widget withFlexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }
}

extension ListExtensions<T> on List<T> {
  List<T> get unique {
    return toSet().toList();
  }

  bool get isNullOrEmpty => isEmpty;

  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;
}

extension MapExtensions<K, V> on Map<K, V> {
  bool get isNullOrEmpty => isEmpty;

  V? getValue(K key) => containsKey(key) ? this[key] : null;
}
