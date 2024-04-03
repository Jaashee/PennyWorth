import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionCard extends StatefulWidget {
  final String transName;
  final String amount;
  final String category;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.transName,
    required this.amount,
    required this.category,
    required this.onDelete,
    required String categoryName,
    required IconData categoryIcon,
    required Color iconColor,
    required String description,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Maps should be instance variables now
  final Map<String, IconData> categoryIcons = {
    'Food & Dining': FontAwesomeIcons.utensils,
    'Utilities': FontAwesomeIcons.lightbulb,
    'Housing': FontAwesomeIcons.house,
    'Transportation': FontAwesomeIcons.bus,
    'Shopping': FontAwesomeIcons.cartShopping,
    'Entertainment': FontAwesomeIcons.film,
    'Travel': FontAwesomeIcons.plane,
    'Education': FontAwesomeIcons.graduationCap,
    'Personal Care': FontAwesomeIcons.handSparkles,
    'Health & Wellness': FontAwesomeIcons.heartPulse,
    'Savings & Investments': FontAwesomeIcons.piggyBank,
    'Kids': FontAwesomeIcons.baby,
    'Pets': FontAwesomeIcons.paw,
    'Gifts & Donations': FontAwesomeIcons.gift,
    'Miscellaneous': FontAwesomeIcons.ellipsis,
  };

  final Map<String, Color> categoryColors = {
    'Food & Dining': Colors.orange,
    'Utilities': Colors.blue,
    'Housing': Colors.green,
    'Transportation': Colors.purple,
    'Shopping': Colors.red,
    'Entertainment': Colors.pink,
    'Travel': Colors.teal,
    'Education': Colors.indigo,
    'Personal Care': Colors.amber,
    'Health & Wellness': Colors.lightGreen,
    'Savings & Investments': Colors.deepOrange,
    'Kids': Colors.lightBlue,
    'Pets': Colors.brown,
    'Gifts & Donations': Colors.pinkAccent,
    'Miscellaneous': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve icon and color based on category
    IconData icon = categoryIcons[widget.category] ?? FontAwesomeIcons.coins;
    Color? iconColor = categoryColors[widget.category] ?? Colors.grey[700];

    return ScaleTransition(
      scale: _animation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).cardColor,
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '\$${widget.amount}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
