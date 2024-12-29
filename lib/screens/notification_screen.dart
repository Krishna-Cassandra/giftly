import 'package:flutter/material.dart';
import 'package:giftly/helpers/db_helper.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6E9F8D), // "Horizon" green
      ),
      body: FutureBuilder(
        future: DbHelper.fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4E796A), // "Horizon" darker green
              ),
            );
          }

          final notifications = snapshot.data;

          if (notifications == null || notifications.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet!",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4E796A), // "Horizon" darker green
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xFF92BCA6), // "Horizon" lighter green
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  title: Text(
                    notification[DbHelper.notificationColMessage],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
