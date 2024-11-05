import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:machine_basil/controller/ValueNotifier.dart';

class RefillCard extends StatefulWidget {
  final String name;
  final String url;

  const RefillCard({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  _RefillCardState createState() => _RefillCardState();
}

class _RefillCardState extends State<RefillCard> {
  int quantity = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuantity();
  }

  // Load quantity from local storage and update notifier
  Future<void> _loadQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      quantity = prefs.getInt(widget.name) ?? 0;
    });
    // Update the global notifier as well
    quantityNotifier.value = {...quantityNotifier.value, widget.name: quantity};
  }

  // Save quantity to local storage and update notifier
  Future<void> _saveQuantity(int additionalQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    int updatedQuantity = quantity + additionalQuantity;
    await prefs.setInt(widget.name, updatedQuantity);

    setState(() {
      quantity = updatedQuantity;
    });

    // Update the global notifier
    quantityNotifier.value = {...quantityNotifier.value, widget.name: quantity};
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.02),

      child: Row(
        children: [
          // Left side image container
          Container(
            height: screenHeight * 0.2,
            width: screenWidth * 0.12,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(60),
              image: DecorationImage(
                image: AssetImage(widget.url),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          // Right side content container
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Drink name
                Text(
                  widget.name,
                  style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Display current quantity
                Text(
                  '$quantity ml',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Label with red asterisk
                const Text(
                  'Refill Volume *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Input field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2B2B),
                    border: Border.all(color: const Color(0xFFE9E9E9), width: 0.20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66BCBCBC), // Lower opacity for a lighter shadow
                        offset: Offset(0, 5), // Reduced offset for less spread
                        blurRadius: 15, // Reduced blur radius for a tighter shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter refill volume',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 10),
                // Refill button
                ElevatedButton(
                  onPressed: () {
                    final enteredQuantity = int.tryParse(_controller.text) ?? 0;
                    if (enteredQuantity > 0) {
                      _saveQuantity(enteredQuantity);
                      _controller.clear();  // Clear the text field
                      FocusScope.of(context).unfocus();  // Dismiss the keyboard
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Refill',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
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
}
