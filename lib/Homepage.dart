import 'package:flutter/material.dart';
import 'Listpage.dart';

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

  final List<String> session = [
    "Push Day",
    "Pull Day",
    "Leg Day",
    "Core Day"
  ];

  final Map<String, dynamic> workoutData = {
    "Beginner": {
      "Lose Weight": {
        "Push Day": [
        "Incline Push-Ups, 3 sets of 10-12 reps",
        "Dumbbell Shoulder Press, 3 sets of 10-12 reps",
        "Chest Press (machine or dumbbells), 3 sets of 10-12 reps",
        "Tricep Dips (bench or chair), 3 sets of 8-10 reps"
        ],

        "Pull Day" : [
          "Lat Pulldown(machine), 3 sets of 10-12 reps",
          "Seated Row(machine or resistance band), 3 sets of 10-12 reps",
          "Dumbbell Bicep Curl, , 3 sets of 12-15 reps",
          "Face Pulls (cable or band), 3 sets of 12-15 reps"
        ],

        "Leg Day" : [
          "Bodyweight Squats, 3 sets of 12-15 reps",
          "Glute Bridges, 3 sets of 12-15 reps",
          "Set Ups(bench or chair),3 sets of 10 each leg",
          "Calf Raises, 3 sets of 15-20 reps"
        ],

        "Core Day" : [
          "Plank, 3 rounds(hold 20 - 30 secs)",
          "Russian Twists(bodyweight or light weight), 3 sets of 12 each side",
          "Leg Raise(lying down), 3 sets of 10-12 reps",
          "Mountain Climbers, 3 sets of 20-30 sec"
        ],
      },

      "Gain Muscle" : {
        "Push Day": [
        "Push-Ups, 3 sets of 8-12 reps",
        "Dumbbell Shoulder Press, 3 sets of 10-12 reps",
        "Chest Press (machine or dumbbells), 3 sets of 10-12 reps",
        "Tricep Dips (bench or chair), 3 sets of 8-10 reps"
        ],

        "Pull Day" : [
          "Dumbbell Rows, 3 sets of 8-12 reps",
          "Lat Pulldown, 3 sets of 10-12 reps",
          "Bicep Curls, , 3 sets of 10-15 reps",
          "Face Pulls (cable or band), 3 sets of 10-15 reps"
        ],

        "Leg Day" : [
          "Bodyweight Squats, 3 sets of 12-15 reps",
          "Glute Bridges, 3 sets of 12-15 reps",
          "Set Ups(bench or chair),3 sets of 10 each leg",
          "Calf Raises, 3 sets of 15-20 reps"
        ],

        "Core Day" : [
          "Plank, 3 rounds(hold 20 - 30 secs)",
          "Russian Twists(bodyweight or light weight), 3 sets of 12 each side",
          "Leg Raise(lying down), 3 sets of 10-12 reps",
          "Mountain Climbers, 3 sets of 20-30 sec"
        ],
      },

      "Stay Fit" : {
        "Push Day": [
        "Push-Ups, 3 sets of 10-12 reps"
        ],

        "Pull Day" : [
          "Dumbbell Bicep Curl, 3 sets of 10-12 reps",
          "Pull-Ups (or Assisted Pull-Ups/Band Rows), 3 sets of 6-8 reps"
        ],

        "Leg Day" : [
          "Squats, 3 sets of 12-15 reps",
          "Glute Bridges, 3 sets of 12-15 reps"
        ],

        "Core Day" : [
          "Plank, 3 rounds(hold 20 - 30 secs)",
          "Russian Twists(bodyweight or light weight), 3 sets of 12 each side"
        ],
      },
    },
    
    "Intermediate": {
      "Lose Weight": {
        "Push Day": [
          "Decline Push-Ups, 4 sets of 12-15 reps",
          "Dumbbell Shoulder Press, 4 sets of 10-12 reps",
          "Chest Press (barbell or dumbbells), 4 sets of 10-12 reps",
          "Tricep Dips (bench or chair), 4 sets of 10-12 reps"
        ],
        
        "Pull Day": [
          "Pull-Ups (assisted if needed), 4 sets of 8-10 reps",
          "Seated Row (machine or band), 4 sets of 10-12 reps",
          "Dumbbell Bicep Curl, 4 sets of 12-15 reps",
          "Face Pulls (cable or band), 4 sets of 12-15 reps"
        ],
        "Leg Day": [
          "Goblet Squats, 4 sets of 12-15 reps",
          "Hip Thrusts, 4 sets of 12-15 reps",
          "Walking Lunges, 3 sets of 10 each leg",
          "Standing Calf Raises, 4 sets of 15-20 reps"
          ],
          "Core Day": [
            "Plank with Shoulder Tap, 3 rounds of 30-40 secs",
            "Russian Twists (weighted), 4 sets of 15 each side",
            "Hanging Leg Raises, 3 sets of 10-12 reps",
            "Mountain Climbers, 4 sets of 30-40 secs"
          ],
        },
        
        "Gain Muscle": {
          "Push Day": [
            "Barbell Bench Press, 4 sets of 8-10 reps",
            "Overhead Press (barbell or dumbbells), 4 sets of 8-10 reps",
            "Incline Dumbbell Press, 4 sets of 8-10 reps",
            "Tricep Rope Pushdowns, 4 sets of 10-12 reps"
          ],
          "Pull Day": [
            "Barbell Rows, 4 sets of 8-10 reps",
            "Pull-Ups (weighted if possible), 4 sets of 6-8 reps",
            "Incline Dumbbell Curl, 4 sets of 10-12 reps",
            "Face Pulls (cable), 4 sets of 12-15 reps"
          ],
          "Leg Day": [
            "Barbell Squats, 4 sets of 8-10 reps",
            "Romanian Deadlifts, 4 sets of 8-10 reps",
            "Bulgarian Split Squats, 3 sets of 8-10 each leg",
            "Standing Calf Raises, 4 sets of 12-15 reps"
          ],
          "Core Day": [
            "Weighted Plank, 3 rounds of 30-40 secs",
            "Cable Woodchoppers, 4 sets of 12 each side",
            "Hanging Knee Raises, 3 sets of 10-12 reps",
            "Ab Rollouts, 3 sets of 10-12 reps"
          ],
        },
        "Stay Fit": {
          "Push Day": [
            "Push-Ups, 3 sets of 12-15 reps",
            "Dumbbell Shoulder Press, 3 sets of 10-12 reps"
            ],
            "Pull Day": [
              "Pull-Ups (or Assisted), 3 sets of 8-10 reps",
              "Dumbbell Bicep Curl, 3 sets of 10-12 reps"
            ],
            "Leg Day": [
              "Squats, 3 sets of 12-15 reps",
              "Glute Bridges, 3 sets of 12-15 reps"
            ],
            "Core Day": [
              "Plank, 3 rounds of 30-40 secs",
              "Russian Twists, 3 sets of 12 each side"
            ],
      },
    },
    "Advance": {
      "Lose Weight": {
        "Push Day": [
        "Decline Push Ups, 4 sets of 15-20 reps",
        "Dumbbell Arnold Press, 4 sets of 12-15 reps",
        "Barbell Bench Press, 4 sets of 12-15 reps",
        "Tricep Dips (weighted if possible), 4 sets of 12-15 reps"
        ],

        "Pull Day" : [
          "Pull-Ups (weighted or strict form), 4 sets of 8-12 reps",
          "- Barbell Rows, 4 sets of 12-15 reps",
          "Dumbbell Hammer Curl, , 4 sets of 12-15 reps",
          "Face Pulls (cable or band), 3 sets of 15-20 reps"
        ],

        "Leg Day" : [
          "Barbell Squats, 4 sets of 12-15 reps",
          "Romanian Deadlifts, 4 sets of 12-15 reps",
          "Bulgarian Split Squats,3 sets of 12 each leg",
          "Standing Calf Raises, 4 sets of 20 reps"
        ],

        "Core Day" : [
          "Weighted Plank, 3 rounds(hold 40 - 60 secs)",
          "Hanging Leg Raises, 4 sets of 12-15 reps",
          "Cable Woodchoppers, 4 sets of 12 each side",
          "Mountain Climbers, 4 sets of 40 sec"
        ],
      },

      "Gain Muscle" : {
        "Push Day": [
        "Barbell Bench Press, 5 sets of 6-8 slow reps",
        "Overhead Press, 5 sets of 6-8 slow reps",
        "Incline Dumbbell Press, 4 sets of 8-10 slow reps",
        "Skull Crushers, 4 sets of 10-12 reps"
        ],

        "Pull Day" : [
          "Deadlifts, 4 sets of 5-6 reps",
          "Weighted Pull Ups , 4 sets of 6-8 slow reps",
          "Barbell Rows, 4 sets of 8-10 slow reps",
          "Incline Dumbbell Curl, 4 sets of 10-12 slow reps"
        ],

        "Leg Day" : [
          "Barbell Squats, 5 sets of 6-8 slow reps",
          "Romanian Deadlifts, 4 sets of 8-10 slow reps",
          "Walking Lunges, 3 sets of 12 each leg",
          "Walking Lunges, 4 sets of 12-15 slow reps"
        ],

        "Core Day" : [
          "Weighted Plank, 3 rounds(hold 50 - 90 secs)",
          "Ab Rollouts, 4 sets of 10-12 slow reps",
          "Hanging Knee Raises, 4 sets of 12-15 slow reps",
          "Cable Crunches, 4 sets of 12-15 slow reps"
        ],
      },

      "Stay Fit" : {
        "Push Day": [
        "Push-Ups, reps until failure",
        "Dumbbell Shoulder Press, 3 sets of 12-15 slow reps"
        ],

        "Pull Day" : [
          "Dumbbell Bicep Curl, 3 sets of 12-15 slow reps",
          "Pull-Ups, 3 sets of 12-15 slow reps"
        ],

        "Leg Day" : [
          "Squats, 3 sets of 15-20 slow reps",
          "Glute Bridges, 3 sets of 15-20 slow reps"
        ],

        "Core Day" : [
          "Plank, 3 rounds(hold 50 - 90 secs)",
          "Russian Twists, 3 sets of 15 each side"
        ],
      },
    }, 
  };

  List<String> getWorkout(String sessionName) {
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPage(
                    title: title,
                    exercises: getWorkout(title),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          )
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
                image: AssetImage("assets/bg.jpg"),
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
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 70),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "WORKOUT TODAY",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Level: ${widget.level}",
                              style:
                                  const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Goal: ${widget.goal}",
                              style:
                                  const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: ListView.builder(
                      itemCount: session.length,
                      itemBuilder: (context, index) {
                        return workoutCard(session[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Workout",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "List",
          ),
        ],
      ),
    );
  }
}