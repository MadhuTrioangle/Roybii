// To parse this JSON data, do
//
//     final searchResultModel = searchResultModelFromJson(jsonString);

import 'dart:convert';

class SearchResultModel {
  SearchResultModel({
    required this.countries,
  });

  List<Country>? countries;

  factory SearchResultModel.fromRawJson(String str) => SearchResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
    countries: json["Countries"] == null ? null : List<Country>.from(json["Countries"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Countries": countries == null ? null : List<dynamic>.from(countries!.map((x) => x.toJson())),
  };
}

class Country {
  Country({
    required this.states,
    required this.countryName,
  });

  List<State>? states;
  String countryName;

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    states: json["States"] == null ? null : List<State>.from(json["States"].map((x) => State.fromJson(x))),
    countryName: json["CountryName"] == null ? null : json["CountryName"],
  );

  Map<String, dynamic> toJson() => {
    "States": states == null ? null : List<dynamic>.from(states!.map((x) => x.toJson())),
    "CountryName": countryName == null ? null : countryName,
  };
}

class State {
  State({
    required this.cities,
    required this.stateName,
  });

  List<String>? cities;
  String stateName;

  factory State.fromRawJson(String str) => State.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory State.fromJson(Map<String, dynamic> json) => State(
    cities: json["Cities"] == null ? null : List<String>.from(json["Cities"].map((x) => x)),
    stateName: json["StateName"] == null ? null : json["StateName"],
  );

  Map<String, dynamic> toJson() => {
    "Cities": cities == null ? null : List<dynamic>.from(cities!.map((x) => x)),
    "StateName": stateName == null ? null : stateName,
  };
}
