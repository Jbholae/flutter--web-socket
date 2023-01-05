class CreateUserResponse {
  String? data;
  CreateUserResponse({this.data});

  CreateUserResponse.fromJson(Map<String, dynamic> json) {
    data = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['msg'] = this.data;
    return data;
  }
}
