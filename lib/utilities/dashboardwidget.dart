import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const DashboardWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> ongoingTasks =
        tasks.where((task) => task["completed"] == false).toList();
    List<Map<String, dynamic>> completedTasks =
        tasks.where((task) => task["completed"] == true).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 129, 166, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.autorenew, color: Colors.white),
                      const SizedBox(height: 4),
                      const Text(
                        "Ongoing Tasks",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("${ongoingTasks.length}",
                          style: const TextStyle(fontSize: 10, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 7, 223, 97),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white),
                      const SizedBox(height: 4),
                      const Text(
                        "Completed Tasks",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold),
                      ),
                      Text("${completedTasks.length}",
                          style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 255, 255, 255))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),  // Optional spacing between the dashboard and the line
          const Divider(  // Adding a line under the dashboard
            color: Colors.grey,  // You can customize the color of the line
            thickness: 1,  // You can adjust the thickness of the line
          ),
        ],
      ),
    );
  }
}
