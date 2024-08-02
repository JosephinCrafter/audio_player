import 'package:flutter/material.dart';
import 'package:audio_player/audio_player.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const AudioWidget(title: 'Audio Player'),
    );
  }
}

class AudioWidget extends StatefulWidget {
  const AudioWidget({super.key, required this.title});

  final String title;
  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints.loose(Size.fromWidth(150)),
          // width: 1000,
          // height: 250,
          child: const AudioPlayerView(
              iconSize: 48,
              title: Tooltip(
                message: "Alan Walker ft Selena Gomez - Keep me safe",
                child: Text(
                  "Alan Walker ft Selena Gomez - Keep me safe",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // titleTheme: TextStyle(color: Colors.black),
              inactiveColor: Colors.white38,
              url: "http://localhost:8000/Alan%20Walker_dnt.mp3"),
        ),
      ),
    );
  }
}
