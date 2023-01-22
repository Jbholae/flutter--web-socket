class GetAllUserResponse {
  List<GetAllUserResponseData>? responseData;
  GetAllUserResponse({this.responseData});

  GetAllUserResponse.fromJson(Map<String, dynamic> json) {
    responseData = json['data']
        .map<GetAllUserResponseData>((e) => GetAllUserResponseData.fromJson(e))
        .toList();
  }
}

class GetAllUserResponseData {
  String? id;
  String? fullName;
  String? email;

  GetAllUserResponseData({
    this.email,
    this.fullName,
    this.id,
  });

  factory GetAllUserResponseData.fromJson(Map<String, dynamic> json) {
    return GetAllUserResponseData(
      email: json['email'],
      fullName: json['full_name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    return data;
  }
}
