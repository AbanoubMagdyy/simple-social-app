import '../modules/hello_screen.dart';
import '../network/local/shared_prefrence.dart';
import 'components.dart';

String id = '';

void submit(context) {
  SharedHelper.deleteData('uid').then((value) {
    navigateTo(context, const HelloScreen());
  });
}
