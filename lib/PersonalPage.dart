import 'package:flutter/material.dart';
import 'homepage.dart';

class Personalize extends StatefulWidget {
  const Personalize({super.key});

  @override
  _Personalize createState() => _Personalize();
}

class _Personalize extends State<Personalize> {
  String selectedLevel = "Beginner";
  String selectedGoal = "Lose Weight";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/38d70711789e7380cc4616afb6419918.jpg",
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Personalize ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.purple, Colors.cyan],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 50.0)),
                    ),
                    children: [
                      TextSpan(
                        text: "workout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                
                Text(
                  "Fitness Level:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Where do you want to start?",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: buildPillButton("Beginner", selectedLevel == "Beginner", () {
                        setState(() => selectedLevel = "Beginner");
                      }),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment(-0.3, 0),
                      child: buildPillButton("Intermediate", selectedLevel == "Intermediate", () {
                        setState(() => selectedLevel = "Intermediate");
                      }),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment(0.2, 0),
                      child: buildPillButton("Advance", selectedLevel == "Advance", () {
                        setState(() => selectedLevel = "Advance");
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Text(
                  "Goal:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "What is your goal?",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 15),

              
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: buildPillButton("Lose Weight", selectedGoal == "Lose Weight", () {
                        setState(() => selectedGoal = "Lose Weight");
                      }),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment(0.4, 0),
                      child: buildPillButton("Gain Muscle", selectedGoal == "Gain Muscle", () {
                        setState(() => selectedGoal = "Gain Muscle");
                      }),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment(-0.5, 0),
                      child: buildPillButton("Stay Fit", selectedGoal == "Stay Fit", () {
                        setState(() => selectedGoal = "Stay Fit");
                      }),
                    ),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.all(0),
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepage(
                            level: selectedLevel,
                            goal: selectedGoal,
                          ),
                        ),
                      );
                    },
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 8, 0, 255),
                            Color.fromARGB(255, 0, 217, 255),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPillButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.white70 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
