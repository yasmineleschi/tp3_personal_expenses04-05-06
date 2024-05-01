import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp3/model/Transaction.dart';
import 'package:tp3/widgets/ChartBar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E('tr').format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }


  double get maxSpending {
    return groupedTransactionValues.fold(
        0.0,
            (sum, item) => sum + (item['amount'] as double)
    );

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                tx['day'] as String,
                tx['amount'] as double,
                maxSpending == 0.0
                    ? 0.0
                    : (tx['amount'] as double) / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
