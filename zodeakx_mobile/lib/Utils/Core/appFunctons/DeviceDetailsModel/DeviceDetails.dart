// To parse this JSON data, do
//
//     final deviceDetails = deviceDetailsFromJson(jsonString);

import 'dart:convert';

class DeviceDetails {
    DeviceDetails({
        this.source,
        this.device,
        this.browser,
        this.os,
        this.platform,
    });

    String? source;
    String? device;
    String? browser;
    String? os;
    String? platform;

    factory DeviceDetails.fromRawJson(String str) => DeviceDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeviceDetails.fromJson(Map<String, dynamic> json) => DeviceDetails(
        source: json["source"] == null ? null : json["source"],
        device: json["device"] == null ? null : json["device"],
        browser: json["browser"] == null ? null : json["browser"],
        os: json["os"] == null ? null : json["os"],
        platform: json["platform"] == null ? null : json["platform"],
    );

    Map<String, dynamic> toJson() => {
        "source": source == null ? null : source,
        "device": device == null ? null : device,
        "browser": browser == null ? null : browser,
        "os": os == null ? null : os,
        "platform": platform == null ? null : platform,
    };
}
