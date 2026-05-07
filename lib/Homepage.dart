import 'package:flutter/material.dart';
import 'listpage.dart';
import 'workout.dart';
import 'suggestedworkout.dart';

class Homepage extends StatefulWidget {
  final String level;
  final String goal;

  const Homepage({
    super.key,
    required this.level,
    required this.goal,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> sessions = [
    "Push Day",
    "Pull Day",
    "Leg Day",
    "Core Day",
  ];

  late Map<String, double> progress;

  final List<String> weekSchedule = [
    "Push Day",
    "Rest",
    "Pull Day",
    "Leg Day",
    "Rest",
    "Core Day",
    "Rest",
  ];

  @override
  void initState() {
    super.initState();

    progress = {
      "Push Day": 0,
      "Pull Day": 0,
      "Leg Day": 0,
      "Core Day": 0,
    };
  }

  String getTodayWorkout() {
    int weekday = DateTime.now().weekday;
    return weekSchedule[weekday - 1];
  }

  List<Map<String, dynamic>> getWorkout(String sessionName) {
    final goalData = workoutData[widget.goal];
    if (goalData == null) {
      return [
        {"exercise": "No Goal Found", "value": ""}
      ];
    }

    final levelData = goalData[widget.level];
    if (levelData == null) {
      return [
        {"exercise": "No Level Found", "value": ""}
      ];
    }

    final sessionData = levelData[sessionName];
    if (sessionData == null) {
      return [
        {"exercise": "Rest Day", "value": "Take rest"}
      ];
    }

    return List<Map<String, dynamic>>.from(sessionData);
  }

  List<Map<String, dynamic>> getSuggestedWorkout(String category) {
    final goalData = suggestedWorkouts[widget.goal];
    if (goalData == null) return [];

    final levelData = goalData[widget.level];
    if (levelData == null) return [];

    final categoryData = levelData[category];
    if (categoryData == null) return [];

    return List<Map<String, dynamic>>.from(categoryData);
  }

  Widget workoutCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPage(
                    title: title,
                    exercises: getWorkout(title),
                  ),
                ),
              );

              if (result != null && result is double) {
                setState(() {
                  progress[title] = result;
                });
              }
            },

            child: Container(
              padding: const EdgeInsets.all(8),

              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 0, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dashboard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Today's Progress",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 229, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ...sessions.map((s) {
            double value = progress[s] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    s,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 5),

                  LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.white12,
                    color: Colors.blue,
                    minHeight: 10,
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "${(value * 100).toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget suggestedWorkoutSection() {
    final suggestions = getSuggestedWorkout("Full Body");

    if (suggestions.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Suggested Workouts",
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ...suggestions.map((workout) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    workout["exercise"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    workout["value"],
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/64d8e4a09654aded67cf7975db1e1eda.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: Row(
                      children: [
                        Image.asset(
                          "assets/12155872.png",
                          width: 70,
                          height: 70,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "WORKOUT TODAY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Session Today: ${getTodayWorkout()}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              Text(
                                "Level: ${widget.level}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              Text(
                                "Goal: ${widget.goal}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      children: [
                        ...sessions.map(workoutCard).toList(),

                        dashboard(),

                        suggestedWorkoutSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}