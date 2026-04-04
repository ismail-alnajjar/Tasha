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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.withOpacity(isDark ? 0.2 : 0.7),
              isDark ? theme.scaffoldBackgroundColor : Colors.white
            ],
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
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "How many days?",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
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
                                ? (isDark ? Colors.white : Colors.black)
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
                      // Retrieve the list of categories (now List<String>)
                      final categories =
                          ModalRoute.of(context)!.settings.arguments
                              as List<String>;

                      Navigator.pushNamed(
                        context,
                        '/trip_summary',
                        arguments: {
                          'categories': categories, // Passing the list
                          'duration': _selectedDuration,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.amber.withOpacity(0.8) : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.black : Colors.white,
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
