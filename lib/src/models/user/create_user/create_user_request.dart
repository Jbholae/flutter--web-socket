class CreateUserRequest {
  String? name;
  String? email;

  CreateUserRequest({this.name, this.email});

  CreateUserRequest.formJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
