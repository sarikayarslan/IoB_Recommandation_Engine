import 'dart:convert';

Ads adsFromJson(String str) => Ads.fromJson(json.decode(str));

String adsToJson(Ads data) => json.encode(data.toJson());

class Ads {
  String segment;
  List<String> ansequents;
  List<String> consequents;

  Ads({
    required this.segment,
    required this.ansequents,
    required this.consequents,
  });

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
        segment: json["segment"],
        ansequents: List<String>.from(json["ansequents"].map((x) => x)),
        consequents: List<String>.from(json["consequents"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "segment": segment,
        "ansequents": List<dynamic>.from(ansequents.map((x) => x)),
        "consequents": List<dynamic>.from(consequents.map((x) => x)),
      };
}
