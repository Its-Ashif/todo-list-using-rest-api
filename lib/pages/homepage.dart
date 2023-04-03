import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_app/pages/addTask.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/utils/snakbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todo List")),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()));
          },
          label: Text("Add Task")),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(onSelected: (value) {
                  if (value == 'Edit') {
                    //Edit here
                  } else if (value == 'Delete') {
                    deleteById(id);
                  }
                }, itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'Edit',
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Delete',
                      ),
                      value: 'Delete',
                    )
                  ];
                }),
              );
            }),
      ),
    );
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {}
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      showSnackBar(context, "Deleted Successfully");
      fetchTodo();
    } else {
      showSnackBar(context, "Something went wrong! Please try again");
    }
  }
}
