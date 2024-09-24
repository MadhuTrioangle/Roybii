import 'dart:convert';

class GetMaintenanceRoomModelClass {
  bool? siteMaintenance;
  SiteMaintenanceSettings? siteMaintenanceSettings;

  GetMaintenanceRoomModelClass({
    this.siteMaintenance,
    this.siteMaintenanceSettings,
  });

  factory GetMaintenanceRoomModelClass.fromRawJson(String str) =>
      GetMaintenanceRoomModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMaintenanceRoomModelClass.fromJson(Map<String, dynamic> json) =>
      GetMaintenanceRoomModelClass(
        siteMaintenance: json["site_maintenance"],
        siteMaintenanceSettings: json["site_maintenance_settings"] == null
            ? null
            : SiteMaintenanceSettings.fromJson(
                json["site_maintenance_settings"]),
      );

  Map<String, dynamic> toJson() => {
        "site_maintenance": siteMaintenance,
        "site_maintenance_settings": siteMaintenanceSettings?.toJson(),
      };
}

class SiteMaintenanceSettings {
  bool? status;
  String? id;
  dynamic startDate;
  dynamic endDate;

  SiteMaintenanceSettings({
    this.status,
    this.id,
    this.startDate,
    this.endDate,
  });

  factory SiteMaintenanceSettings.fromRawJson(String str) =>
      SiteMaintenanceSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SiteMaintenanceSettings.fromJson(Map<String, dynamic> json) =>
      SiteMaintenanceSettings(
        status: json["status"],
        id: json["_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "start_date": startDate,
        "end_date": endDate,
      };
}
