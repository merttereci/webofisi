// ignore_for_file: non_constant_identifier_names
class DestekCevaplar {
  final int id;
  final int yetkili;
  final int destek_id;
  final String mesaj;
  final String? cevapyazan;
  final String tarih;
  final String ip;

  DestekCevaplar(
      {required this.id,
      required this.yetkili,
      required this.destek_id,
      required this.mesaj,
      this.cevapyazan,
      required this.tarih,
      required this.ip});

  factory DestekCevaplar.fromJson(Map<String, dynamic> json) {
    return DestekCevaplar(
      id: json['id'] as int,
      yetkili: json['yetkili'] as int,
      destek_id: json['destek_id'] as int,
      mesaj: json['mesaj'] as String,
      cevapyazan: json['cevap_yazan'] as String?,
      tarih: json['tarih'] as String,
      ip: json['ip'] as String,
    );
  }
}
