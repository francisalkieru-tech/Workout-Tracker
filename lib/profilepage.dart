import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'frontpage.dart';
import 'homepage.dart';

class ProfilePage extends StatefulWidget {
  final String level;
  final String goal;

  const ProfilePage({
    super.key,
    required this.level,
    required this.goal,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = " ";
  String _email = " ";

  double _weight = 0;
  double _height = 0;
  double _bmi = 0;

  String _bmiCategory = "";
  Color _bmiColor = Colors.grey;

  int _totalWorkouts = 0;
  int _thisMonthWorkouts = 0;
  int _currentStreak = 0;

  int _selectedTab = 1;
  bool _isEditing = false;

  String _programRecommendation = "";
  String _recommendedLevel = "";

  Map<int, bool> _monthlyActivity = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadWorkoutCalendar();
    _loadMonthlyWorkouts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkoutCalendar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .get();

    Map<int, bool> activity = {};

    for (var doc in snapshot.docs) {
      Timestamp ts = doc['date'];
      DateTime date = ts.toDate();

      if (date.month == DateTime.now().month &&
          date.year == DateTime.now().year) {
        activity[date.day] = true;
      }
    }

    final now = DateTime.now();
    int streak = 0;
    DateTime check = DateTime(now.year, now.month, now.day);
    final allDates = snapshot.docs.map((doc) {
      Timestamp ts = doc['date'];
      DateTime d = ts.toDate();
      return DateTime(d.year, d.month, d.day);
    }).toSet();

    while (allDates.contains(check)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }

    setState(() {
      _monthlyActivity = activity;
      _currentStreak = streak;
    });
  }

  Future<void> _loadMonthlyWorkouts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .get();

    int count = 0;
    final now = DateTime.now();

    for (var doc in snapshot.docs) {
      Timestamp ts = doc['date'];
      DateTime date = ts.toDate();

      if (date.month == now.month && date.year == now.year) {
        count++;
      }
    }

    setState(() {
      _thisMonthWorkouts = count;
    });

    final recommendation = _getProgramUpgradeRecommendation();
    setState(() {
      _programRecommendation = recommendation;
    });
  }

  String _getProgramUpgradeRecommendation() {
    String currentLevel = widget.level.toLowerCase();

    if (currentLevel == "beginner") {
      if (_thisMonthWorkouts >= 14) {
        _recommendedLevel = "Intermediate";

        return "Great consistency! You're now ready to move from Beginner to Intermediate training with more volume and intensity.";
      } else {
        _recommendedLevel = "Beginner";

        return "Keep building consistency first. Complete more workouts this month to unlock the Intermediate program.";
      }
    }

    else if (currentLevel == "intermediate") {
      if (_thisMonthWorkouts >= 22) {
        _recommendedLevel = "Advanced";

        return "Excellent dedication! Your body is ready for Advanced progressive overload and higher intensity workouts.";
      } else {
        _recommendedLevel = "Intermediate";

        return "You're progressing well. Stay consistent to unlock the Advanced program.";
      }
    }

    else {
      _recommendedLevel = "Advanced";
      return "You're already on the highest training level. Continue pushing your limits and maintaining consistency.";
    }
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data();

    final name = data?['username'] ?? 'Athlete';
    final email = data?['email'] ?? 'user@gmail.com';
    final weight = (data?['weight'] ?? 70).toDouble();
    final height = (data?['height'] ?? 170).toDouble();
    final total = data?['total_workouts'] ?? 0;

    double bmi = weight / ((height / 100) * (height / 100));

    String cat;
    Color col;

    if (bmi < 18.5) {
      cat = 'Underweight';
      col = Colors.orange;
    } else if (bmi <= 24.9) {
      cat = 'Normal';
      col = Colors.green;
    } else if (bmi <= 29.9) {
      cat = 'Overweight';
      col = Colors.amber;
    } else {
      cat = 'Obese';
      col = Colors.red;
    }

    int feet = (height / 2.54 / 12).floor();
    int inches = ((height / 2.54) % 12).round();

    setState(() {
      _username = name;
      _email = email;
      _weight = weight;
      _height = height;
      _bmi = bmi;
      _bmiCategory = cat;
      _bmiColor = col;
      _totalWorkouts = total;

      _nameController.text = name;
      _emailController.text = email;
      _weightController.text = weight.toString();
      _heightController.text = "$feet ft $inches in";
    });
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    final weight = double.tryParse(_weightController.text) ?? _weight;
    final height = _height;

    double bmi = weight / ((height / 100) * (height / 100));

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': name,
      'email': email,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    setState(() {
      _username = name;
      _email = email;
      _weight = weight;
      _height = height;
      _bmi = bmi;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated"),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _goalLabel(String goal) {
    switch (goal) {
      case 'lose-fat':
        return 'Lose Body Fat';

      case 'build-muscle':
        return 'Build Muscle';

      case 'cardio-health':
        return 'Cardio Health';

      case 'general-wellness':
        return 'General Wellness';

      default:
        return goal;
    }
  }

  IconData _goalIcon(String goal) {
    switch (goal) {
      case 'lose-fat':
        return Icons.local_fire_department;

      case 'build-muscle':
        return Icons.fitness_center;

      case 'cardio-health':
        return Icons.favorite;

      default:
        return Icons.auto_awesome;
    }
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00E5FF),
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.07),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();

    final daysInMonth = DateUtils.getDaysInMonth(
      now.year,
      now.month,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Color(0xFF00E5FF),
              ),
              SizedBox(width: 8),
              Text(
                "Workout Calendar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              int day = index + 1;

              bool hasWorkout = _monthlyActivity[day] == true;

              bool isToday = day == now.day;

              return Container(
                decoration: BoxDecoration(
                  color: isToday
                      ? const Color(0xFF2563EB)
                      : hasWorkout
                          ? const Color(0xFF00E5FF)
                          : Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color:
                          hasWorkout || isToday ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalInches = _height / 2.54;

    int feet = (totalInches / 12).floor();

    int inches = (totalInches % 12).round();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) {
          setState(() {
            _selectedTab = i;
          });

          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(
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
            color: Colors.black.withOpacity(0.65),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isEditing ? Icons.close : Icons.edit,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing;
                              });
                            },
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white70,
                              ),
                              onPressed: () async {
                                await FirebaseAuth.instance
                                    .signOut();
                                if (!mounted) return;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const FrontPage()),
                                  (route) => false,
                                );
                              }),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              const Color(0xFF2563EB).withOpacity(0.3),
                          child: Text(
                            _username.isNotEmpty
                                ? _username[0].toUpperCase()
                                : "A",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _email,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4A00E0),
                                      Color(0xFF00C6FF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _goalIcon(widget.goal),
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${widget.level} • ${_goalLabel(widget.goal)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (_isEditing)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _editField(
                            "Name",
                            _nameController,
                          ),
                          _editField(
                            "Email",
                            _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _editField(
                            "Weight (kg)",
                            _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          _editField(
                            "Height (5 ft 8 in)",
                            _heightController,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_isEditing) const SizedBox(height: 16),

                  Row(
                    children: [
                      _statCard(
                        "$_totalWorkouts",
                        "Total\nWorkouts",
                        Icons.fitness_center,
                        const Color(0xFF00E5FF),
                      ),
                      const SizedBox(width: 10),
                      _statCard(
                        "$_currentStreak",
                        "Current\nStreak",
                        Icons.local_fire_department,
                        Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      _statCard(
                        "$_thisMonthWorkouts",
                        "This\nMonth",
                        Icons.calendar_month,
                        Colors.greenAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "BMI Overview",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              _bmi.toStringAsFixed(1),
                              style: TextStyle(
                                color: _bmiColor,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _bmiColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _bmiCategory,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildCalendar(),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personal Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoRow(
                          Icons.email_outlined,
                          "Email",
                          _email,
                        ),
                        _infoRow(
                          Icons.monitor_weight_outlined,
                          "Weight",
                          "${_weight.toStringAsFixed(1)} kg",
                        ),
                        _infoRow(
                          Icons.height,
                          "Height",
                          "$feet ft $inches in",
                        ),
                        _infoRow(
                          Icons.bar_chart,
                          "Fitness Level",
                          widget.level,
                        ),
                        _infoRow(
                          _goalIcon(widget.goal),
                          "Goal",
                          _goalLabel(widget.goal),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A00E0),
                          Color(0xFF00C6FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.auto_graph,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "3-Month Upgrade Plan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _programRecommendation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (widget.level == _recommendedLevel) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("You're already on this level."),
                                  ),
                                );
                                return;
                              }

                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              String newLevel = _recommendedLevel;

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .set({
                                'level': newLevel,
                              }, SetOptions(merge: true));

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    "Program upgraded to $newLevel!",
                                  ),
                                ),
                              );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Homepage(
                                    level: newLevel,
                                    goal: widget.goal,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(
                              Icons.upgrade,
                            ),
                            label: Text(
                              widget.level == _recommendedLevel
                                  ? "Current Level: $_recommendedLevel"
                                  : "Upgrade to $_recommendedLevel",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
