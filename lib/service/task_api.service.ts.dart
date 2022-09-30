import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/constants/api.env.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/model/user_model.ts.dart';

class TaskApiService {

  findAllUsers() async {
    try {
      var url = Uri.parse(ApiEnvConstants.baseUrl + ApiEnvConstants.userUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        return (responseJson as List)
            .map((p) => UserModel.fromJson(p))
            .toList();
      }
    } catch (e) {}
  }

  assignUserInTask(taskId, userId) async {
    final url = '${ApiEnvConstants.baseUrl}${ApiEnvConstants.taskUrl}/assigned/task/$taskId/user/$userId';
    return http.put(Uri.parse(url));
  }
}
