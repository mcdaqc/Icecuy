import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/wallet_provider.dart';
import '../test_matic_screen/test_matic_screen.dart';
import '../wallet_init_screen/wallet_init_screen.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({Key? key}) : super(key: key);

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  //Navigate to Wallet Init Screen
  _navigate() {
    Navigation.push(
      context,
      screen: const WalletInitScreen(),
    );
  }

  _createWallet() async {
    await Provider.of<WalletProvider>(context, listen: false).createWallet();

    Navigation.push(
      context,
      screen: const TestMaticScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: rh(120)),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
            ),
            SizedBox(height: rh(10)),
            Center(
              child: UpperCaseText(
                'Ingrese a su billetera',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: rh(100)),
            Buttons.flexible(
              width: double.infinity,
              context: context,
              text: 'Tengo mi clave privada',
              onPressed: _navigate,
            ),
            SizedBox(height: rh(space3x)),
            CustomOutlinedButton(
              width: double.infinity,
              text: 'Crear una nueva billetera',
              onPressed: _createWallet,
            ),
          ],
        ),
      ),
    );
  }
}
