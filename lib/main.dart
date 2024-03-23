import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';


void main() async {
  await initializeFirebase();
  runApp(const MyApp());
  // await signInWithEmailAndPassword();
  // // await getUserInfo();
  // await authStateChanges();

  await readFromDB();
  
}

initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized');
}


// Realtime Database
final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://flutter-firebase-auth-bacd7-default-rtdb.asia-southeast1.firebasedatabase.app/');
DatabaseReference refChat = rtdb.ref("chats/4");
DatabaseReference refMessage = rtdb.ref("message/4");

insertToDB() async {
  await refChat.set({
    "name": "Chat 4",
    "userID": "userID4"
  });

  await refMessage.set({
    "text": "Hello Chat App",
    "chatID": "uuid4" 
  });
}

updateDB() async {
  DatabaseReference refMessage = rtdb.ref("message/1");
  
  await refMessage.update({
    "text": "Hello Chat App, update message1"
  });
}

readFromDB() async {
  print("read firebase data");
  
  DatabaseReference refReadChat = rtdb.ref("chats");
  final snapshot = await refReadChat.child('/2').get();
  if (snapshot.exists) {
      print(snapshot.value);
  } else {
      print('No data available.');
  }

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

authStateChanges() async {
  FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
}

getUserInfo() async {
  await for (var user in FirebaseAuth.instance.authStateChanges()) {
    if (user != null) {
      print(user.uid);
    }
  }
}

createUserWithEmailAndPassword() async {
  print("create account");
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: "ninh@gmail.com",
      password: "123123",
    );

    print(credential);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

signInWithEmailAndPassword() async {
  print("sign in");
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "ninh@gmail.com",
      password: "1231233",
    );
    print(credential);
  } catch (e) {
    print('Signin failed, err=$e');
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
