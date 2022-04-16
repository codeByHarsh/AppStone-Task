// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_stone_task/modals/user_data_modal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends ChangeNotifier {
  Status status = Status.loading;
  UserDataModal? userDataModal;
  fetchUsers() async {
    try {
      http.Response response =
          await http.get(Uri.parse('https://reqres.in/api/users?page1'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data is here \n' + response.body);
        userDataModal = UserDataModal.fromJson(jsonDecode(response.body));
        print(userDataModal!.data);
        status = Status.success;
        notifyListeners();
      } else {
        print('Response fail \n' + response.body);
        userDataModal = null;
        status = Status.error;
        notifyListeners();
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}

final userDataProvider =
    ChangeNotifierProvider<UsersProvider>(((ref) => UsersProvider()));

enum Status { loading, success, error }
