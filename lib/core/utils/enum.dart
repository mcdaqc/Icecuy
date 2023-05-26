import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == enumToString(v),
      orElse: () => throw NullThrownError(),
    );

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String? validator(String? e) => e == null
    ? 'Field can\'t be empty'
    : e.isEmpty
        ? 'ESTE CAMPO NO PUEDE ESTAR VACIO'
        : null;

String? urlValidator(String? e) {
  if (validator(e) == null) {
    final isUrl = e!.contains('https://') || e.contains('http://');

    if (!isUrl) {
      return 'La URL debería comenzar con https:// o http://';
    }
    return null;
  } else {
    return validator(e);
  }
}

String formatBalance(EtherAmount? balance, [int precision = 5]) =>
    balance == null
        ? '0'
        : balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(precision);

String formatAddress(String address) =>
    address.substring(0, 5) + '...' + address.substring(37, 42);

enum ListingType {
  fixedPriceSale,
  fixedPriceNotSale,
  bidding,
}

copy(String data) async {
  await Clipboard.setData(ClipboardData(text: data));

  Fluttertoast.showToast(msg: 'Copiado al portapapeles');
}

share(
  String title,
  String image,
  String description,
) async {
  try {
    Fluttertoast.showToast(msg: 'Porfavor espere');
    final imageUrl = 'https://ipfs.io/ipfs/$image';

    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';

    File(path).writeAsBytesSync(bytes);

    const link = ' ';

    await Share.shareFiles(
      [path],
      text: 'Écha un vistazo a ' +
          title +
          ' en IceCuy. Descarga la aplicación aquí https://',
      subject: description + link,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Error al compartir: $e');
  }
}

openUrl(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}
