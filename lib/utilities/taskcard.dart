import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final Function(Map<String, dynamic>) onSubtaskComplete; // Callback to notify parent

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onComplete,
    required this.onSubtaskComplete, // Pass the callback here
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Main Task Tile
          ListTile(
            leading: GestureDetector(
              onTap: onComplete,  // When tapped, trigger the completion toggle for the main task
              child: Icon(
                task["completed"] ? Icons.check_circle : Icons.radio_button_unchecked,
                color: task["completed"] ? Colors.green : Colors.grey,
              ),
            ),
            title: Text(
              task["task"],
              style: TextStyle(
                fontSize: 16,
                decoration: task["completed"] ? TextDecoration.lineThrough : null,
                color: task["completed"] ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(
              "Task Date: ${task["taskDate"]}",
              style: const TextStyle(color: Colors.blueGrey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,  // Handle task deletion
            ),
          ),



          Divider(
            thickness: 1,
            color: Colors.grey, // Customize the color of the line
          ),

          // Display Subtasks
          if (task["subtasks"] != null && task["subtasks"].isNotEmpty)
            Column(
              children: task["subtasks"].map<Widget>((subtask) {
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      // Toggle completion for the subtask and notify parent
                      subtask["completed"] = !subtask["completed"];
                      onSubtaskComplete(task); // Notify parent to update main task
                    },
                    child: Icon(
                      subtask["completed"] ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: subtask["completed"] ? Colors.green : Colors.grey,
                    ),
                  ),
                  title: Text(
                    subtask["subtask"],
                    style: TextStyle(
                      fontSize: 14,
                      decoration: subtask["completed"] ? TextDecoration.lineThrough : null,
                      color: subtask["completed"] ? Colors.grey : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
