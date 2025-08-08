// lib/models/credit_transaction.dart
import 'package:flutter/material.dart';

class CreditTransaction {
  final int id;
  final int uyeid; // 'uyeid'
  final String tutar; // 'tutar'
  final int paytronay; // 'paytronay'
  final String spno; // 'spno'
  final int bonus; // 'bonus'
  final String ip; // 'ip'
  final DateTime tarih; // 'tarih' - string'den parse edilecek

  CreditTransaction({
    required this.id,
    required this.uyeid,
    required this.tutar,
    required this.paytronay,
    required this.spno,
    required this.bonus,
    required this.ip,
    required this.tarih,
  });

  factory CreditTransaction.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateString(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        debugPrint('Kredi İşlemi Tarih ayrıştırma hatası: $e - $dateStr');
        return null;
      }
    }

    return CreditTransaction(
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
