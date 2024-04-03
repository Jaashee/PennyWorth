import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String transName;
  final String amount;

  const TransactionCard(
      {super.key, required this.transName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: const Icon(Icons.fastfood,
            color: Colors.orange), // Icon based on category
        title: Text('Food', style: Theme.of(context).textTheme.titleMedium),
        subtitle: const Text('Today'),
        trailing: const Text(
          '-\$45.00',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}







// Container(
//         padding: EdgeInsets.all(10),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: EdgeInsets.all(15),
//             color: Colors.grey[850],
//             height: 75,
//             child: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(
//                     Icons.attach_money_rounded,
//                     size: 35,
//                   ),
//                   Text(transName, style: TextStyle(fontSize: 22)),
//                   Text(
//                     '-\$' + amount,
//                     style: TextStyle(color: Colors.red, fontSize: 22),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));