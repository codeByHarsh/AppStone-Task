// ignore_for_file: avoid_print

import 'package:app_stone_task/api/api_users_provider.dart';
import 'package:app_stone_task/modals/user_data_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  List<Data> dataUser = [];
  @override
  void initState() {
    super.initState();
    ref.read(userDataProvider).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('AppStone Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Consumer(
          builder: (context, ref, child) {
            // UserDataModal userDataModal =
            //     ref.watch(userDataProvider).userDataModal!;
            Status status = ref.watch(userDataProvider).status;
            if (status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (status == Status.error) {
              return const Center(
                child: Text('Error Occurred!!'),
              );
            } else {
              UserDataModal userDataModal =
                  ref.watch(userDataProvider).userDataModal!;
              return ListView.builder(
                  itemCount: userDataModal.data.length,
                  itemBuilder: ((context, index) {
                    dataUser = userDataModal.data;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              dataUser[index].avatar!,
                              height: 80,
                              width: 80,
                            ),
                          ),
                          Text(
                            dataUser[index].firstName! +
                                ' ' +
                                dataUser[index].lastName!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueAccent),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                dataUser.removeWhere(
                                    (item) => item.id == dataUser[index].id);
                                setState(() {});
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  content: Text("Deleted Successfully"),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white, elevation: 0.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    );
                  }));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.refresh, color: Colors.white, size: 20),
        onPressed: () {
          ref.read(userDataProvider).fetchUsers();
        },
      ),
    ));
  }
}
