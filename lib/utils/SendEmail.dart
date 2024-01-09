import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String emailMessage, String recipientEmail) async {
  final smtpServer = SmtpServer('smtp.sendgrid.net',
      username: 'votre_nom_utilisateur_sendgrid',
      password: 'votre_mot_de_passe_sendgrid',
      port: 587);

  final message = Message()
    ..from = Address('votre_adresse_email', 'Votre Nom')
    ..recipients.add(recipientEmail)
    ..subject = 'Nouveau ticket'
    ..text = emailMessage;

  try {
    final sendReport = await send(message, smtpServer);
    //print('Message sent: ${sendReport.sent}');
  } on MailerException catch (e) {
    print('Message not sent. ${e.message}');
  }
}
