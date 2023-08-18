import 'package:flutter/material.dart';
class purchasepg extends StatefulWidget {
  const purchasepg({Key? key}) : super(key: key);

  @override
  State<purchasepg> createState() => _purchasepgState();
}

class _purchasepgState extends State<purchasepg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("PURCHASE"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cash :"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Credit :"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Return :"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total :",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
