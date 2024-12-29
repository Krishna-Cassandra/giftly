import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:giftly/helpers/db_helper.dart';

class AddRecipientScreen extends StatefulWidget {
  AddRecipientScreen({Key? key}) : super(key: key);

  @override
  _AddRecipientScreenState createState() => _AddRecipientScreenState();
}

class _AddRecipientScreenState extends State<AddRecipientScreen> {
  var recipientNameCtrl = TextEditingController();
  var recipientRelationshipCtrl = TextEditingController();
  var recipientBudgetCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Recipient",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6E9F8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recipient Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 102, 139, 252),
                      ),
                    ),
                    Gap(8),
                    TextField(
                      controller: recipientNameCtrl,
                      decoration: InputDecoration(
                        hintText: "Enter recipient's name",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 125, 175, 193)),
                        filled: true,
                        fillColor: Color(0xFFF1F1F1), // Light Grey
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                    ),
                    Gap(16),
                    Text(
                      "Relationship",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 102, 139, 252),
                      ),
                    ),
                    Gap(8),
                    TextField(
                      controller: recipientRelationshipCtrl,
                      decoration: InputDecoration(
                        hintText: "Enter relationship",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 125, 175, 193)),
                        filled: true,
                        fillColor: Color(0xFFF1F1F1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                    ),
                    Gap(16),
                    Text(
                      "Budget",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 102, 139, 252),
                      ),
                    ),
                    Gap(8),
                    TextField(
                      controller: recipientBudgetCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter budget",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 125, 175, 193)),
                        filled: true,
                        fillColor: Color(0xFFF1F1F1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (recipientNameCtrl.text.isEmpty ||
                      recipientRelationshipCtrl.text.isEmpty ||
                      recipientBudgetCtrl.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        contentTextStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                        content: Text("Please fill in all fields!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    DbHelper.insertRecipient(
                      recipientNameCtrl.text,
                      recipientRelationshipCtrl.text,
                      double.parse(recipientBudgetCtrl.text),
                    );
                    recipientNameCtrl.clear();
                    recipientRelationshipCtrl.clear();
                    recipientBudgetCtrl.clear();
                  }

                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color(0xFF92BCA6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Add Recipient",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
