import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:giftly/helpers/db_helper.dart';
import 'package:giftly/helpers/notification_helper.dart';
import 'package:intl/intl.dart';

class RecipientInfoScreen extends StatefulWidget {
  RecipientInfoScreen({Key? key, required this.recipient}) : super(key: key);

  final recipient;

  @override
  _RecipientInfoScreenState createState() => _RecipientInfoScreenState();
}

class _RecipientInfoScreenState extends State<RecipientInfoScreen> {
  var expandableKey = GlobalKey<ExpandableFabState>();
  var occasionNameCtrl = TextEditingController();
  var occasionDateCtrl = TextEditingController();
  var giftIdeaNameCtrl = TextEditingController();
  var giftIdeaPriceCtrl = TextEditingController();

  var editOccasionNameCtrl = TextEditingController();
  var editOccasionDateCtrl = TextEditingController();
  var editGiftIdeaNameCtrl = TextEditingController();
  var editGiftIdeaPriceCtrl = TextEditingController();

  DateTime currentDate = DateTime.now();
  bool reminder = false;

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    occasionDateCtrl.text = DateFormat('yyyy-MM-dd').format(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipient[DbHelper.recipientColName],
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6E9F8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRecipientInfo(),
            const SizedBox(height: 16),
            _buildOccasionsList(),
            const SizedBox(height: 16),
            _buildGiftIdeasList(),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildExpandableFab(),
    );
  }

  Widget _buildRecipientInfo() {
    return ExpansionTile(
      title: Text(
        "Recipient Information",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Relationship: ${widget.recipient[DbHelper.recipientColRelationship]}",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text("Budget: ${widget.recipient[DbHelper.recipientColBudget]}",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOccasionsList() {
    return ExpansionTile(
      title: Text(
        "Occasions",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      children: [
        FutureBuilder(
          future: DbHelper.fetchOccasions(
              widget.recipient[DbHelper.recipientColId]),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var occasions = snapshot.data ?? [];

            if (occasions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No occasions found."),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: occasions.length,
              itemBuilder: (_, index) {
                var occasion = occasions[index];
                return _buildOccasionTile(occasion);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOccasionTile(dynamic occasion) {
    return ListTile(
      title: Text(
        occasion[DbHelper.occasionColName],
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text("Date: ${occasion[DbHelper.occasionColDate]}"),
      trailing: _buildOccasionActions(occasion),
    );
  }

  Widget _buildOccasionActions(dynamic occasion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: occasion[DbHelper.occasionReminderColName] == 1,
          onChanged: (value) {
            setState(() {
              reminder = value;
              DbHelper.updateOccasionReminder(
                  occasion[DbHelper.occasionColId], reminder);
              if (reminder) {
                scheduleNotification(
                  triggerTime: DateTime.now().add(Duration(seconds: 5)),
                  notificationMessage:
                      "Testing Notification: ${occasion[DbHelper.occasionColName]}",
                );
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _showEditOccasionDialog(occasion),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDeleteOccasion(occasion),
        ),
      ],
    );
  }

  Widget _buildGiftIdeasList() {
    return ExpansionTile(
      title: Text(
        "Gift Ideas",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      children: [
        FutureBuilder(
          future: DbHelper.fetchGiftIdeas(
              widget.recipient[DbHelper.recipientColId]),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var giftIdeas = snapshot.data ?? [];

            if (giftIdeas.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No gift ideas found."),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: giftIdeas.length,
              itemBuilder: (_, index) {
                var giftIdea = giftIdeas[index];
                return _buildGiftIdeaTile(giftIdea);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildGiftIdeaTile(dynamic giftIdea) {
    return ListTile(
      title: Text(
        giftIdea[DbHelper.giftIdeaColName],
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text("Price: ${giftIdea[DbHelper.giftIdeaColPrice]}"),
      trailing: _buildGiftIdeaActions(giftIdea),
    );
  }

  Widget _buildGiftIdeaActions(dynamic giftIdea) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _showEditGiftIdeaDialog(giftIdea),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDeleteGiftIdea(giftIdea),
        ),
      ],
    );
  }

  Widget _buildExpandableFab() {
    return ExpandableFab(
      key: expandableKey,
      type: ExpandableFabType.up,
      distance: 70,
      children: [
        FloatingActionButton.small(
          heroTag: "addOccasion",
          onPressed: () => _showAddOccasionDialog(),
          child: Icon(Icons.calendar_today),
        ),
        FloatingActionButton.small(
          heroTag: "addGiftIdea",
          onPressed: () => _showAddGiftIdeaDialog(),
          child: Icon(Icons.card_giftcard),
        ),
      ],
    );
  }

  void _showAddOccasionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Occasion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: occasionNameCtrl,
              decoration: InputDecoration(
                labelText: "Occasion Name",
                border: OutlineInputBorder(),
                hintText: "Enter occasion name",
                hintStyle: TextStyle(color: Color.fromARGB(255, 125, 175, 193)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: occasionDateCtrl,
              readOnly: true,
              onTap: () => _pickDate(context, occasionDateCtrl),
              decoration: InputDecoration(
                labelText: "Occasion Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Color.fromARGB(255, 125, 175, 193)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF92BCA6),
            ),
            onPressed: () {
              if (occasionNameCtrl.text.isNotEmpty) {
                DbHelper.insertOccasion(
                  occasionDateCtrl.text,
                  occasionNameCtrl.text,
                  widget.recipient[DbHelper.recipientColId],
                );

                occasionNameCtrl.clear();
                occasionDateCtrl.text =
                    DateFormat('yyyy-MM-dd').format(currentDate);
                setState(() {});
                Navigator.of(context).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddGiftIdeaDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Gift Idea"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: giftIdeaNameCtrl,
              decoration: InputDecoration(
                labelText: "Gift Idea Name",
                border: OutlineInputBorder(),
                hintText: "Enter gift idea",
                hintStyle: TextStyle(color: Color.fromARGB(255, 125, 175, 193)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: giftIdeaPriceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Gift Idea Price",
                border: OutlineInputBorder(),
                hintText: "Enter price",
                hintStyle: TextStyle(color: Color.fromARGB(255, 125, 175, 193)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF92BCA6),
            ),
            onPressed: () {
              if (giftIdeaNameCtrl.text.isNotEmpty &&
                  giftIdeaPriceCtrl.text.isNotEmpty) {
                DbHelper.insertGiftIdea(
                  giftIdeaNameCtrl.text,
                  double.parse(giftIdeaPriceCtrl.text),
                  widget.recipient[DbHelper.recipientColId],
                );

                giftIdeaNameCtrl.clear();
                giftIdeaPriceCtrl.clear();
                setState(() {});
                Navigator.of(context).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showEditGiftIdeaDialog(dynamic giftIdea) {
    editGiftIdeaNameCtrl.text = giftIdea[DbHelper.giftIdeaColName];
    editGiftIdeaPriceCtrl.text = giftIdea[DbHelper.giftIdeaColPrice].toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Gift Idea"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: editGiftIdeaNameCtrl,
              decoration: InputDecoration(
                labelText: "Gift Idea Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: editGiftIdeaPriceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Gift Idea Price",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (editGiftIdeaNameCtrl.text.isNotEmpty &&
                  editGiftIdeaPriceCtrl.text.isNotEmpty) {
                DbHelper.updateGiftIdea(
                  editGiftIdeaNameCtrl.text,
                  double.parse(editGiftIdeaPriceCtrl.text),
                  giftIdea[DbHelper.giftIdeaColId],
                );

                setState(() {});
                Navigator.of(context).pop();
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGiftIdea(dynamic giftIdea) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Gift Idea?"),
        content: Text("Are you sure you want to delete this gift idea?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              DbHelper.deleteGiftIdea(giftIdea[DbHelper.giftIdeaColId]);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showEditOccasionDialog(dynamic occasion) {
    editOccasionNameCtrl.text = occasion[DbHelper.occasionColName];
    editOccasionDateCtrl.text = occasion[DbHelper.occasionColDate];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Occasion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: editOccasionNameCtrl,
              decoration: InputDecoration(
                labelText: "Occasion Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: editOccasionDateCtrl,
              readOnly: true,
              onTap: () => _pickDate(context, editOccasionDateCtrl),
              decoration: InputDecoration(
                labelText: "Occasion Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (editOccasionNameCtrl.text.isNotEmpty) {
                DbHelper.updateOccasion(
                  occasion[DbHelper.occasionColId],
                  editOccasionNameCtrl.text,
                  editOccasionDateCtrl.text as int,
                );

                setState(() {});
                Navigator.of(context).pop();
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteOccasion(dynamic occasion) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Occasion"),
        content: Text("Are you sure you want to delete this occasion?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              DbHelper.deleteOccasion(occasion[DbHelper.occasionColId]);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
