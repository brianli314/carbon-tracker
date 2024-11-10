import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/space_scroll.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> questions = [
    "Volcanoes emit less carbon dioxide annually than human activities. Humans release about 100 times more CO2 than volcanoes.",
    "The average person generates about 4 tons of carbon dioxide per year, mostly from transportation and energy use.",
    "Trees can absorb up to 48 pounds of CO2 per year. Over its lifetime, a tree can sequester about 1 ton of CO2.",
    "Livestock, especially cows, produce significant amounts of methane, a greenhouse gas 25 times more potent than carbon dioxide.",
    "The fashion industry is responsible for 10% of global carbon emissions, more than aviation and shipping combined.",
    "One round-trip flight from New York to London generates about the same carbon emissions as driving a car for a year.",
    "Producing one kilogram of beef can generate up to 60 kilograms of CO2 equivalents, making it one of the most carbon-intensive foods.",
    "Recycling aluminum saves 95% of the energy required to produce it from raw materials, significantly reducing carbon emissions.",
    "Electric cars produce fewer emissions over their lifetime compared to gas-powered cars, even when considering the energy used for battery production.",
    "Carbon dioxide can remain in the atmosphere for up to 1,000 years, contributing to long-term climate change.",
    "The link between CO₂ and rising temperatures was first theorized in the 1800s by scientist Eunice Newton Foote, but it took over a century for people to recognize its full impact.",
    "Atmospheric carbon dioxide levels are higher than they’ve been in at least 800,000 years, mainly due to fossil fuel emissions since the Industrial Revolution.",
    "Oceans absorb about 25-30% of human-made carbon emissions. Without this buffer, the effects of global warming would be even more extreme!",
    "What used to be a once-in-a-decade heatwave could occur about every other year by 2050 if emissions continue to rise.",
    "The Arctic is warming nearly four times faster than the global average, leading to faster ice melt, sea-level rise, and drastic impacts on ecosystems and human communities.",
    "Warming temperatures and altered rainfall patterns allow disease-carrying mosquitoes to inhabit new areas, potentially increasing the spread of diseases like malaria and dengue fever.",
    "The rate at which sea levels are rising has doubled in the last 30 years, endangering coastal cities and habitats globally.",
];
  int index = 0;

  List<String> prevQuestions = [];

  @override
  void initState() {
    super.initState();
    index = Random().nextInt(questions.length);
  }

  void goNext() {
    int nextIndex = getNextIndex();
    prevQuestions.add(questions[nextIndex]);
    setState(() {
      index = nextIndex;
    });
  }

  int getNextIndex() {
    int next = Random().nextInt(questions.length);
    if (prevQuestions.length == questions.length){
      prevQuestions = [];
    }

    if (prevQuestions.contains(questions[next]) || index == next) {
      getNextIndex();
    }
    return next;
  }

  @override
  Widget build(BuildContext context) {
    int index = Random().nextInt(questions.length);
    return Scaffold(
      appBar: AppBar(
        title: FittedText(
            text: "F U N   F A C T S",
            style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: SpaceBetweenScrollView(
          footer: MyButton(text: "Next", onTap: goNext),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  questions[index],
                  style: Theme.of(context).textTheme.displayMedium
                ),
            ),
          )),
    );
  }
}
