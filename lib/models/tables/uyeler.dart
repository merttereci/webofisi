// ignore_for_file: non_constant_identifier_names
class TabloUyeler {
  final int id;
  final int? fbid;
  final int? hesap;
  final int? vergi;
  final String? ad;
  final String? soyad;
  final String? email;
  final String? telefon;
  final String? sifre;
  final String? resim;
  final String? il;
  final String? ilce;
  final String? adres;
  final String? tc;
  final String? firmaadi;
  final String? vergino;
  final String? vergidairesi;
  final String? firma_tel;
  final String? firma_adres;
  final int? kampanya_eposta;
  final int? kampanya_sms;
  final String? indirim;
  final int? statu;
  final int? durum;
  final int? ceponay;
  final String? cepkod;
  final int? emailonay;
  final String? emailkod;
  final String? son_giris;
  final String? tarih;
  final String? ay;
  final String? ktarih;
  final int? parasutuyeid;
  final int? vatandas; //normalde zorunlu ama default değer de istiyor
  final int? vip;
  final String? mnot;
  final String? ip;

  TabloUyeler({
    required this.id,
    this.fbid = 0,
    this.hesap = 1,
    this.vergi = 1,
    this.ad,
    this.soyad,
    this.email,
    this.telefon,
    this.sifre,
    this.resim,
    this.il,
    this.ilce,
    this.adres,
    this.tc,
    this.firmaadi,
    this.vergino,
    this.vergidairesi,
    this.firma_tel,
    this.firma_adres,
    this.kampanya_eposta = 0,
    this.kampanya_sms = 0,
    this.indirim,
    this.statu = 0,
    this.durum = 0,
    this.ceponay = 0,
    this.cepkod,
    this.emailonay = 0,
    this.emailkod,
    this.son_giris,
    this.tarih,
    this.ay,
    this.ktarih,
    this.parasutuyeid = 0,
    this.vatandas =
        0, //normalde required olması lazım ama varsaylan değer verilmiş 0
    this.vip = 0,
    this.mnot,
    this.ip,
  });

  factory TabloUyeler.fromJson(Map<String, dynamic> json) {
    return TabloUyeler(
      id: json['id'] as int,
      fbid: json['fbid'] as int?,
      hesap: json['hesap'] as int?,
      vergi: json['vergi'] as int?,
      ad: json['ad'] as String?,
      soyad: json['soyad'] as String?,
      email: json['email'] as String?,
      telefon: json['telefon'] as String?,
      sifre: json['sifre'] as String?,
      resim: json['resim'] as String?,
      il: json['il'] as String?,
      ilce: json['ilce'] as String?,
      adres: json['adres'] as String?,
      tc: json['tc'] as String?,
      firmaadi: json['firmaadi'] as String?,
      vergino: json['vergino'] as String?,
      vergidairesi: json['vergidairesi'] as String?,
      firma_tel: json['firma_tel'] as String?,
      firma_adres: json['firma_adres'] as String?,
      kampanya_eposta: json['kampanya_eposta'] as int?,
      kampanya_sms: json['kampanya_sms'] as int?,
      indirim: json['indirim'] as String?,
      statu: json['statu'] as int?,
      durum: json['durum'] as int?,
      ceponay: json['ceponay'] as int?,
      cepkod: json['cepkod'] as String?,
      emailonay: json['emailonay'] as int?,
      emailkod: json['emailkod'] as String?,
      son_giris: json['son_giris'] as String?,
      tarih: json['tarih'] as String?,
      ay: json['ay'] as String?,
      ktarih: json['ktarih'] as String?,
      parasutuyeid: json['parasutuyeid'] as int?,
      vatandas: json['vatandas'] as int?,
      vip: json['vip'] as int?,
      mnot: json['mnot'] as String?,
      ip: json['ip'] as String?,
    );
  }
}
