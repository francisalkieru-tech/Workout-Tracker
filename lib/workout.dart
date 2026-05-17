final Map<String, dynamic> workoutLevels = {
  "Beginner": {
    "frequency": "3–4 days/week",
    "duration": "20–40 mins",
    "focus": "Bodyweight + light dumbbells",
    "about": "Best for beginners building consistency and form.",
  },
  "Intermediate": {
    "frequency": "4–5 days/week",
    "duration": "40–60 mins",
    "focus": "Progressive overload",
    "about": "For users with experience aiming for progression.",
  },
  "Advanced": {
    "frequency": "5–6 days/week",
    "duration": "60–90 mins",
    "focus": "High intensity training",
    "about": "For advanced users targeting performance & strength.",
  },
};

final Map<String, dynamic> workoutData = {
  "lose-fat": {
    "Beginner": {
      "Push Day": [
        {"exercise": "Knee Push-Ups", "value": "10 reps"},
        {"exercise": "Wall Push-Ups", "value": "12 reps"},
        {"exercise": "Shoulder Taps", "value": "20 reps"},
      ],
      "Pull Day": [
        {"exercise": "Superman Hold", "value": "20 sec"},
        {"exercise": "Resistance Band Rows", "value": "12 reps"},
        {"exercise": "Arm Circles", "value": "30 sec"},
      ],
      "Leg Day": [
        {"exercise": "Bodyweight Squats", "value": "15 reps"},
        {"exercise": "Lunges", "value": "10 reps/leg"},
        {"exercise": "Glute Bridges", "value": "15 reps"},
      ],
      "Core Day": [
        {"exercise": "Crunches", "value": "15 reps"},
        {"exercise": "Plank", "value": "20 sec"},
        {"exercise": "Mountain Climbers", "value": "20 sec"},
      ],
    },
    "Intermediate": {
      "Push Day": [
        {"exercise": "Push-Ups", "value": "15 reps"},
        {"exercise": "Dumbbell Shoulder Press", "value": "12 reps"},
        {"exercise": "Tricep Dips", "value": "12 reps"},
      ],
      "Pull Day": [
        {"exercise": "Bent Rows", "value": "12 reps"},
        {"exercise": "Resistance Band Rows", "value": "15 reps"},
        {"exercise": "Face Pulls", "value": "12 reps"},
      ],
      "Leg Day": [
        {"exercise": "Jump Squats", "value": "15 reps"},
        {"exercise": "Bulgarian Split Squats", "value": "10 reps/leg"},
        {"exercise": "Wall Sit", "value": "45 sec"},
      ],
      "Core Day": [
        {"exercise": "Russian Twists", "value": "20 reps"},
        {"exercise": "Bicycle Crunches", "value": "20 reps"},
        {"exercise": "Plank", "value": "45 sec"},
      ],
    },
    "Advanced": {
      "Push Day": [
        {"exercise": "Diamond Push-Ups", "value": "20 reps"},
        {"exercise": "Arnold Press", "value": "15 reps"},
        {"exercise": "Plyo Push-Ups", "value": "15 reps"},
      ],
      "Pull Day": [
        {"exercise": "Pull-Ups", "value": "12 reps"},
        {"exercise": "Renegade Rows", "value": "12 reps"},
        {"exercise": "Cable Rows", "value": "15 reps"},
      ],
      "Leg Day": [
        {"exercise": "Pistol Squats", "value": "10 reps"},
        {"exercise": "Deadlifts", "value": "12 reps"},
        {"exercise": "Jump Lunges", "value": "20 reps"},
      ],
      "Core Day": [
        {"exercise": "V-Ups", "value": "20 reps"},
        {"exercise": "Hanging Leg Raises", "value": "15 reps"},
        {"exercise": "Plank to Push-Up", "value": "15 reps"},
      ],
    },
  },
  "build-muscle": {
    "Beginner": {
      "Push Day": [
        {"exercise": "Knee Push-Ups", "value": "10 reps"},
        {"exercise": "Shoulder Press", "value": "12 reps"},
        {"exercise": "Chair Dips", "value": "10 reps"},
      ],
      "Pull Day": [
        {"exercise": "Resistance Band Rows", "value": "12 reps"},
        {"exercise": "Bicep Curls", "value": "12 reps"},
        {"exercise": "Superman Hold", "value": "20 sec"},
      ],
      "Leg Day": [
        {"exercise": "Squats", "value": "15 reps"},
        {"exercise": "Lunges", "value": "10 reps"},
        {"exercise": "Calf Raises", "value": "20 reps"},
      ],
      "Core Day": [
        {"exercise": "Crunches", "value": "15 reps"},
        {"exercise": "Plank", "value": "20 sec"},
        {"exercise": "Bird Dogs", "value": "12 reps"},
      ],
    },
    "Intermediate": {
      "Push Day": [
        {"exercise": "Bench Press", "value": "10 reps"},
        {"exercise": "Shoulder Press", "value": "12 reps"},
        {"exercise": "Tricep Dips", "value": "12 reps"},
      ],
      "Pull Day": [
        {"exercise": "Pull-Ups", "value": "8 reps"},
        {"exercise": "Lat Pulldowns", "value": "12 reps"},
        {"exercise": "Bent Rows", "value": "12 reps"},
      ],
      "Leg Day": [
        {"exercise": "Goblet Squats", "value": "12 reps"},
        {"exercise": "Hip Thrusts", "value": "15 reps"},
        {"exercise": "Deadlifts", "value": "10 reps"},
      ],
      "Core Day": [
        {"exercise": "Weighted Russian Twists", "value": "20 reps"},
        {"exercise": "Hanging Knee Raises", "value": "12 reps"},
        {"exercise": "Side Plank", "value": "30 sec"},
      ],
    },
    "Advanced": {
      "Push Day": [
        {"exercise": "Incline Bench Press", "value": "10 reps"},
        {"exercise": "Military Press", "value": "10 reps"},
        {"exercise": "Weighted Dips", "value": "10 reps"},
      ],
      "Pull Day": [
        {"exercise": "Weighted Pull-Ups", "value": "10 reps"},
        {"exercise": "Barbell Rows", "value": "10 reps"},
        {"exercise": "Cable Flys", "value": "12 reps"},
      ],
      "Leg Day": [
        {"exercise": "Front Squats", "value": "8 reps"},
        {"exercise": "Romanian Deadlifts", "value": "10 reps"},
        {"exercise": "Walking Lunges", "value": "20 reps"},
      ],
      "Core Day": [
        {"exercise": "Dragon Flags", "value": "10 reps"},
        {"exercise": "Ab Wheel Rollouts", "value": "15 reps"},
        {"exercise": "Weighted Plank", "value": "1 min"},
      ],
    },
  },
  "cardio-health": {
    "Beginner": {
      "Push Day": [
        {"exercise": "Shadow Boxing", "value": "1 min"},
        {"exercise": "Wall Push-Ups", "value": "12 reps"},
        {"exercise": "Arm Circles", "value": "30 sec"},
      ],
      "Pull Day": [
        {"exercise": "Light Resistance Band Rows", "value": "12 reps"},
        {"exercise": "Superman Hold", "value": "20 sec"},
        {"exercise": "Jump Rope (Light)", "value": "1 min"},
      ],
      "Leg Day": [
        {"exercise": "Bodyweight Squats", "value": "15 reps"},
        {"exercise": "Step-Ups", "value": "12 reps"},
        {"exercise": "Calf Raises", "value": "20 reps"},
      ],
      "Core Day": [
        {"exercise": "March in Place", "value": "1 min"},
        {"exercise": "Toe Taps", "value": "20 reps"},
        {"exercise": "Plank", "value": "20 sec"},
      ],
    },
    "Intermediate": {
      "Push Day": [
        {"exercise": "Battle Rope Waves", "value": "30 sec"},
        {"exercise": "Push-Ups", "value": "15 reps"},
        {"exercise": "Dumbbell Punches", "value": "30 sec"},
      ],
      "Pull Day": [
        {"exercise": "Jump Rope", "value": "3 mins"},
        {"exercise": "Bent Over Rows", "value": "12 reps"},
        {"exercise": "Resistance Band Pulls", "value": "15 reps"},
      ],
      "Leg Day": [
        {"exercise": "Jump Lunges", "value": "12 reps"},
        {"exercise": "Box Step-Ups", "value": "15 reps"},
        {"exercise": "Wall Sit", "value": "45 sec"},
      ],
      "Core Day": [
        {"exercise": "Bicycle Crunches", "value": "20 reps"},
        {"exercise": "Plank Jacks", "value": "20 reps"},
        {"exercise": "Mountain Climbers", "value": "30 sec"},
      ],
    },
    "Advanced": {
      "Push Day": [
        {"exercise": "Plyo Push-Ups", "value": "15 reps"},
        {"exercise": "Battle Rope Slams", "value": "45 sec"},
        {"exercise": "Arnold Press", "value": "12 reps"},
      ],
      "Pull Day": [
        {"exercise": "Pull-Ups", "value": "12 reps"},
        {"exercise": "Rowing Machine", "value": "10 mins"},
        {"exercise": "Cable Rows", "value": "15 reps"},
      ],
      "Leg Day": [
        {"exercise": "Box Jumps", "value": "15 reps"},
        {"exercise": "Jump Squats", "value": "20 reps"},
        {"exercise": "Sled Push", "value": "30 sec"},
      ],
      "Core Day": [
        {"exercise": "V-Ups", "value": "20 reps"},
        {"exercise": "Hanging Leg Raises", "value": "15 reps"},
        {"exercise": "Plank to Push-Up", "value": "15 reps"},
      ],
    },
  },
  "general-wellness": {
    "Beginner": {
      "Push Day": [
        {"exercise": "Wall Push-Ups", "value": "12 reps"},
        {"exercise": "Arm Circles", "value": "30 sec"},
        {"exercise": "Shoulder Mobility Stretch", "value": "1 min"},
      ],
      "Pull Day": [
        {"exercise": "Band Pull Aparts", "value": "15 reps"},
        {"exercise": "Light Resistance Rows", "value": "12 reps"},
        {"exercise": "Superman Hold", "value": "20 sec"},
      ],
      "Leg Day": [
        {"exercise": "Bodyweight Squats", "value": "15 reps"},
        {"exercise": "Calf Raises", "value": "20 reps"},
        {"exercise": "Hip Openers Stretch", "value": "1 min"},
      ],
      "Core Day": [
        {"exercise": "Bird Dogs", "value": "12 reps"},
        {"exercise": "Heel Touches", "value": "15 reps"},
        {"exercise": "Plank", "value": "20 sec"},
      ],
    },
    "Intermediate": {
      "Push Day": [
        {"exercise": "Push-Ups", "value": "15 reps"},
        {"exercise": "Dumbbell Shoulder Press", "value": "12 reps"},
        {"exercise": "Arm Circles", "value": "45 sec"},
      ],
      "Pull Day": [
        {"exercise": "Dumbbell Rows", "value": "12 reps"},
        {"exercise": "Resistance Band Pulls", "value": "15 reps"},
        {"exercise": "Face Pulls", "value": "12 reps"},
      ],
      "Leg Day": [
        {"exercise": "Goblet Squats", "value": "12 reps"},
        {"exercise": "Walking Lunges", "value": "15 reps"},
        {"exercise": "Glute Bridges", "value": "15 reps"},
      ],
      "Core Day": [
        {"exercise": "Russian Twists", "value": "20 reps"},
        {"exercise": "Leg Raises", "value": "12 reps"},
        {"exercise": "Plank", "value": "45 sec"},
      ],
    },
    "Advanced": {
      "Push Day": [
        {"exercise": "Incline Bench Press", "value": "10 reps"},
        {"exercise": "Arnold Press", "value": "12 reps"},
        {"exercise": "Weighted Push-Ups", "value": "15 reps"},
      ],
      "Pull Day": [
        {"exercise": "Pull-Ups", "value": "12 reps"},
        {"exercise": "Barbell Rows", "value": "10 reps"},
        {"exercise": "Cable Face Pulls", "value": "15 reps"},
      ],
      "Leg Day": [
        {"exercise": "Deadlifts", "value": "10 reps"},
        {"exercise": "Bulgarian Split Squats", "value": "12 reps"},
        {"exercise": "Box Jumps", "value": "15 reps"},
      ],
      "Core Day": [
        {"exercise": "Hanging Leg Raises", "value": "15 reps"},
        {"exercise": "Weighted Russian Twists", "value": "30 reps"},
        {"exercise": "Plank to Push-Up", "value": "15 reps"},
      ],
    },
  },
};
