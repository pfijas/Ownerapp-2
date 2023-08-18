import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EachCompany extends StatefulWidget {
  const EachCompany({Key? key}) : super(key: key);

  @override
  State<EachCompany> createState() => _EachCompanyState();
}

class _EachCompanyState extends State<EachCompany> {
  List<dynamic>? companyData;

  Future<void> fetchCompanyData() async {
    final url = Uri.parse(
        'http://api.demo-zatreport.vintechsoftsolutions.com/api/Dashboard/loaddashboard?Company=QMARTPERIYA2020TO21&FromDate=2019-06-11&ToDate=2021-06-11&companyId=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          companyData = data['Data']['Dashbaord'];
        });
      } else {
        // Handle error
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error during API call: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Company Details"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: companyData != null
              ? ListView.builder(
            itemCount: companyData!.length,
            itemBuilder: (context, index) {
              var transaction = companyData![index];
              String transType = transaction['TransType']; // Define transType here

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          width: 3, color: Colors.black54),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$transType ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(color: Colors.blueGrey),
                        if (transType == 'Purchase' || transType == 'Sales' )
                          Text("Credit: ${transaction['Credit']}"),
                        if (transType == 'Purchase' || transType == 'Sales' ||transType == 'Payment' || transType == 'Receipt')
                          Text("Cash: ${transaction['Cash']}"),
                        if (transType == 'Sales'||transType == 'Receipt' ||transType == 'Payment')
                          Text("Bank: ${transaction['Bank']}"),
                        if (transType == 'Sales'||transType == 'Payment'||transType == 'Receipt'||transType == 'Purchase')
                          SizedBox(height: 10,),
                          Text("Total Amount: ${transaction['TotalAmount']}",style: TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}