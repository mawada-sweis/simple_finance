class User {
  final String id;
  final String fullName;
  final String address;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.address,
    required this.phone,
    required this.role,
  });

  // Convert Firestore data to User model
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      fullName: (data['full_name'] != "NA")
          ? data['full_name'] ?? 'لا يوجد اسم'
          : 'لا يوجد اسم',
      address: (data['address'] != "NA")
          ? data['address'] ?? 'لا يوجد عنوان'
          : 'لا يوجد عنوان',
      phone: (data['phone'] != "NA")
          ? data['phone'] ?? 'لا يوجد رقم'
          : 'لا يوجد رقم',
      role: (data['role'] != "NA")
          ? data['role'] ?? 'لا يوجد دور'
          : 'لا يوجد دور',
    );
  }
}
