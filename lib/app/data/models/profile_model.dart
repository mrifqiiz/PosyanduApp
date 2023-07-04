class ProfileDbModel {
  final String userId;
  final String nama;
  final String tglLahir;
  final String golDarah;
  final String tb;
  final String bb;
  final String tglMenikah;

  ProfileDbModel({
    required this.userId,
    required this.nama,
    required this.tglLahir,
    required this.golDarah,
    required this.tb,
    required this.bb,
    required this.tglMenikah,
  });

  factory ProfileDbModel.fromJson(Map<String, dynamic> json) => ProfileDbModel(
        userId: json["user_id"],
        nama: json["nama"],
        tglLahir: json["tglLahir"],
        golDarah: json["golDarah"],
        tb: json["tb"],
        bb: json["tb"],
        tglMenikah: json["tglMenikah"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nama": nama,
        "tglLahir": tglLahir,
        "golDarah": golDarah,
        "tb": tb,
        "bb": tb,
        "tglMenikah": tglMenikah,
      };
}
