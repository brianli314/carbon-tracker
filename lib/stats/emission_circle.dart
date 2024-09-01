import 'package:tracker_app/themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_app/pages/emission_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class EmissionCircle extends StatefulWidget {
  num emissionNum;
  num goal;
  String timeUnit;
  EmissionCircle({
    super.key,
    required this.emissionNum,
    required this.timeUnit,
    required this.goal,
  });

  @override
  State<EmissionCircle> createState() => _EmissionCircleState();
}

class _EmissionCircleState extends State<EmissionCircle> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    double percent = (widget.emissionNum / widget.goal);
    double radius = 150;
    double startAngle = 210;
    double lineWidth = 20;
    double multiplier = 1 - ((startAngle - 180) / 180);
    double progressEndAngle = startAngle + percent * (360 - (2 * (startAngle - 180)));
    Color progress;
    Color background;
    switch (percent) {
      case <= 0.33: {
        progress = provider.rangeColors.colorScheme.primary;
        background = provider.rangeColors.colorScheme.onPrimary;
      }
      case >= 0.33 && <= 0.67: {
        progress = provider.rangeColors.colorScheme.secondary;
        background = provider.rangeColors.colorScheme.onSecondary;
      }
      case >= 0.67: {
        progress = Theme.of(context).colorScheme.inversePrimary;
        background = Theme.of(context).colorScheme.primary;
      }
      default: throw ArgumentError("Invalid progress input");
    }
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Carbon score", style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 50),        
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CircularPercentIndicator(
                radius: radius,
                startAngle: progressEndAngle,
                lineWidth: lineWidth,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                percent: (1 - percent) * multiplier,
                backgroundColor: Colors.transparent,
                progressColor: background,
              ),
              CircularPercentIndicator(
                radius: radius,
                startAngle: progressEndAngle,
                lineWidth: lineWidth,
                circularStrokeCap: CircularStrokeCap.round,
                percent: 0.009,
                backgroundColor: Colors.transparent,
                progressColor: Theme.of(context).colorScheme.surface,
              ),
              CircularPercentIndicator(
                radius: radius,
                startAngle: startAngle,
                lineWidth: lineWidth,
                animation: true,
                percent: percent * multiplier,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
                progressColor: progress,
              ),
              FaIcon(
                FontAwesomeIcons.seedling,
                size: 70,
                color: progress,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EmissionPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      elevation: 0,
                      fixedSize: const Size.fromRadius(150),
                      backgroundColor: Colors.transparent,
                      foregroundColor:
                          Theme.of(context).colorScheme.inversePrimary),
                  child: const SizedBox()),
            ],
          ),
          Text(
            widget.emissionNum.toString(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height:10),
          Text(widget.timeUnit, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height:15),
        ],
      ),
    );
  }
}

class EmissionCircleUtils {
  static List<EmissionCircle> fromList(List<num> values, num goal, List<String> timeUnits){
    List<EmissionCircle> output = [];
    for (int i = 0; i < values.length; i++){
      output.add(
        EmissionCircle(emissionNum: values[i], timeUnit: timeUnits[i], goal: goal)
      );
    }
    return output;

  }
}
