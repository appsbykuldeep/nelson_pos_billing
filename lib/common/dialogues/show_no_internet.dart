import 'package:pos_billing/common/dialogues/show_alert.dart';

Future<void> showNoInternetAvailable() async {
  await AlertDialogue.show("Internet not available !");
}
