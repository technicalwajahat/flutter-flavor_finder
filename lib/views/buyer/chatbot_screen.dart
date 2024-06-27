import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();

  static const apiKey = "AIzaSyBoc8fMmDzonI8jVQ026gIH-plGz02DPDE";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userInput.text;

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Messages(
                        isUser: message.isUser,
                        message: message.message,
                        date: DateFormat('HH:mm').format(message.date));
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    controller: _userInput,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: const Text('Enter Your Message')),
                  ),
                ),
                const Spacer(),
                IconButton(
                    padding: const EdgeInsets.all(12),
                    iconSize: 30,
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send_rounded))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade400,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
              topRight: const Radius.circular(10),
              bottomRight: isUser ? Radius.zero : const Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                fontSize: 16, color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
