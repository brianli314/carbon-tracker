/*
  final controller = TextEditingController();

  void addToCount() {
    bool invalid = false;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
            return SizedBox(
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Add data",
                      style: Theme.of(context).textTheme.headlineMedium),
                  TextField(
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.5),
                        ),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        hintText: "Enter number",
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                        errorText: invalid ? "Invalid input" : null),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyButton(
                          text: "Save",
                          onPressed: () {
                            try {
                              saveValue();
                              Navigator.of(context).pop();
                            } catch (e) {
                              setState(() {
                                invalid = true;
                              });
                            } finally {
                              controller.clear();
                            }
                          }),
                      const SizedBox(width: 8),
                      MyButton(
                          text: "Cancel",
                          onPressed: () =>
                              {Navigator.of(context).pop(), controller.clear()})
                    ],
                  )
                ],
              ),
            );
          }));
        });
  }

  void saveValue() {
    setState(() {
      int val = int.parse(controller.text);
      if (val + widget.value < 0 || val + widget.value > 99999999999) {
        throw ArgumentError("Maximum number");
      }
      widget.value += int.parse(controller.text);
    });
  }

WIDGET

Expanded(child: Container()),
FloatingActionButton(
  mini: true,
  backgroundColor: Theme.of(context).colorScheme.primary,
  elevation: 0,
  onPressed: addToCount,
  child: Icon(
    Icons.add,
    color: Theme.of(context).colorScheme.inversePrimary,
  ),
),
*/