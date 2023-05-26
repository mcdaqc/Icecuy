import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../core/services/wallet_service.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../locator.dart';
import '../../provider/wallet_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _walletService = locator<WalletService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomAppBar(),
            SizedBox(height: rh(space4x)),
            Hero(
              tag: 'wallet',
              child: SvgPicture.asset(
                'assets/images/wallet.svg',
                color: Colors.white,
                width: rf(60),
              ),
            ),
            SizedBox(height: rh(space2x)),
            UpperCaseText(
              'Billetera',
              style: Theme.of(context).textTheme.headline2,
            ),
            Consumer<WalletProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    SizedBox(height: rh(space4x)),
                    DataTile(
                      label: 'Saldo de Billetera',
                      value: formatBalance(provider.balance) + ' MAT',
                    ),
                    SizedBox(height: rh(space3x)),
                    DataTile(
                      label: 'Dirección Pública',
                      value: provider.address.hex,
                      icon: Iconsax.copy,
                      onIconPressed: () => copy(provider.address.hex),
                    ),
                    SizedBox(height: rh(space3x)),
                    DataTile(
                      label: 'Clave Privada',
                      value: '****************',
                      icon: Iconsax.copy,
                      onIconPressed: () => copy(_walletService.getPrivateKey()),
                    ),
                    SizedBox(height: rh(space6x)),
                    Buttons.text(
                      // width: double.infinity,
                      context: context,
                      text: 'Obtener Matic de Prueba',
                      onPressed: () => openUrl(
                        'https://faucet.polygon.technology',
                        context,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
