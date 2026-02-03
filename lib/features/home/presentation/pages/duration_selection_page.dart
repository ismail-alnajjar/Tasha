import 'package:flutter/material.dart';

class DurationSelectionPage extends StatefulWidget {
  const DurationSelectionPage({super.key});

  @override
  State<DurationSelectionPage> createState() => _DurationSelectionPageState();
}

class _DurationSelectionPageState extends State<DurationSelectionPage> {
  int _selectedDuration = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.withOpacity(0.7), Colors.white],
            stops: const [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Back Button
                    const SizedBox(height: 30),
                    // Custom Back Button
                    const SizedBox(height: 30),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "How many days?",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 24, // Slightly reduced
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  perspective: 0.003,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDuration = index + 1;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 30,
                    builder: (context, index) {
                      final isSelected = (index + 1) == _selectedDuration;
                      return Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: isSelected ? 50 : 30,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade400,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final category =
                          ModalRoute.of(context)!.settings.arguments as String;
                      Navigator.pushNamed(
                        context,
                        '/trip_summary',
                        arguments: {
                          'category': category,
                          'duration': _selectedDuration,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
