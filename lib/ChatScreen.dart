// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:schood/utils/BottomBarApp.dart';

class ChatScreen extends StatelessWidget {
//  final User? Userinfo;
/*  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');*/
  final TextEditingController messageController = TextEditingController();

  ChatScreen({super.key});

  //ChatScreen({required this.Userinfo});

/*  Future<void> sendMessage(
      String senderEmail, String recipientEmail, String message) async {}*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: /*StreamBuilder<QuerySnapshot>(
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
          ),*/
                Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      //controller: messageController,
                      decoration:
                          InputDecoration(hintText: 'Saisissez votre message'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      /*final message = messageController.text;
                    sendMessage(Userinfo!.email!, 'adresse_email_destinataire',
                        message);
                    messageController.clear();*/
                    },
                    child: const Text('Envoyer'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 3,
      ),
    );
  }
}
