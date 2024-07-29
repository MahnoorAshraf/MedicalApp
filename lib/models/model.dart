class Doctor {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String education;
  final String experience;
  final String designation;
  final String speciality;
  final String address;
  final String contactNo;
  final String sConsWeekday;
  final String sConsWeekend;
  final String lConsWeekday;
  final String lConsWeekend;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.education,
    required this.experience,
    required this.designation,
    required this.speciality,
    required this.address,
    required this.contactNo,
    required this.sConsWeekday,
    required this.sConsWeekend,
    required this.lConsWeekday,
    required this.lConsWeekend,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']as int? ??0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      education: json['education']  as String? ?? '',
      experience: json['experience']  as String? ?? '',
      designation: json['designation'] as String? ?? '',
      speciality: json['speciality'] as String? ?? '',
      address: json['address'] as String? ?? '',
      contactNo: json['contact_no']  as String? ?? '',
      sConsWeekday: json['s_cons_weekday'] as String? ?? '' ,
      sConsWeekend: json['s_cons_weekend'] as String? ?? '',
      lConsWeekday: json['l_cons_weekday']  as String? ?? '',
      lConsWeekend: json['l_cons_weekend'] as String? ?? '',
    );
  }
}
