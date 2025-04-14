class User {
  int? id;
  String? name;
  String? lastName;
  String? firstName;
  String? email;
  String? phone;
  String? age;
  String? roleId;
  String? uniqueId;
  String? gender;
  String? rememberToken;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? profilePic;

  User(
      {this.id,
        this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.age,
        this.roleId,
        this.uniqueId,
        this.profilePic,
        this.gender,
        this.rememberToken,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    age = json['age'];
    roleId = json['role_id'];
    uniqueId = json['unique_id'];
    gender = json['gender'];
    rememberToken = json['remember_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePic = json['profile_pic'] != null && !json['profile_pic'].toString().startsWith('http')
    ? 'http://10.0.2.2:8000/api/${json['profile_pic']}'
    : json['profile_pic'];
    print("checking for first name $id");
    print("checking for name $name");
    print("checking for first name $lastName");
    print("checking for first name $email");
    print("checking for first name $phone");
    print("checking for first name $rememberToken");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['age'] = age;
    data['role_id'] = roleId;
    data['unique_id'] = uniqueId;
    data['profile_pic'] = profilePic;
    data['gender'] = gender;
    data['remember_token'] = rememberToken;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    
    print("checking for first name $id");
    print("checking for first name $name");
    print("checking for first name $lastName");
    print("checking for first name $email");
    print("checking for first name $phone");
    print("checking for first name $rememberToken");
    return data;
  }
}