import 'dart:io';

import 'package:dio/dio.dart';
import 'package:everyone_know_app/domain/model/status.dart';
import 'package:everyone_know_app/utils/endpoints/api_endpoint.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class CreateStatusService {
  Future<UserCreateStatus?> createStatusForUserint(
    String id,
    String text, {
    File? imgUrl,
  }) async {
    Map<String, dynamic> headers = <String, dynamic>{};
    headers.putIfAbsent("Authorization", () => 'Token 07f96707138a508f80418e0bd5dd31f80a56f204');
    headers.putIfAbsent("Content-Type", () => "multipart/form-data");
    headers.putIfAbsent("X-CSRFToken", () => "QQ80uhVlBRPjjNi9PGxdADoljTafbkc7t4ORKM3pQ1iJDXrXqkXcGDtzAZSoXnpt");
    headers.putIfAbsent("Content-Type", () => "application/json");
    headers.putIfAbsent("Accept", () => "application/json");
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    var formData = FormData.fromMap({
      'text': text,
      'user': int.tryParse(id),
      if (imgUrl != null)
        'image': await MultipartFile.fromFile(
          imgUrl.path,
          filename: basename(imgUrl.path),
        )
    });
    Response response = await dio.post(
      userStatusCreateUrl,
      data: formData,
      options: Options(
        headers: headers,
      ),
    );
    print(response.statusCode.toString() + "sssssssssssssssss");
    if (response.statusCode == 201) {
      //Logger().i("Create User Status : " + response.data);
      print(response.data);
      return UserCreateStatus.fromJson(response.data);
    } else {
      Logger().i("Create User Status Error : " + response.statusCode.toString());
      Fluttertoast.showToast(msg: "Error Dio CReate User : " + response.statusCode.toString());
    }
    return null;
  }
}
