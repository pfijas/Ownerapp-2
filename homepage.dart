import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ownerapp/FIRSTPART/profilepage.dart';
import 'package:ownerapp/FIRSTPART/salespage.dart';
import 'dart:convert';

import 'Firstcompany.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool showTodayData = true;

  Future<List<Map<String, dynamic>>> getData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.demo-zatreport.vintechsoftsolutions.com/api/Company/CompanyList/'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data1 = jsonData['Data']['ResponseData']['Data1'];
        return List<Map<String, dynamic>>.from(data1);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API');
    }
  }

  //API ADDING THE OVERAL TRANSATION
  late List<Map<String, dynamic>> responseData;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://api.demo-zatreport.vintechsoftsolutions.com/api/Company/GetOverallTrans?viewmode=full&today=2021-10-23&compid=0'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['Data']['ResponseData'] as List<dynamic>;
      responseData = List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 2000,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/white.jpg'), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                // Change to your preferred back icon
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // Navigate back
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 250),
                              child: IconButton(
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => profilepg(),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Text(
                          'VINTECH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("SOFT SOLUTIONs"),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            final dataList =
                            snapshot.data as List<Map<String, dynamic>>;

                            final chunkedData = chunkList(
                                dataList, 2); // Split data into chunks of 2
                            return Column(
                              children: [
                                for (final chunk in chunkedData)
                                  Row(
                                    children: [
                                      for (final companyData in chunk)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 250,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                elevation: 40,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 150,
                                                      child: Image.network(
                                                        'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2hvcHBpbmclMjBtYWxsJTIwaW50ZXJpb3J8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        companyData[
                                                        'CompanyName'],
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      subtitle: Text(
                                                        companyData['Address'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  EachCompany(),
                                                            ));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                showTodayData = true;
                              });
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              child: Card(
                                elevation: 5,
                                child: Container(
                                    decoration: const BoxDecoration(
                                      //color: Colors.grey,
                                      border: Border(
                                        left: BorderSide(
                                            width: 3, color: Colors.blueGrey),
                                      ),
                                    ),
                                    child: Center(child: Text("Today"))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              showTodayData = true;
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              child: Card(
                                elevation: 5,
                                child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 3, color: Colors.black54),
                                      ),
                                    ),
                                    child: Center(child: Text("Weekly"))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: responseData.length,
                            itemBuilder: (context, index) {
                              final transTypeData = responseData[index];
                              final transType = transTypeData['TransType'];

                              return Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              width: 6, color: Colors.blueGrey),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          showTransactionDetails(
                                              transTypeData, context);
                                        },
                                        child: ListTile(
                                          title:
                                          Center(child: Text('$transType')),
                                          // Other list tile properties
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTransactionDetails(Map<String, dynamic> transTypeData, BuildContext context) {
    String transType = transTypeData['TransType'];

    String cashText = 'Cash: ${transTypeData['Cash']}';
    String creditText = 'Credit: ${transTypeData['Credit']}';
    String bankText = 'Bank: ${transTypeData['Bank']}';
    String totalAmountText = 'TotalAmount: ${transTypeData['TotalAmount']}';

    if (transType == 'Receipt') {
      creditText = ''; // Empty text for credit
    }
    if (transType == 'Purchase') {
      bankText = ''; // Empty text for card
    }
    if (transType == 'Payment') {
      creditText = ''; // Empty text for card
    }


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Overall $transType Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              Text(cashText),
              if (creditText.isNotEmpty) Text(creditText), // Add creditText only if not empty
              if (bankText.isNotEmpty) Text(bankText),
             SizedBox(height: 10,),
              Text(totalAmountText,style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }
}
