import 'package:flutter/material.dart';

class StatisticBar extends StatefulWidget {
  final String taskName;
  double value;
  final String timeUnit;
  final String unit;
  Icon? icon;

  StatisticBar({
    super.key,
    required this.taskName,
    required this.value,
    required this.timeUnit,
    required this.unit,
    this.icon,
  });

  @override
  State<StatefulWidget> createState() => _StatisticBarState();
}

class _StatisticBarState extends State<StatisticBar>{

  void addToValue(int value) {
    if (value + widget.value < 0 || value + widget.value > 9999999999){
      throw ArgumentError("Invalid value"); 
    } else {
      setState(() {
        widget.value += value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: FittedBox(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Transform.scale(
                        scale: 1.9,
                        child: widget.icon,
                      ),
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.taskName,style: Theme.of(context).textTheme.displaySmall),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.value.toString(), style: Theme.of(context).textTheme.displayLarge),
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.all(3.5),
                              child: Text(
                                widget.unit,
                                style: Theme.of(context).textTheme.displaySmall
                              ),
                            )
                          ],
                        ),
                        Text(widget.timeUnit, style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                    
                  ],
                )),
          ),
        ),
      ),
    );
  }

  
}

class StatsUtils{
  static List<StatisticBar> fromList(String name, List<String> timeUnits, List<double> values, String unit, Icon? icon){
    List<StatisticBar> output = [];
    for (int i = 0; i < values.length; i++){
      output.add(
        StatisticBar(taskName: name, value: values[i], timeUnit: timeUnits[i], unit: unit, icon: icon)
      );
    }
    return output;
  }
}
