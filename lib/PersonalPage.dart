import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  String? gender;
  String? goal;
  String? pushupBaseline;
  String? activityLevel;
  double? height;
  double? weight;
  String unit = 'metric';
  String? frequency;
  String? bmiRecommendedLevel;

  String get mappedGoal {
    switch (goal) {
      case 'lose-fat':
        return 'Lose Weight';
      case 'build-muscle':
        return 'Gain Muscle';
      case 'cardio-health':
      case 'general-wellness':
        return 'Stay Fit';
      default:
        return 'Lose Weight';
    }
  }

  String get mappedLevel {
    if (bmiRecommendedLevel != null) return bmiRecommendedLevel!;
    switch (pushupBaseline) {
      case '0-5':
        return 'Beginner';
      case '5-15':
        return 'Intermediate';
      case '15+':
        return 'Advance';
      default:
        return 'Beginner';
    }
  }
}

class Personalize extends StatefulWidget {
  const Personalize({super.key});

  @override
  State<Personalize> createState() => _PersonalizeState();
}

class _PersonalizeState extends State<Personalize> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final UserProfile _profile = UserProfile();

  void _nextPage() async {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('level', _profile.mappedLevel);
      await prefs.setString('goal', _profile.mappedGoal);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(
            level: _profile.mappedLevel,
goal: _profile.goal!,
          ),
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(
        7,
        (index) => Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: index < 6 ? 8 : 0),
            decoration: BoxDecoration(
              color: index <= _currentPage
                  ? const Color(0xFF2563EB)
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) => setState(() => _currentPage = page),
          children: [
            _buildGenderScreen(),
            _buildGoalsScreen(),
            _buildPhysicalAssessmentScreen(),
            _buildActivityLevelScreen(),
            _buildBiometricsScreen(),
            _buildScheduleScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderScreen() {
    final options = [
      {
        'value': 'male',
        'label': 'Male',
        'icon': Icons.male,
      },
      {
        'value': 'female',
        'label': 'Female',
        'icon': Icons.female,
      },
      {
        'value': 'prefer-not-to-say',
        'label': 'Prefer not to say',
        'icon': Icons.help_outline,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 32),
          const Text(
            'What is your gender?',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us personalize your fitness plan',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = _profile.gender == option['value'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _profile.gender = option['value'] as String;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF4A00E0),
                                Color(0xFF00C6FF),
                              ],
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option['label'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _buildRadioCircle(isSelected),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildNavigationButtons(_profile.gender != null),
        ],
      ),
    );
  }

  Widget _buildGoalsScreen() {
    final goals = [
      {
        'value': 'lose-fat',
        'label': 'Lose Body Fat',
        'description': 'Focus on fat loss and definition',
        'icon': Icons.local_fire_department,
      },
      {
        'value': 'build-muscle',
        'label': 'Build Strength & Muscle',
        'description': 'Tone up and gain strength',
        'icon': Icons.fitness_center,
      },
      {
        'value': 'cardio-health',
        'label': 'Improve Stamina & Cardio Health',
        'description': 'Enhance endurance and cardiovascular fitness',
        'icon': Icons.favorite,
      },
      {
        'value': 'general-wellness',
        'label': 'General Wellness & Keep Fit',
        'description': 'Maintain overall health and fitness',
        'icon': Icons.auto_awesome,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 32),
          const Text(
            'What is your main fitness goal?',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the goal that matters most to you',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final isSelected = _profile.goal == goal['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _profile.goal = goal['value'] as String;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF4A00E0),
                                Color(0xFF00C6FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.grey[900],
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              goal['icon'] as IconData,
                              color: Colors.white,
                              size: 30,
                            ),
                            _buildRadioCircle(isSelected),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          goal['label'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          goal['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildNavigationButtons(_profile.goal != null),
        ],
      ),
    );
  }

  Widget _buildPhysicalAssessmentScreen() {
    final ranges = [
      {
        'value': '0-5',
        'label': '0-5 Push-ups',
        'level': 'Absolute Beginner',
        'color': Colors.red[400],
      },
      {
        'value': '5-15',
        'label': '5-15 Push-ups',
        'level': 'Ready for Intermediate',
        'color': Colors.green[400],
      },
      {
        'value': '15+',
        'label': '15+ Push-ups',
        'level': 'Advanced',
        'color': Colors.blue[400],
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 32),
          const Text(
            'Physical Assessment',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To ensure your plan is safe, we need a baseline',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How many push-ups can you do with proper form in one set?',
                        style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Proper form: body straight, chest to ground, full extension.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: ranges.length,
              itemBuilder: (context, index) {
                final range = ranges[index];
                final isSelected = _profile.pushupBaseline == range['value'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _profile.pushupBaseline = range['value'] as String;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF4A00E0),
                                Color(0xFF00C6FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.grey[900],
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                range['label'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                range['level'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : range['color'] as Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRadioCircle(isSelected),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildNavigationButtons(_profile.pushupBaseline != null),
        ],
      ),
    );
  }

  Widget _buildActivityLevelScreen() {
    final levels = [
      {
        'value': 'sedentary',
        'label': 'Sedentary',
        'description': 'Office job, mostly sitting',
        'icon': Icons.event_seat,
      },
      {
        'value': 'lightly-active',
        'label': 'Lightly Active',
        'description': 'Some walking, light daily movement',
        'icon': Icons.directions_walk,
      },
      {
        'value': 'very-active',
        'label': 'Very Active',
        'description': 'Manual labor, active job',
        'icon': Icons.flash_on,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 32),
          const Text(
            'Lifestyle & Activity Level',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How active is your daily life outside of exercise?',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                final isSelected = _profile.activityLevel == level['value'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _profile.activityLevel = level['value'] as String;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF4A00E0),
                                Color(0xFF00C6FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.grey[900],
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          level['icon'] as IconData,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level['label'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                level['description'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRadioCircle(isSelected),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildNavigationButtons(_profile.activityLevel != null),
        ],
      ),
    );
  }
  double? _bmi;
String _bmiCategory = '';
Color _bmiColor = Colors.grey;
String _bmiAdvice = '';

String? _heightInput;
String? _recommendedLevel;

bool get _isLevelValid {
  if (_recommendedLevel == null) return true;
  return _profile.bmiRecommendedLevel == _recommendedLevel;
}

void _computeBMI() {
  if (_heightInput == null || _profile.weight == null) return;

  final input = _heightInput!.trim();
  final parts = input.split(RegExp(r"[^\d]+"));

  if (parts.isEmpty) return;

  int feet = int.tryParse(parts[0]) ?? 0;
  int inches = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

  if (feet == 0) return;

  double heightCm = (feet * 30.48) + (inches * 2.54);
  double weightKg = _profile.weight!;

  final h = heightCm / 100;
  final bmi = weightKg / (h * h);

  String cat;
  Color col;
  String advice;
  String? recommendedLevel;

  if (bmi < 18.5) {
    cat = 'Underweight';
    col = const Color(0xFFFF9800);
    advice = 'Focus on building strength. Beginner programs work best for you.';
    recommendedLevel = 'Beginner';
  } else if (bmi <= 24.9) {
    cat = 'Normal Weight';
    col = const Color(0xFF4CAF50);
    advice = 'Great shape! Any level is suitable based on your fitness goal.';
    recommendedLevel = null;
  } else if (bmi <= 29.9) {
    cat = 'Overweight';
    col = const Color(0xFFFFC107);
    advice = 'Cardio-focused workouts are recommended. Consider Intermediate.';
    recommendedLevel = 'Intermediate';
  } else {
    cat = 'Obese';
    col = const Color(0xFFF44336);
    advice = 'Low-impact Beginner workouts are safest.';
    recommendedLevel = 'Beginner';
  }

  setState(() {
    _bmi = bmi;
    _bmiCategory = cat;
    _bmiColor = col;
    _bmiAdvice = advice;
    _recommendedLevel = recommendedLevel;

    // SINGLE SOURCE OF TRUTH
    _profile.bmiRecommendedLevel ??= recommendedLevel;

    if (bmi < 18.5) {
      _profile.goal = 'build-muscle';
    } else if (bmi <= 24.9) {
      _profile.goal = _profile.goal ?? 'general-wellness';
    } else {
      _profile.goal = 'lose-fat';
    }
  });
}

Widget _buildBiometricsScreen() {
  final bool canProceed = _heightInput != null &&
      _profile.weight != null &&
      _bmi != null &&
      _isLevelValid;

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressIndicator(),
        const SizedBox(height: 24),
        const Text(
          'Your Biometrics & BMI',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text('Height (e.g. 5\'8)', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle("5'8 or 5 8"),
                  onChanged: (v) {
                    setState(() => _heightInput = v);
                    _computeBMI();
                  },
                ),

                const SizedBox(height: 20),

                const Text('Weight (kg)', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle('e.g. 70'),
                  onChanged: (v) {
                    setState(() => _profile.weight = double.tryParse(v));
                    _computeBMI();
                  },
                ),

                const SizedBox(height: 24),

                if (_bmi != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _bmiColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _bmiColor.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _bmiCategory,
                          style: TextStyle(
                            color: _bmiColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _bmiAdvice,
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 12),

                        if (_recommendedLevel != null &&
                            _profile.bmiRecommendedLevel != _recommendedLevel)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your selected level is not suitable for your BMI.",
                                  style: TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _profile.bmiRecommendedLevel =
                                          _recommendedLevel;
                                    });
                                  },
                                  child: const Text(
                                    "Use Recommended Level",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                _buildNavigationButtons(canProceed),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
    );
  }

  Widget _bmiLegendChip(String range, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            Text(range,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleScreen() {
    final frequencyOptions = [
      {
        'value': '1-2',
        'label': '1-2 days per week',
        'description': 'Perfect for beginners'
      },
      {
        'value': '3-4',
        'label': '3-4 days per week',
        'description': 'Recommended for most goals'
      },
      {
        'value': '5+',
        'label': '5+ days per week',
        'description': 'For advanced athletes'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 32),
          const Text(
            'Schedule & Commitment',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "How often will you train?",
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: frequencyOptions.map((option) {
                final isSelected = _profile.frequency == option['value'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _profile.frequency = option['value'] as String;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF4A00E0),
                                Color(0xFF00C6FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.grey[900],
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['label']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                option['description']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRadioCircle(isSelected),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildNavigationButtons(
            _profile.frequency != null,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioCircle(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[600]!,
          width: 2,
        ),
        color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSmallRadioCircle(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[600]!,
          width: 2,
        ),
        color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSelectionCard(
      {required Widget child, required bool isSelected}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2563EB).withOpacity(0.1)
            : Colors.grey[900],
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildNavigationButtons(bool canProceed, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _previousPage,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.grey[700]!),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Back', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: canProceed ? _nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey[800],
              ),
              child: Text(
                isLast ? 'Get Start' : 'Continue',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
