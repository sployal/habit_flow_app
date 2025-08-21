import 'package:flutter/material.dart';

void main() {
  runApp(const HabitFlowApp());
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitFlow',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HabitTrackerHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Habit {
  final int id;
  final String name;
  final String icon;
  final List<Color> colors;
  int streak;
  int bestStreak;
  bool completedToday;
  final List<bool> weekData;
  final String category;
  final String time;
  int completedDays;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.colors,
    required this.streak,
    required this.bestStreak,
    required this.completedToday,
    required this.weekData,
    required this.category,
    required this.time,
    required this.completedDays,
  });
}

class HabitTrackerHome extends StatefulWidget {
  const HabitTrackerHome({super.key});

  @override
  State<HabitTrackerHome> createState() => _HabitTrackerHomeState();
}

class _HabitTrackerHomeState extends State<HabitTrackerHome> {
  int _currentIndex = 0;
  
  List<Habit> habits = [
    Habit(
      id: 1,
      name: 'Morning Meditation',
      icon: '🧘‍♀️',
      colors: [Colors.purple, Colors.pink],
      streak: 12,
      bestStreak: 25,
      completedToday: true,
      weekData: [true, true, false, true, true, true, true],
      category: 'Wellness',
      time: '07:00',
      completedDays: 45,
    ),
    Habit(
      id: 2,
      name: 'Read 30 minutes',
      icon: '📚',
      colors: [Colors.blue, Colors.cyan],
      streak: 8,
      bestStreak: 15,
      completedToday: false,
      weekData: [true, true, true, false, true, true, false],
      category: 'Learning',
      time: '20:00',
      completedDays: 32,
    ),
    Habit(
      id: 3,
      name: 'Workout',
      icon: '💪',
      colors: [Colors.orange, Colors.red],
      streak: 5,
      bestStreak: 18,
      completedToday: true,
      weekData: [false, true, true, true, false, true, true],
      category: 'Fitness',
      time: '06:00',
      completedDays: 28,
    ),
    Habit(
      id: 4,
      name: 'Drink 8 glasses water',
      icon: '💧',
      colors: [Colors.cyan, Colors.blue],
      streak: 15,
      bestStreak: 30,
      completedToday: false,
      weekData: [true, true, true, true, false, true, false],
      category: 'Health',
      time: 'All day',
      completedDays: 67,
    ),
  ];

  void _toggleHabit(int id) {
    setState(() {
      final habitIndex = habits.indexWhere((habit) => habit.id == id);
      if (habitIndex != -1) {
        final habit = habits[habitIndex];
        habit.completedToday = !habit.completedToday;
        
        if (habit.completedToday) {
          habit.streak += 1;
          habit.completedDays += 1;
          if (habit.streak > habit.bestStreak) {
            habit.bestStreak = habit.streak;
          }
        } else {
          habit.streak = (habit.streak - 1).clamp(0, habit.streak);
        }
      }
    });
  }

  void _addHabit(String name, String icon, String category, String time) {
    final colors = [
      [Colors.green, Colors.greenAccent],
      [Colors.yellow, Colors.orange],
      [Colors.indigo, Colors.purple],
      [Colors.pink, Colors.pinkAccent],
      [Colors.teal, Colors.cyan],
    ];

    setState(() {
      habits.add(Habit(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        icon: icon,
        colors: colors[habits.length % colors.length],
        streak: 0,
        bestStreak: 0,
        completedToday: false,
        weekData: [false, false, false, false, false, false, false],
        category: category,
        time: time,
        completedDays: 0,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF7C3AED),
              Color(0xFF0F0F23),
            ],
          ),
        ),
        child: _getPage(_currentIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.black.withValues(alpha: 0.8),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.purple[300],
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              label: 'Awards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          habits: habits,
          onToggleHabit: _toggleHabit,
          onAddHabit: _addHabit,
        );
      case 1:
        return StatsScreen(habits: habits);
      case 2:
        return AchievementsScreen(habits: habits);
      case 3:
        return const SettingsScreen();
      default:
        return HomeScreen(
          habits: habits,
          onToggleHabit: _toggleHabit,
          onAddHabit: _addHabit,
        );
    }
  }
}

class HomeScreen extends StatelessWidget {
  final List<Habit> habits;
  final Function(int) onToggleHabit;
  final Function(String, String, String, String) onAddHabit;

  const HomeScreen({
    super.key,
    required this.habits,
    required this.onToggleHabit,
    required this.onAddHabit,
  });

  @override
  Widget build(BuildContext context) {
    final completedToday = habits.where((h) => h.completedToday).length;
    final totalHabits = habits.length;
    final completionRate = totalHabits > 0 ? (completedToday / totalHabits * 100).round() : 0;

    return SafeArea(
      child: Column(
        children: [
          // Header with Progress Ring
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.pink],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning! 👋',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Let\'s build great habits today',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Simplified Progress Ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: completionRate / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$completionRate%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Complete',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '$completedToday of $totalHabits completed',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Habits List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Habits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: habits.length + 1,
                      itemBuilder: (context, index) {
                        if (index == habits.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton.icon(
                              onPressed: () => _showAddHabitModal(context),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Add New Habit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          );
                        }
                        
                        final habit = habits[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: habit.completedToday 
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: habit.completedToday 
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: habit.colors),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  habit.icon,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          size: 12,
                                          color: Colors.orange[400],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${habit.streak}',
                                          style: TextStyle(
                                            color: Colors.orange[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.access_time,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          habit.time,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => onToggleHabit(habit.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: habit.completedToday 
                                        ? Colors.green
                                        : Colors.grey[700],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    habit.completedToday 
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  void _showAddHabitModal(BuildContext context) {
    String habitName = '';
    String habitIcon = '✨';
    String habitCategory = 'General';
    TimeOfDay habitTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF1F1F3A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Habit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                onChanged: (value) => habitName = value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintText: 'e.g., Exercise for 30 minutes',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => habitIcon = value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Icon',
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: '🏃‍♂️',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: habitCategory,
                      onChanged: (value) => habitCategory = value!,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: Colors.grey[800],
                      items: ['General', 'Health', 'Fitness', 'Learning', 'Wellness', 'Productivity']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (habitName.isNotEmpty) {
                          onAddHabit(
                            habitName,
                            habitIcon,
                            habitCategory,
                            '${habitTime.hour.toString().padLeft(2, '0')}:${habitTime.minute.toString().padLeft(2, '0')}',
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Habit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  final List<Habit> habits;

  const StatsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final totalCompleted = habits.fold(0, (sum, habit) => sum + habit.completedDays);
    final bestStreak = habits.isNotEmpty 
        ? habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b) 
        : 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics 📊',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            // Overview Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$totalCompleted',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Total Completed',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$bestStreak',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Best Streak',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Habit Performance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Habit Performance List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: habit.colors.first.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                habit.icon,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    habit.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    habit.category,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${habit.completedDays}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'days',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'This week',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Row(
                              children: habit.weekData.map((completed) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 2),
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: completed ? Colors.green : Colors.grey[600],
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current: ${habit.streak}',
                              style: TextStyle(
                                color: Colors.orange[400],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Best: ${habit.bestStreak}',
                              style: TextStyle(
                                color: Colors.yellow[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  final List<Habit> habits;

  const AchievementsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final totalCompleted = habits.fold(0, (sum, habit) => sum + habit.completedDays);
    final hasWeekStreak = habits.any((h) => h.streak >= 7);
    final hasMonthStreak = habits.any((h) => h.streak >= 30);

    final achievements = [
      {
        'title': 'First Step',
        'desc': 'Complete your first habit',
        'icon': '🎯',
        'unlocked': habits.isNotEmpty,
      },
      {
        'title': 'Week Warrior',
        'desc': 'Maintain a 7-day streak',
        'icon': '⚡',
        'unlocked': hasWeekStreak,
      },
      {
        'title': 'Habit Master',
        'desc': 'Complete 50 total habits',
        'icon': '👑',
        'unlocked': totalCompleted >= 50,
      },
      {
        'title': 'Perfect Day',
        'desc': 'Complete all habits in one day',
        'icon': '✨',
        'unlocked': false,
      },
      {
        'title': 'Streak Legend',
        'desc': 'Achieve a 30-day streak',
        'icon': '🔥',
        'unlocked': hasMonthStreak,
      },
      {
        'title': 'Consistency King',
        'desc': 'Have 5 active habits',
        'icon': '👸',
        'unlocked': habits.length >= 5,
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Achievements 🏆',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  final isUnlocked = achievement['unlocked'] as bool;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? Colors.yellow.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isUnlocked 
                            ? Colors.yellow.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUnlocked 
                                ? Colors.yellow.withValues(alpha: 0.2)
                                : Colors.grey[700],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            achievement['icon'] as String,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                achievement['title'] as String,
                                style: TextStyle(
                                  color: isUnlocked ? Colors.yellow[400] : Colors.grey[400],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                achievement['desc'] as String,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isUnlocked)
                          Icon(
                            Icons.emoji_events,
                            color: Colors.yellow[400],
                            size: 24,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings ⚙️',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  _buildSettingsCard(
                    'Notifications',
                    'Get reminded about your habits',
                    [
                      _buildSettingsItem(
                        'Daily Reminders',
                        null,
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildSettingsCard(
                    'Theme',
                    'Choose your preferred theme',
                    [
                      _buildSettingsItem(
                        'Dark Mode',
                        null,
                        leading: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildSettingsCard(
                    'Data',
                    null,
                    [
                      _buildSettingsItem('Export Data', null),
                      _buildSettingsItem('Backup to Cloud', null),
                      _buildSettingsItem(
                        'Reset All Data', 
                        null,
                        textColor: Colors.red[400],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildSettingsCard(
                    'About',
                    null,
                    [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HabitFlow v1.0.0',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Made with ❤️ for building better habits',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title, String? subtitle, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title, 
    String? subtitle, {
    Widget? leading,
    Widget? trailing,
    Color? textColor,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}