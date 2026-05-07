import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> exercises;

  const ListPage({
    super.key,
    required this.title,
    required this.exercises,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Set<int> completedIndexes = {};

  late List<Map<String, dynamic>> workouts;

  @override
  void initState() {
    super.initState();

    workouts = List<Map<String, dynamic>>.from(widget.exercises);
  }

  void toggleWorkout(int index) {
    setState(() {
      if (completedIndexes.contains(index)) {
        completedIndexes.remove(index);
      } else {
        completedIndexes.add(index);
      }
    });
  }

  void deleteWorkout(int index) {
    setState(() {
      workouts.removeAt(index);

      completedIndexes = completedIndexes
          .where((i) => i != index)
          .map((i) => i > index ? i - 1 : i)
          .toSet();
    });
  }

  void finishWorkout() {
    double progress =
        workouts.isEmpty ? 0 : completedIndexes.length / workouts.length;

    Navigator.pop(context, progress);
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = completedIndexes.length;
    final totalCount = workouts.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF121212),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Workout Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "$completedCount / $totalCount Completed",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: totalCount == 0
                      ? 0
                      : completedCount / totalCount,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade800,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),

          Expanded(
            child: workouts.isEmpty
                ? const Center(
                    child: Text(
                      "No workouts available",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];

                      final done = completedIndexes.contains(index);

                      return Card(
                        color: const Color(0xFF2A2A2A),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),

                          leading: Checkbox(
                            value: done,

                            onChanged: (_) =>
                                toggleWorkout(index),

                            activeColor: Colors.blue,

                            checkColor: Colors.white,
                          ),

                          title: Text(
                            workout["exercise"] ?? "",

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,

                              decoration: done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              workout["value"] ?? "",

                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),

                            onPressed: () =>
                                deleteWorkout(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            child: ElevatedButton(
              onPressed: finishWorkout,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,

                padding:
                    const EdgeInsets.symmetric(vertical: 16),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              child: const Text(
                "Finish Workout",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}