import 'package:flutter/material.dart';
import 'listpage.dart';

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
  int currentIndex = 0;

  final List<String> session = ["Push Day", "Pull Day", "Leg Day", "Core Day"];

  Map<String, double> progress = {
    "Push Day": 0,
    "Pull Day": 0,
    "Leg Day": 0,
    "Core Day": 0,
  };

  final List<String> weekSchedule = [
    "Push Day",
    "Rest",
    "Pull Day",
    "Leg Day",
    "Rest",
    "Core Day",
    "Rest"
  ];

  String getTodayWorkout() {
    int weekday = DateTime.now().weekday;
    return weekSchedule[weekday - 1];
  }

  final Map<String, dynamic> workoutData = {
    "Beginner" : {
      "Lose Weight" : {
        "Push Day": [
        "Push-Ups, 3 sets of 8-10 reps",
        "Incline Push-Ups, 3 sets of 10 reps",
        "Shoulder Taps, 3 sets of 20 reps",
        "Knee Push-Ups, 3 sets of 12 reps",
        "Arm Circles, 3 sets of 30 secs"
        ],

        "Pull Day": [
        "Superman Hold, 3 sets of 20 secs",
        "Reverse Snow Angels, 3 sets of 10 reps",
        "Prone Y Raises, 3 sets of 12 reps",
        "Back Extensions, 3 sets of 10 reps",
        "Arm Swings, 3 sets of 30 secs"
        ],

        "Leg Day": [
        "Bodyweight Squats, 3 sets of 15 reps",
        "Lunges, 3 sets of 10 each leg",
        "Jump Squats, 3 sets of 10 reps",
        "Wall Sit, 3 sets of 30 secs",
        "Calf Raises, 3 sets of 15 reps"
        ],

        "Core Day": [
        "Plank, 3 sets of 30 secs",
        "Mountain Climbers, 3 sets of 30 secs",
        "Crunches, 3 sets of 12 reps",
        "Leg Raises, 3 sets of 10 reps",
        "Russian Twists, 3 sets of 12 each side"
        ],
      },

      "Gain Muscle": {
        "Push Day": [
        "Push-Ups, 3 sets of 10-12 reps",
        "Incline Push-Ups, 3 sets of 10 reps",
        "Pike Push-Ups, 3 sets of 8 reps",
        "Diamond Push-Ups, 3 sets of 8 reps",
        "Shoulder Taps, 3 sets of 20 reps"
        ],

        "Pull Day": [
        "Superman Hold, 3 sets of 20 secs",
        "Back Extensions, 3 sets of 10 reps",
        "Reverse Snow Angels, 3 sets of 10 reps",
        "Prone T Raises, 3 sets of 12 reps",
        "Dead Hang (if available), 3 sets of 15 secs"
        ],

        "Leg Day": [
        "Squats, 3 sets of 12-15 reps",
        "Lunges, 3 sets of 10 each leg",
        "Glute Bridges, 3 sets of 12 reps",
        "Wall Sit, 3 sets of 30 secs",
        "Calf Raises, 3 sets of 15 reps"
        ],
        
        "Core Day": [
        "Plank, 3 sets of 30 secs",
        "Leg Raises, 3 sets of 10 reps",
        "Russian Twists, 3 sets of 12 each side",
        "Heel Touches, 3 sets of 15 reps",
        "Bicycle Crunches, 3 sets of 12 reps"
        ],
      },
    },
  };

  List<String> getWorkout(String sessionName) {
    if (sessionName == "Rest") {
      return ["Rest Day - Make some rest"];
    }
    return workoutData[widget.level]?[widget.goal]?[sessionName] ?? ["No Data"];
  }

  Widget workoutCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
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
              child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 255, 255)),
            ),
          )
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
            style: TextStyle(color: Color.fromARGB(255, 0, 229, 255), fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ...session.map((s) {
            double value = progress[s]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.white12,
                    color: Colors.blue,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 5),
                  Text("${(value * 100).toInt()}%", style: const TextStyle(color: Colors.white)),
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
                image: AssetImage("assets/64d8e4a09654aded67cf7975db1e1eda.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
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
                        Image.asset("assets/12155872.png", width: 70, height: 70,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("WORKOUT TODAY", style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 10),
                            Text("Session Today: ${getTodayWorkout()}", style: const TextStyle( color: Colors.white70)),
                            Text("Level: ${widget.level}", style: const TextStyle(color: Colors.white70)),
                            Text("Goal: ${widget.goal}", style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      children: [
                        ...session.map(workoutCard).toList(),
                        dashboard(), // dashboard below
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