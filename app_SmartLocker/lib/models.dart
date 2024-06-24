class AuthStatus {
  bool isLoggedIn;
  User user;

  AuthStatus(this.isLoggedIn, this.user);
  void updateUser(User updatedUser) {
    user = updatedUser;
  }

  // Thêm phương thức logout
  void logout() {
    isLoggedIn = false;
    user = User.defaultUser();
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> roles;
  User.defaultUser()
      : id = "defaultId",
        name = "defaultName",
        email = "defaultEmail",
        phone = "defaultPhone",
        roles = ["defaultRole"];
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
  });

  User copyWith({String? name, String? email, required String phone}) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: this.phone,
      roles: this.roles,
    );
  }
}



class History {
  final int historyId;
  final List<UserHistory> userHistory;
  final DateTime startTime;
  final DateTime endTime;
  final List<Location> location;
  final DateTime otpExpireTime;
  final int onProcedure;
  History({
    required this.historyId,
    required this.userHistory,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.otpExpireTime,
    required this.onProcedure
  });
}

class UserHistory {
  final int userId;
  final String name;
  final String phone;
  final String role;

  UserHistory({
    required this.userId,
    required this.name,
    required this.phone,
    required this.role,
  });
}

class Location {
  final String locationName;
  final String roleLocation;

  Location({
    required this.locationName,
    required this.roleLocation,
  });
}
