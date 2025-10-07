

class Student {
  int? id;
  String? name;
  String? email;
  String? photo;
  User? user;
  Section? section;
  SchoolClass? schoolClass;

  Student(
      {this.id,
        this.name,
        this.email,
        this.photo,
        this.user,
        this.section,
        this.schoolClass});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    section =
    json['section'] != null ? new Section.fromJson(json['section']) : null;
    schoolClass = json['schoolClass'] != null
        ? new SchoolClass.fromJson(json['schoolClass'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['photo'] = this.photo;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.section != null) {
      data['section'] = this.section!.toJson();
    }
    if (this.schoolClass != null) {
      data['schoolClass'] = this.schoolClass!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? photo;
  String? password;
  String? role;

  User(
      {this.id,
        this.username,
        this.email,
        this.photo,
        this.password,
        this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    photo = json['photo'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['password'] = this.password;
    data['role'] = this.role;
    return data;
  }
}

class Section {
  int? id;
  String? name;

  Section({this.id, this.name});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class  SchoolClass{
  int? id;
  String? name;

  SchoolClass({this.id, this.name});

  SchoolClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
