import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:giftly/helpers/db_helper.dart';

class EditRecipientScreen extends StatefulWidget {
  EditRecipientScreen({Key? key, required this.recipient}) : super(key: key);

  final recipient;

  @override
  _EditRecipientScreenState createState() => _EditRecipientScreenState();
}

class _EditRecipientScreenState extends State<EditRecipientScreen> {
  var recipientNameCtrl = TextEditingController();
  var recipientRelationshipCtrl = TextEditingController();
  var recipientBudgetCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    recipientNameCtrl.text = widget.recipient[DbHelper.recipientColName];
    recipientRelationshipCtrl.text =
        widget.recipient[DbHelper.recipientColRelationship];
    recipientBudgetCtrl.text =
        widget.recipient[DbHelper.recipientColBudget].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Recipient",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6E9F8D), // Soft Green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                        color: Color.fromARGB(255, 102, 139, 252), // Blue
                      ),
                    ),
                    Gap(8),
                    TextField(
                      controller: recipientNameCtrl,
                      decoration: InputDecoration(
                        hintText: "Enter recipient's name",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(
                                255, 125, 175, 193)), // Soft Blue-Grey
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
                      "Recipient Relationship",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 102, 139, 252), // Blue
                      ),
                    ),
                    Gap(8),
                    TextField(
                      controller: recipientRelationshipCtrl,
                      decoration: InputDecoration(
                        hintText: "Enter relationship",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(
                                255, 125, 175, 193)), // Soft Blue-Grey
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
                      "Recipient Budget",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 102, 139, 252), // Blue
                      ),
                    ),
                    Gap(8),
                    TextField(
                      controller: recipientBudgetCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter budget",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(
                                255, 125, 175, 193)), // Soft Blue-Grey
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
                    DbHelper.updateRecipient(
                      recipientNameCtrl.text,
                      recipientRelationshipCtrl.text,
                      double.parse(recipientBudgetCtrl.text),
                      widget.recipient[DbHelper.recipientColId],
                    );

                    Navigator.of(context).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color(0xFF92BCA6), // Soft Green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Edit Recipient",
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
