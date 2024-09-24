// To parse this JSON data, do
//
//     final getDefaultCurrency = getDefaultCurrencyFromJson(jsonString);

import 'dart:convert';

class GetDefaultCurrency {
  GetDefaultCurrency({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  DefaultCurrency? result;
  String? typename;

  factory GetDefaultCurrency.fromRawJson(String str) =>
      GetDefaultCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDefaultCurrency.fromJson(Map<String, dynamic> json) =>
      GetDefaultCurrency(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage:
            json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null
            ? null
            : DefaultCurrency.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result?.toJson(),
        "__typename": typename == null ? null : typename,
      };
}

class DefaultCurrency {
  DefaultCurrency({
    this.fiatDefaultCurrency,
    this.cryptoDefaultCurrency,
    this.siteName,
    this.siteLogo,
    this.favicon,
    this.siteBanner,
    this.siteDescription,
    this.bannerTitle,
    this.cryptoCurrencyApiKey,
    this.joinUs,
    this.recaptcha,
    this.referralSettings,
    this.siteMaintenance,
    this.marginSettings,
    this.binanceStatus,
    this.okx_status,
    this.oneStepWithdrawal,
    this.siteMaintenanceSettings,
    this.defaultPairs,
    this.typename,
  });

  String? fiatDefaultCurrency;
  String? cryptoDefaultCurrency;
  String? siteName;
  String? siteLogo;
  String? favicon;
  String? siteBanner;
  String? siteDescription;
  String? bannerTitle;
  String? cryptoCurrencyApiKey;
  JoinUs? joinUs;
  Recaptcha? recaptcha;
  ReferralSettings? referralSettings;
  bool? siteMaintenance;
  MarginSettings? marginSettings;
  bool? binanceStatus;
  bool? okx_status;
  OneStepWithdrawalist? oneStepWithdrawal;
  SiteMaintenanceSettings? siteMaintenanceSettings;
  DefaultPairs? defaultPairs;
  String? typename;

  factory DefaultCurrency.fromRawJson(String str) =>
      DefaultCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DefaultCurrency.fromJson(Map<String, dynamic> json) =>
      DefaultCurrency(
        fiatDefaultCurrency: json["fiat_default_currency"] == null
            ? null
            : json["fiat_default_currency"],
        cryptoDefaultCurrency: json["crypto_default_currency"] == null
            ? null
            : json["crypto_default_currency"],
        siteName: json["site_name"] == null ? null : json["site_name"],
        siteLogo: json["site_logo"] == null ? null : json["site_logo"],
        favicon: json["favicon"] == null ? null : json["favicon"],
        siteBanner: json["site_banner"] == null ? null : json["site_banner"],
        siteDescription:
            json["site_description"] == null ? null : json["site_description"],
        bannerTitle: json["banner_title"] == null ? null : json["banner_title"],
        cryptoCurrencyApiKey: json["crypto_currency_api_key"] == null
            ? null
            : json["crypto_currency_api_key"],
        joinUs:
            json["join_us"] == null ? null : JoinUs.fromJson(json["join_us"]),
        recaptcha: json["recaptcha"] == null
            ? null
            : Recaptcha.fromJson(json["recaptcha"]),
        referralSettings: json["referral_settings"] == null
            ? null
            : ReferralSettings.fromJson(json["referral_settings"]),
        siteMaintenance:
            json["site_maintenance"] == null ? null : json["site_maintenance"],
        marginSettings: json["margin_settings"] == null
            ? null
            : MarginSettings.fromJson(json["margin_settings"]),
        binanceStatus:
            json["binance_status"] == null ? null : json["binance_status"],
        okx_status: json["okx_status"] == null ? null : json["okx_status"],
        oneStepWithdrawal: json["one_step_withdrawal"] == null
            ? null
            : OneStepWithdrawalist.fromJson(json["one_step_withdrawal"]),
        siteMaintenanceSettings: json["site_maintenance_settings"] == null
            ? null
            : SiteMaintenanceSettings.fromJson(
                json["site_maintenance_settings"]),
        defaultPairs: DefaultPairs.fromJson(json["default_pairs"]),
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "fiat_default_currency":
            fiatDefaultCurrency == null ? null : fiatDefaultCurrency,
        "crypto_default_currency":
            cryptoDefaultCurrency == null ? null : cryptoDefaultCurrency,
        "site_name": siteName == null ? null : siteName,
        "site_logo": siteLogo == null ? null : siteLogo,
        "favicon": favicon == null ? null : favicon,
        "site_banner": siteBanner == null ? null : siteBanner,
        "site_description": siteDescription == null ? null : siteDescription,
        "banner_title": bannerTitle == null ? null : bannerTitle,
        "crypto_currency_api_key":
            cryptoCurrencyApiKey == null ? null : cryptoCurrencyApiKey,
        "join_us": joinUs == null ? null : joinUs?.toJson(),
        "recaptcha": recaptcha == null ? null : recaptcha?.toJson(),
        "referral_settings":
            referralSettings == null ? null : referralSettings?.toJson(),
        "site_maintenance": siteMaintenance == null ? null : siteMaintenance,
        "margin_settings": marginSettings == null ? null : marginSettings,
        "binance_status": binanceStatus == null ? null : binanceStatus,
        "okx_status": okx_status == null ? null : okx_status,
        "one_step_withdrawal": oneStepWithdrawal?.toJson(),
        "site_maintenance": siteMaintenance,
        "default_pairs": defaultPairs?.toJson(),
        "__typename": typename == null ? null : typename,
      };
}

class DefaultPairs {
  String? spotDefaultPair;
  String? marginDefaultPair;
  String? futureUsdsDefaultPair;
  String? futureCoinDefaultPair;

  DefaultPairs({
    this.spotDefaultPair,
    this.marginDefaultPair,
    this.futureUsdsDefaultPair,
    this.futureCoinDefaultPair,
  });

  factory DefaultPairs.fromRawJson(String str) =>
      DefaultPairs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DefaultPairs.fromJson(Map<String, dynamic> json) => DefaultPairs(
        spotDefaultPair: json["spot_default_pair"],
        marginDefaultPair: json["margin_default_pair"],
        futureUsdsDefaultPair: json["future_USDS_default_pair"],
        futureCoinDefaultPair: json["future_COIN_default_pair"],
      );

  Map<String, dynamic> toJson() => {
        "spot_default_pair": spotDefaultPair,
        "margin_default_pair": marginDefaultPair,
        "future_USDS_default_pair": futureUsdsDefaultPair,
        "future_COIN_default_pair": futureCoinDefaultPair,
      };
}

class SiteMaintenanceSettings {
  bool? status;
  dynamic startDate;
  dynamic endDate;
  String? typename;

  SiteMaintenanceSettings({
    this.status,
    this.startDate,
    this.endDate,
    this.typename,
  });

  factory SiteMaintenanceSettings.fromRawJson(String str) =>
      SiteMaintenanceSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SiteMaintenanceSettings.fromJson(Map<String, dynamic> json) =>
      SiteMaintenanceSettings(
        status: json["status"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "start_date": startDate,
        "end_date": endDate,
        "__typename": typename,
      };
}

class OneStepWithdrawalist {
  List<double>? quotas;
  int? hr24Limit;
  String? supportedCurrency;
  List<String>? originWallet;
  List<String>? originExchange;
  String? typename;

  OneStepWithdrawalist({
    this.quotas,
    this.hr24Limit,
    this.supportedCurrency,
    this.originWallet,
    this.originExchange,
    this.typename,
  });

  factory OneStepWithdrawalist.fromRawJson(String str) =>
      OneStepWithdrawalist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OneStepWithdrawalist.fromJson(Map<String, dynamic> json) =>
      OneStepWithdrawalist(
        quotas: json["quotas"] == null
            ? []
            : List<double>.from(json["quotas"]!.map((x) => x?.toDouble())),
        hr24Limit: json["hr_24_limit"],
        supportedCurrency: json["supported_currency"],
        originWallet: json["origin_wallet"] == null
            ? []
            : List<String>.from(json["origin_wallet"]!.map((x) => x)),
        originExchange: json["origin_exchange"] == null
            ? []
            : List<String>.from(json["origin_exchange"]!.map((x) => x)),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "quotas":
            quotas == null ? [] : List<dynamic>.from(quotas!.map((x) => x)),
        "hr_24_limit": hr24Limit,
        "supported_currency": supportedCurrency,
        "origin_wallet": originWallet == null
            ? []
            : List<dynamic>.from(originWallet!.map((x) => x)),
        "origin_exchange": originExchange == null
            ? []
            : List<dynamic>.from(originExchange!.map((x) => x)),
        "__typename": typename,
      };
}

class JoinUs {
  JoinUs({
    this.facebook,
    this.twitter,
    this.linkedin,
    this.youtube,
    this.instagram,
    this.playStore,
    this.appStore,
    this.contactMail,
    this.supportMail,
    this.typename,
  });

  String? facebook;
  String? twitter;
  String? linkedin;
  String? youtube;
  String? instagram;
  String? playStore;
  String? appStore;
  String? contactMail;
  String? supportMail;
  String? typename;

  factory JoinUs.fromRawJson(String str) => JoinUs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JoinUs.fromJson(Map<String, dynamic> json) => JoinUs(
        facebook: json["Facebook"] == null ? null : json["Facebook"],
        twitter: json["Twitter"] == null ? null : json["Twitter"],
        linkedin: json["Linkedin"] == null ? null : json["Linkedin"],
        youtube: json["Youtube"] == null ? null : json["Youtube"],
        instagram: json["Instagram"] == null ? null : json["Instagram"],
        playStore: json["Play_store"] == null ? null : json["Play_store"],
        appStore: json["App_store"] == null ? null : json["App_store"],
        contactMail: json["contact_mail"] == null ? null : json["contact_mail"],
        supportMail: json["support_mail"] == null ? null : json["support_mail"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "Facebook": facebook == null ? null : facebook,
        "Twitter": twitter == null ? null : twitter,
        "Linkedin": linkedin == null ? null : linkedin,
        "Youtube": youtube == null ? null : youtube,
        "Instagram": instagram == null ? null : instagram,
        "Play_store": playStore == null ? null : playStore,
        "App_store": appStore == null ? null : appStore,
        "contact_mail": contactMail == null ? null : contactMail,
        "support_mail": supportMail == null ? null : supportMail,
        "__typename": typename == null ? null : typename,
      };
}

class Recaptcha {
  Recaptcha({
    this.recaptchaSitekey,
    this.recaptchaSecretkey,
    this.typename,
  });

  String? recaptchaSitekey;
  String? recaptchaSecretkey;
  String? typename;

  factory Recaptcha.fromRawJson(String str) =>
      Recaptcha.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Recaptcha.fromJson(Map<String, dynamic> json) => Recaptcha(
        recaptchaSitekey: json["recaptcha_sitekey"] == null
            ? null
            : json["recaptcha_sitekey"],
        recaptchaSecretkey: json["recaptcha_secretkey"] == null
            ? null
            : json["recaptcha_secretkey"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "recaptcha_sitekey": recaptchaSitekey == null ? null : recaptchaSitekey,
        "recaptcha_secretkey":
            recaptchaSecretkey == null ? null : recaptchaSecretkey,
        "__typename": typename == null ? null : typename,
      };
}

class ReferralSettings {
  ReferralSettings({
    this.earningLimit,
    this.commissionPercentage,
    this.referralLinkLimit,
    this.referralDefaultCurrency,
    this.typename,
  });

  double? earningLimit;
  int? commissionPercentage;
  int? referralLinkLimit;
  String? referralDefaultCurrency;
  String? typename;

  factory ReferralSettings.fromRawJson(String str) =>
      ReferralSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralSettings.fromJson(Map<String, dynamic> json) =>
      ReferralSettings(
        earningLimit: json["earning_limit"] == null
            ? null
            : json["earning_limit"].toDouble(),
        commissionPercentage: json["commission_percentage"] == null
            ? null
            : json["commission_percentage"],
        referralLinkLimit: json["referral_link_limit"] == null
            ? null
            : json["referral_link_limit"],
        referralDefaultCurrency: json["referral_default_currency"] == null
            ? null
            : json["referral_default_currency"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "earning_limit": earningLimit == null ? null : earningLimit,
        "commission_percentage":
            commissionPercentage == null ? null : commissionPercentage,
        "referral_link_limit":
            referralLinkLimit == null ? null : referralLinkLimit,
        "referral_default_currency":
            referralDefaultCurrency == null ? null : referralDefaultCurrency,
        "__typename": typename == null ? null : typename,
      };
}

class MarginSettings {
  int? crossLeverage;
  num? initialRiskRatioCross;
  num? mcrCross;
  num? liquidationRatioCross;
  Isolated? mcrIsolated;
  Isolated? initialRiskRatioIsolated;
  Isolated? liquidationRatioIsolated;
  String? typename;

  MarginSettings({
    this.crossLeverage,
    this.initialRiskRatioCross,
    this.mcrCross,
    this.liquidationRatioCross,
    this.mcrIsolated,
    this.initialRiskRatioIsolated,
    this.liquidationRatioIsolated,
    this.typename,
  });

  factory MarginSettings.fromRawJson(String str) =>
      MarginSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarginSettings.fromJson(Map<String, dynamic> json) => MarginSettings(
        crossLeverage: json["cross_leverage"],
        initialRiskRatioCross: json["initial_risk_ratio_cross"]?.toDouble(),
        mcrCross: json["mcr_cross"]?.toDouble(),
        liquidationRatioCross: json["liquidation_ratio_cross"]?.toDouble(),
        mcrIsolated: json["mcr_isolated"] == null
            ? null
            : Isolated.fromJson(json["mcr_isolated"]),
        initialRiskRatioIsolated: json["initial_risk_ratio_isolated"] == null
            ? null
            : Isolated.fromJson(json["initial_risk_ratio_isolated"]),
        liquidationRatioIsolated: json["liquidation_ratio_isolated"] == null
            ? null
            : Isolated.fromJson(json["liquidation_ratio_isolated"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "cross_leverage": crossLeverage,
        "initial_risk_ratio_cross": initialRiskRatioCross,
        "mcr_cross": mcrCross,
        "liquidation_ratio_cross": liquidationRatioCross,
        "mcr_isolated": mcrIsolated?.toJson(),
        "initial_risk_ratio_isolated": initialRiskRatioIsolated?.toJson(),
        "liquidation_ratio_isolated": liquidationRatioIsolated?.toJson(),
        "__typename": typename,
      };
}

class Isolated {
  num? x3;
  num? x5;
  num? x10;
  String? typename;

  Isolated({
    this.x3,
    this.x5,
    this.x10,
    this.typename,
  });

  factory Isolated.fromRawJson(String str) =>
      Isolated.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Isolated.fromJson(Map<String, dynamic> json) => Isolated(
        x3: json["x3"]?.toDouble(),
        x5: json["x5"]?.toDouble(),
        x10: json["x10"]?.toDouble(),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "x3": x3,
        "x5": x5,
        "x10": x10,
        "__typename": typename,
      };
}
