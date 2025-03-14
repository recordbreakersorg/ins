import 'package:flutter/material.dart';
import '../../backend/sessions.dart';

class StudentSignupPage extends StatefulWidget {
  const StudentSignupPage({super.key});

  @override
  State<StudentSignupPage> createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends State<StudentSignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/welcome3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon: Icon(Icons.person),
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Your code',
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      maxLength: 14,
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                          try {
                          final session = await sessionManager.signup(
                            _nameController.text,
                            _codeController.text,
                          );
                          if (session != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Successfully signed up")),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StudentSignupPage()),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: Text('Signup >'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupChooserPage extends StatelessWidget {
  const SignupChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/welcome3.png"),
            fit: BoxFit.cover,
          ),
        ), 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choose your role',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: null,
                child: Text("A teacher"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentSignupPage()),
                  );
                },
                child: Text("A student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}