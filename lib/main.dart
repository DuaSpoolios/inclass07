import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context)=> MoodModel(),
      child: const MyApp(),
    ),
  );
}

class MoodModel with ChangeNotifier {
  String? _currentMoodAsset;
  Color _backgroundColor= Colors.white;
  final Map<String, int> _moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
    'Surprise': 0, 
  };

  String? get currentMoodAsset => _currentMoodAsset;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() {
    _currentMoodAsset= 'assets/happy.jpg';
    _backgroundColor= Colors.yellow.shade200;
    _moodCounts['Happy'] = _moodCounts['Happy']! + 1;
    notifyListeners();
  }

  void setSad() {
    _currentMoodAsset = 'assets/sad.jpg';
    _backgroundColor = Colors.blue.shade200;
    _moodCounts['Sad'] = _moodCounts['Sad']! + 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMoodAsset = 'assets/excited.jpg';
    _backgroundColor = Colors.orange.shade200;
    _moodCounts['Excited']=_moodCounts['Excited']! + 1;
    notifyListeners();
  }
  void setRandomMood() {
    final random = Random().nextInt(4); 
    switch (random) {
      case 0:
        setHappy();
        break;
      case 1:
        setSad();
        break;
      case 2:
        setExcited();
        break;
      case 3:
        _currentMoodAsset = 'assets/surprised.jpg'; 
        _backgroundColor= Colors.purple.shade200;
        _moodCounts['Surprise']= _moodCounts['Surprise']! + 1;
        notifyListeners();
        break;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bgColor = context.watch<MoodModel>().backgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text('Mood Toggle Challenge')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How are you feeling?', style: textTheme.headlineSmall),
            const SizedBox(height: 30),
            const MoodDisplay(),
            const SizedBox(height: 40),
            const MoodButtons(),
            const SizedBox(height: 40),
            const MoodCounter(),
          ],
        ),
      ),
    );
  }
}

class MoodDisplay extends StatelessWidget {
  const MoodDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final asset= context.watch<MoodModel>().currentMoodAsset;

    if (asset== null) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Current mood image',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          asset,
          width: 160,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('Image not found'),
          ),
        ),
      ),
    );
  }
}
class MoodButtons extends StatelessWidget {
  const MoodButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MoodModel>();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(onPressed: model.setHappy, child: const Text('Happy')),
        ElevatedButton(onPressed: model.setSad, child: const Text('Sad')),
        ElevatedButton(onPressed: model.setExcited, child: const Text('Excited')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          onPressed: model.setRandomMood,
          child: const Text('Random'),
        ),
      ],
    );
  }
}
class MoodCounter extends StatelessWidget {
  const MoodCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final counts = context.watch<MoodModel>().moodCounts;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text('Mood Counter', style: textTheme.titleMedium),
        const SizedBox(height: 10),
        Text('Happy:   ${counts['Happy']}'),
        Text('Sad:     ${counts['Sad']}'),
        Text('Excited: ${counts['Excited']}'),
        Text('Surprise: ${counts['Surprise']}'),
      ],
    );
  }
}
