import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 50,
              child: CircularProgressIndicator(color: Color(0xFF0EE6F1)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Loading room ...", style: TextStyle(fontSize: 18),),
            )
          ],
        ),
      ),
    );
  }

}