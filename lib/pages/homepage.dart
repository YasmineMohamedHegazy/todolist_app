import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/pages/secondpage.dart';
import 'package:flutter_todoapp/utilities/dashboardwidget.dart';
import 'package:flutter_todoapp/utilities/taskcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;

  void _showAddTaskDialog() {
    final taskController = TextEditingController();
    final List<TextEditingController> subTaskControllers = [];
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add New Task"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(labelText: "Task Name"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text(
                        selectedDate == null
                            ? "Pick Task Date"
                            : "Task Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setDialogState(() {
                          subTaskControllers.add(TextEditingController());
                        });
                      },
                      child: const Text("Add Subtask"),
                    ),
                    Column(
                      children: subTaskControllers
                          .map((controller) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(labelText: "Subtask"),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty && selectedDate != null) {
                      final newTask = {
                        "task": taskController.text,
                        "taskDate": DateFormat('yyyy-MM-dd').format(selectedDate!),
                        "completed": false,
                        "subtasks": subTaskControllers.map((controller) => {
                              "subtask": controller.text,
                              "completed": false,
                            }).toList(),
                      };

                      setState(() {
                        tasks.add(newTask);
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add Task"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateMainTaskCompletion(Map<String, dynamic> task) {
    bool allSubtasksCompleted = task["subtasks"].every((subtask) => subtask["completed"] == true);
    setState(() {
      task["completed"] = allSubtasksCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);

    List<Map<String, dynamic>> todayTasks = tasks.where((task) => task["taskDate"] == todayStr).toList();
    List<Map<String, dynamic>> upcomingTasks = tasks.where((task) => task["taskDate"] != todayStr).toList();

    Widget page; //page is a variable that may store widgets
    switch (selectedIndex) {
      case 0:
        page = Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DashboardWidget(tasks: tasks),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (todayTasks.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Today's Tasks", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (todayTasks.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todayTasks.length,
                          itemBuilder: (context, index) => TaskCard(
                            task: todayTasks[index],
                            onDelete: () {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            },
                            onComplete: () {
                              setState(() {
                                todayTasks[index]["completed"] = !todayTasks[index]["completed"];
                                bool isChecked = todayTasks[index]["completed"];
                                for (var subtask in todayTasks[index]["subtasks"]) {
                                  subtask["completed"] = isChecked;
                                }
                              });
                            },
                            onSubtaskComplete: _updateMainTaskCompletion,
                          ),
                        ),
                      if (upcomingTasks.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Upcoming Tasks", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (upcomingTasks.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: upcomingTasks.length,
                          itemBuilder: (context, index) => TaskCard(
                            task: upcomingTasks[index],
                            onDelete: () {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            },
                            onComplete: () {
                              setState(() {
                                upcomingTasks[index]["completed"] = !upcomingTasks[index]["completed"];
                                bool isChecked = upcomingTasks[index]["completed"];
                                for (var subtask in upcomingTasks[index]["subtasks"]) {
                                  subtask["completed"] = isChecked;
                                }
                              });
                            },
                            onSubtaskComplete: _updateMainTaskCompletion,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case 1:
        page = const SecondPage();
        break;
      default:
        page = const Center(child: Text("Page not found"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("TO-DO List")),
      body: page,
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddTaskDialog,
              child: const Icon(Icons.assignment_add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
