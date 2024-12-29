import 'package:flutter/material.dart';
import 'package:giftly/helpers/db_helper.dart';
import 'package:giftly/screens/add_recipient_screen.dart';
import 'package:giftly/screens/edit_recipient_screen.dart';
import 'package:giftly/screens/notification_screen.dart';
import 'package:giftly/screens/recipient_info_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giftly",
        style: TextStyle(fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: Color(0xFF6E9F8D), // "Horizon" green
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotificationScreen(),
                ),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: DbHelper.fetchRecipients(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var recipients = snapshot.data;

                  if (recipients == null || recipients.isEmpty) {
                    return Center(
                      child: Text(
                        "No recipients added yet.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4E796A), // "Horizon" darker green
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: recipients.length,
                    itemBuilder: (_, index) {
                      var recipient = recipients[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RecipientInfoScreen(
                                recipient: recipient,
                              ),
                            ),
                          ),
                          title: Text(
                            recipient[DbHelper.recipientColName],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4E796A),
                            ),
                          ),
                          subtitle: Text(
                            recipient[DbHelper.recipientColRelationship],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  var result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EditRecipientScreen(
                                        recipient: recipient,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                                icon: Icon(Icons.edit, color: Color(0xFF92BCA6)),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text("Delete Recipient?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              DbHelper.deleteRecipient(
                                                recipient[DbHelper.recipientColId],
                                              );
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddRecipientScreen(),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: Color(0xFF92BCA6), // "Horizon" lighter green
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
