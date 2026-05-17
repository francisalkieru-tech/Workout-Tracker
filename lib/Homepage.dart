import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'listpage.dart';
import 'workout.dart';
import 'suggestedworkout.dart';
import 'profilepage.dart';

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
  int _selectedTab = 0;
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
      for (var s in sessions) s: 0.0,
    };
    loadProgress();
  }

  String getTodayWorkout() {
    int weekday = DateTime.now().weekday;
    return weekSchedule[weekday - 1];
  }

  List<Map<String, dynamic>> getWorkout(String sessionName) {
    final goalData = workoutData[widget.goal];
    if (goalData is! Map) return [{"exercise": "Invalid Goal", "value": ""}];

    final levelData = goalData[widget.level];
    if (levelData is! Map) return [{"exercise": "Invalid Level", "value": ""}];

    final sessionData = levelData[sessionName];
    if (sessionData is! List) return [{"exercise": "Rest Day", "value": "Take rest"}];

    return sessionData.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  List<Map<String, dynamic>> getSuggestedWorkout() {
    final goalData = suggestedWorkouts[widget.goal];
    if (goalData is! Map) return [];

    final levelData = goalData[widget.level];
    if (levelData is! List) return [];

    return List<Map<String, dynamic>>.from(levelData);
  }

  String getWeekId() {
    final now = DateTime.now();
    final weekOfYear = ((now.difference(DateTime(now.year, 1, 1)).inDays) / 7).floor();
    return "${now.year}-W$weekOfYear";
  }

  Future<void> saveProgress(String session, double value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final weekId = getWeekId();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weekly_progress')
        .doc(weekId)
        .collection('sessions')
        .doc(session)
        .set({
      'value': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> loadProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final weekId = getWeekId();

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weekly_progress')
        .doc(weekId)
        .collection('sessions')
        .get();

    final data = {for (var d in snapshot.docs) d.id: d.data()};

    setState(() {
      for (var s in sessions) {
        progress[s] = (data[s]?['value'] ?? 0).toDouble();
      }
    });
  }

  Future<void> logWorkout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final dateKey = "${today.year}-${today.month}-${today.day}";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .doc(dateKey)
        .set({"date": Timestamp.now()});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
          'total_workouts': FieldValue.increment(1),
        });
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
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPage(
                    title: title,
                    exercises: getWorkout(title),
                    suggested: getSuggestedWorkout(), // ✅ passed correctly
                  ),
                ),
              );

              if (result != null && result is double) {
                setState(() {
                  progress[title] = result;
                });
                await saveProgress(title, result);
                if (result > 0) await logWorkout();
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
            "This Week Progress",
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
                  Text(s, style: const TextStyle(color: Colors.white70)),
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
                    style: const TextStyle(color: Colors.white),
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
                        Image.asset("assets/12155872.png", width: 70, height: 70),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                "Level: ${widget.level}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                "Goal: ${widget.goal}",
                                style: const TextStyle(color: Colors.white70),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) {
          setState(() => _selectedTab = i);
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  level: widget.level,
                  goal: widget.goal,
                ),
              ),
            );
          }
        },
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF00E5FF),
        unselectedItemColor: Colors.white38,
        items: [
          BottomNavigationBarItem(
            icon: Lottie.asset(
              'assets/system-regular-41-home-hover-pinch.json',
              width: 28,
              height: 28,
              repeat: false,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Lottie.asset(
              'assets/wired-gradient-21-avatar-hover-jumping.json',
              width: 28,
              height: 28,
              repeat: false,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}