import 'package:flutter/material.dart';

class Krediler {
  final int id;
  final int uyeid;
  final String tutar;
  final int paytronay;
  final String spno;
  final int bonus;
  final String ip;
  final DateTime tarih;

  Krediler({
    required this.id,
    required this.uyeid,
    required this.tutar,
    required this.paytronay,
    required this.spno,
    required this.bonus,
    required this.ip,
    required this.tarih,
  });

  factory Krediler.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateString(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        debugPrint('Kredi İşlemi Tarih ayrıştırma hatası: $e - $dateStr');
        return null;
      }
    }

    return Krediler(
      id: json['id'] as int,
      uyeid: json['uyeid'] as int,
      tutar: json['tutar'] as String,
      paytronay: json['paytronay'] as int,
      spno: json['spno'] as String,
      bonus: json['bonus'] as int,
      ip: json['ip'] as String,
      tarih: parseDateString(json['tarih'] as String?)!,
    );
  }
}
