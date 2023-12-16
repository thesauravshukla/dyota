import 'package:dyota/components/generic_appbar.dart';
import 'package:flutter/material.dart';
// import 'package:dyota/components/generic_appbar.dart'; // Uncomment if you have a custom app bar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filter Screen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _currentRangeValues = const RangeValues(20, 80);
  Color? _selectedColor;
  final List<String> _selectedSizes = [];
  final List<String> _selectedCategories = [];

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _categories = [
    'All',
    'Women',
    'Men',
    'Kids',
    'Accessories'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(
          title: "Filters"), // Replace with genericAppbar if you have one
      body: ListView(
        children: <Widget>[
          _buildSectionTitle('Price Range'),
          _buildPriceRangeFilter(),
          _buildSectionTitle('Colors'),
          _buildColorFilter(),
          _buildSectionTitle('Sizes'),
          _buildSizeFilter(),
          _buildSectionTitle('Category'),
          _buildCategoryFilter(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2.0,
              ),
              child: RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 200,
                activeColor: Colors.black,
                inactiveColor: Colors.black.withOpacity(0.3),
                divisions: 200,
                labels: RangeLabels(
                  '\$${_currentRangeValues.start.round()}',
                  '\$${_currentRangeValues.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${_currentRangeValues.start.round()}'),
                Text('\$${_currentRangeValues.end.round()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorFilter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _colors.map((Color color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == color
                        ? Colors.red
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSizeFilter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
        child: Wrap(
          spacing: 8.0,
          children: _sizes.map((size) {
            bool isSelected = _selectedSizes.contains(size);
            return ChoiceChip(
              label: Text(size,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black)),
              selected: isSelected,
              selectedColor: Colors.black,
              backgroundColor: Colors.white,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedSizes.add(size);
                  } else {
                    _selectedSizes.remove(size);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
        child: Wrap(
          spacing: 8.0,
          children: _categories.map((category) {
            bool isSelected = _selectedCategories.contains(category);
            return ChoiceChip(
              label: Text(category,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black)),
              selected: isSelected,
              selectedColor: Colors.black,
              backgroundColor: Colors.white,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  // Reset all filters
                  _currentRangeValues = const RangeValues(78, 143);
                  _selectedColor = null;
                  _selectedSizes.clear();
                  _selectedCategories.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child:
                  const Text('Discard', style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Implement apply logic
              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
