import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/error.dart';
import '../utils/network_manager.dart';

import '../models/category.dart';

const errorMessage = {
  NetworkError.serverError: '''
      Our server is currently experience problems. Please wait a moment and try again.
      If the problems persist, please contact our support for more help.
      ''',
  NetworkError.parseError: '''
    Our server is currently experience problems. Please wait a moment and try again.
    If the problems persist, please contact our support for more help.
      ''',
  NetworkError.unknownError: '''
    An unexpected problem has happen. Please wait a moment and try again.
    If the problems persist, please contact our support for more help.
    '''
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tasks Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  // State<MyHomePage> createState() => _MyHomePageState();
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final networkManager = NetworkManager.instance;
  late final Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Category>>(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data != null && data.isNotEmpty) {
                return ListView.builder(
                  itemCount: data.length,
                  prototypeItem: ListTile(
                    title: Text(data.first.name),
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index].name),
                    );
                  },
                );
              } else if (data != null && data.isEmpty) {
                return Text('No categories');
              }
            }
            if (snapshot.hasError) {
              late NetworkError error;
              if (snapshot.error != null && snapshot.error is NetworkError) {
                error = snapshot.error as NetworkError;
              }
              return Text(errorMessage[error] ?? '');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Category>> getCategories() async {
    final fetchResult = await networkManager.fetchCategories();
    return fetchResult.match(
        (error) => Future.error(error), (value) => Future.value(value));
  }
}
