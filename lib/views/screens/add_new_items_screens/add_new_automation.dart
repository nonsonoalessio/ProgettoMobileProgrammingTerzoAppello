import 'package:flutter/material.dart';

class AddNewAutomationPage extends StatefulWidget {
  const AddNewAutomationPage({super.key});

  @override
  State<AddNewAutomationPage> createState() => _AddNewAutomationPageState();
}

class _AddNewAutomationPageState extends State<AddNewAutomationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text("Qui va il modulo di aggiunta di una nuova automazione"),
        ),
      ),
    );
  }
}
