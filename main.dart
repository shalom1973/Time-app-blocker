import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Blocker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LockScreen(),
    );
  }
}

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin = "1234";

  void _checkPin() {
    if (_pinController.text == _correctPin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("קוד שגוי")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("הזן קוד נעילה", style: TextStyle(fontSize: 20)),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _checkPin, child: Text("המשך")),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  void _exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("אפליקציה לחסימת יישומים"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: _exitApp,
            ),
          ],
        ),
        body: Center(
          child: Text("כאן תוצג הרשימה של האפליקציות המותרות"),
        ),
      ),
    );
  }
}
