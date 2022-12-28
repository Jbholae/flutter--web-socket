import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_test/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      // home: HomePage(),
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8000/ws'),
    // Uri.parse('ws://localhost:8080/socket'),
    // Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                var msg = Datas.fromJson(
                  jsonDecode(snapshot.data),
                );
                List? list = [];
                list.add(msg.body);
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
                // return Text(snapshot.hasData ? msg.body! : '');
                // return Flexible(
                //   flex: 1,
                //   fit: FlexFit.tight,
                //   child: ListView.builder(
                //     itemCount: list.length,
                //     itemBuilder: (context, index) {
                //       return Text("${list[index]}");
                //     },
                //   ),
                // );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

class Datas {
  final int? type;
  final String? body;

  Datas({this.type, this.body});

  factory Datas.fromJson(Map<String, dynamic> data) {
    return Datas(
      body: data['body'] ?? '',
      type: data['type'] ?? '',
    );
  }
}
