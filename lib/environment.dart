import 'package:flutter/foundation.dart';

const String local = 'local';
const String development = 'development';
const String production = 'production';
const String custom = 'custom';

final Map<String, String> flavors = {
  production: 'https://mailman.imakethings.ch',
  development: 'http://192.168.86.35:1337',//'https://mailman.imakethings.ch', // 'http://172.20.10.5:8000',
  custom: '',
};

class Environment {
  static const String singletonName = 'environment';
  Map<String, String> flavors;
  String flavor;

  String get apiUrl => flavors[flavor]!;

  void update({String? flavor, Map<String, String>? flavors}) {
    this.flavor = flavor ?? this.flavor;
    this.flavors = Map.from(flavors ?? this.flavors);
  }

  factory Environment.create({
    String flavor = development,
    required Map<String, String> flavors,
  }) {
    return Environment._internal(
      flavor: flavor,
      flavors: flavors,
    );
  }

  factory Environment.fromMap(Map<String, dynamic> map) {
    return Environment._internal(
      flavor: map['flavor'],
      flavors: (map['flavors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry<String, String>(key, value.toString()),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'flavor': flavor,
      'flavors': flavors,
    };
  }

  Environment._internal({required this.flavor, required this.flavors});

  bool isProd() {
    return flavor == production && kReleaseMode;
  }
}
