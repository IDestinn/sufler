import 'package:flutter/material.dart';

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({Key? key, required this.oldmaintext}) : super(key: key);
  final String oldmaintext;

  @override
  State<TextFieldPage> createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  final _textController = TextEditingController();
  late String newmaintext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Редактор текста'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(80),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  minLines: 5,
                  maxLines: 12,
                  controller: _textController,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 204, 204, 204), fontSize: 20),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 204, 204))),
                      hintText: "Введите текст для суфлера",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 150, 150, 150),
                          fontSize: 20),
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.topRight,
                        onPressed: () {
                          _textController.clear();
                        },
                        icon: const Icon(Icons.clear),
                        color: const Color.fromARGB(255, 204, 204, 204),
                      ))),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      _textController.text != ''
                          ? newmaintext = _textController.text
                          : newmaintext = widget.oldmaintext;
                      Navigator.pop(context, newmaintext);
                    },
                    padding: const EdgeInsets.all(30),
                    color: Colors.blueGrey,
                    child: const Text(
                      'Сохранить и перейти в суфлер',
                      style: TextStyle(
                          color: Color.fromARGB(255, 204, 204, 204),
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      _textController.text = widget.oldmaintext;
                    },
                    padding: const EdgeInsets.all(30),
                    color: Colors.blueGrey,
                    child: const Text(
                      'Перенести существующий текст',
                      style: TextStyle(
                          color: Color.fromARGB(255, 204, 204, 204),
                          fontSize: 20),
                    ),
                  ),
                ],
              )
            ])));
  }
}
