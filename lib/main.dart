import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmmproject/hmm.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HMM',
      supportedLocales: const [
        Locale("en", "US"),
        Locale("fa", "IR"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale("fa", "IR"),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Carmen",
      ),
      home: const MyHomePage(title: "HMM MINI PROJECT"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class SelectedWord {
  final String name;
  final String id;
  const SelectedWord({
    required this.name,
    required this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectedWord && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}

class _MyHomePageState extends State<MyHomePage> {
  List<SelectedWord> selectedWord = [];
  final boxDecoration = BoxDecoration(
    border: Border.all(
      width: 2,
      color: Colors.grey.withOpacity(0.5),
    ),
    borderRadius: BorderRadius.circular(16),
  );
  @override
  Widget build(BuildContext context) {
    final wordList = selectedWord.map((e) => e.name);
    final data = hmmCalc(wordList.toList());
    final bool canAddMore = !(data.isEmpty && selectedWord.isNotEmpty);

    double maxProb = 0;
    double sumProb = 0;
    for (var i = 0; i < data.length; i++) {
      maxProb = max(maxProb, data[i].prob);
      sumProb += data[i].prob;
    }
    final color = canAddMore ? Colors.green : Colors.red;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => {},
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Change Algorithm",
                      style: TextStyle(fontFamily: 'Carmen'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.change_circle_outlined),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 8,
            ),
            InkWell(
              onTap: () => {},
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "About this application",
                      style: TextStyle(fontFamily: 'Carmen'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.info_outline_rounded),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 8,
            ),
            InkWell(
              onTap: () => {},
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Exit",
                      style: TextStyle(fontFamily: 'Carmen'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.exit_to_app_rounded),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(fontFamily: 'Carmen', fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 2,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 650,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded),
                              Text(
                                "Click on the letters to add each word",
                                style: TextStyle(fontFamily: 'Carmen'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 8,
                            children: HMM.kWORDS
                                .map(
                                  (e) => Container(
                                    margin: const EdgeInsets.all(4),
                                    child: OutlinedButton(
                                      key: ValueKey(e.toString() + "button"),
                                      style: OutlinedButton.styleFrom(
                                        side:
                                            BorderSide(color: color, width: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 20,
                                              fontFamily: 'Carmen'),
                                        ),
                                      ),
                                      onPressed: !canAddMore
                                          ? null
                                          : () {
                                              setState(() {
                                                selectedWord.add(SelectedWord(
                                                    name: e,
                                                    id: DateTime.now()
                                                        .toIso8601String()));
                                              });
                                            },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline_rounded),
                            Text(
                              "Click on word to delete",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontFamily: 'Carmen'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Builder(builder: (context) {
                            return Wrap(
                              children: selectedWord
                                  .map(
                                    (e) => Container(
                                      margin: const EdgeInsets.all(4),
                                      child: OutlinedButton(
                                        key: ValueKey(e.toString() + "sel"),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            e.name,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontFamily: 'Carmen'),
                                          ),
                                        ),
                                        onPressed: () {
                                          selectedWord.removeWhere(
                                              (element) => element == e);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                if (selectedWord.isNotEmpty && data.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16.0),
                      decoration: boxDecoration,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.equalizer_outlined),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ": The probability of this combination of words is ",
                              style:
                                  TextStyle(fontFamily: 'Carmen', fontSize: 12),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              sumProb.toString(),
                              style: TextStyle(
                                  fontFamily: 'Carmen',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        Icon(Icons.info_outline_rounded),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            const Text(
                              "The probabilities highlighted in green",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: 'Carmen'),
                              textDirection: TextDirection.rtl,
                            ),
                            const Text(
                              ".are the most likely probabilities",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: 'Carmen'),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    data
                        .map(
                          (item) => Container(
                            margin: const EdgeInsets.only(
                              right: 16,
                              left: 16,
                              top: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 3,
                                color: (item.prob == maxProb
                                        ? Colors.green
                                        : Colors.red)
                                    .withAlpha(160),
                              ),
                            ),
                            child: ListTile(
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        // display(e.prob),
                                        "Probability",
                                        style: TextStyle(
                                          fontFamily: 'Carmen',
                                          color: (item.prob == maxProb
                                              ? Colors.green
                                              : Colors.red),
                                        ),
                                      ),
                                      Icon(
                                        Icons.calculate_outlined,
                                        color: (item.prob == maxProb
                                            ? Colors.green
                                            : Colors.red),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    item.prob.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Carmen',
                                      color: (item.prob == maxProb
                                          ? Colors.green
                                          : Colors.red),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                              subtitle: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Builder(builder: (context) {
                                  return Wrap(
                                    runSpacing: 12,
                                    spacing: 20,
                                    direction: Axis.horizontal,
                                    children: item.states
                                        .map(
                                          (e) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .arrow_right_circle,
                                                color: (item.prob == maxProb
                                                        ? Colors.green
                                                        : Colors.red)
                                                    .withAlpha(160),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                e,
                                                style: TextStyle(
                                                    fontFamily: 'Carmen',
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  );
                                }),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (selectedWord.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: boxDecoration,
                      child: Center(
                        child: Text(
                          "Please choose from the words above",
                          style: TextStyle(fontFamily: 'Carlen'),
                        ),
                      ),
                    ),
                  ),
                if (selectedWord.isNotEmpty && data.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: boxDecoration,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Warning",
                                  style: TextStyle(
                                      fontFamily: 'Carmen', color: Colors.red),
                                ),
                                Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "There is no possibility",
                              style: TextStyle(fontFamily: 'Carmen'),
                            ),
                            Text(
                              ".of this combination in this model",
                              style: TextStyle(fontFamily: 'Carmen'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 72,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}
