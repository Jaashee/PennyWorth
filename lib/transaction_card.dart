import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String transName;
  final String amount;

  const TransactionCard(
      {super.key, required this.transName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: const Color.fromARGB(255, 50, 50, 50),
            height: 80,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.attach_money_rounded,
                    size: 35,
                  ),
                  Text(transName, style: const TextStyle(fontSize: 22)),
                  Text(
                    '-\$' + amount,
                    style: const TextStyle(color: Colors.red, fontSize: 22),
                  ),
                ],
              ),
            ),
          ),
        ));
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