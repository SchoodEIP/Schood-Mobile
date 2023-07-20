import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schood/utils/BottomBarApp.dart';

class ChatScreen extends StatelessWidget {
  final User? Userinfo;
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final TextEditingController messageController = TextEditingController();

  ChatScreen({required this.Userinfo});

  Future<void> sendMessage(
      String senderEmail, String recipientEmail, String message) async {
    await messagesCollection.add({
      'senderEmail': senderEmail,
      'recipientEmail': recipientEmail,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          messages[index].data() as Map<String, dynamic>;
                      final senderEmail = message['senderEmail'] as String;
                      final recipientEmail =
                          message['recipientEmail'] as String;
                      final messageText = message['message'] as String;

                      return ListTile(
                        title: Text(messageText),
                        subtitle:
                            Text('From: $senderEmail, To: $recipientEmail'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Une erreur s\'est produite : ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        InputDecoration(hintText: 'Saisissez votre message'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final message = messageController.text;
                    sendMessage(Userinfo!.email!, 'adresse_email_destinataire',
                        message);
                    messageController.clear();
                  },
                  child: Text('Envoyer'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarApp(
        index_app: 3,
        Userinfo: Userinfo,
      ),
    );
  }
}
