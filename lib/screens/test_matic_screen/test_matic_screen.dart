import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/scale_animation.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/app_provider.dart';
import '../../provider/wallet_provider.dart';
import '../splash_screen/splash_screen.dart';

import '../../core/services/wallet_service.dart';
import '../../locator.dart';

final _walletService = locator<WalletService>();

class TestMaticScreen extends StatelessWidget {
  const TestMaticScreen({Key? key}) : super(key: key);


  _openUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
      await Future.delayed(const Duration(seconds: 2));
      _skipForNow(context);
    }
  }

  _skipForNow(context) async {
    await Provider.of<AppProvider>(context, listen: false).initialize();

    Navigation.popAllAndPush(context, screen: const SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: rh(80)),

            ScaleAnimation(
              duration: const Duration(milliseconds: 750),
              child: SvgPicture.asset(
                'assets/images/tick.svg',
                color: Colors.white,
                width: rf(100),
                //aqui gaa

              ),
            ),
            SizedBox(height: rh(20)),

            Center(
              child: UpperCaseText(
                'Felicitaciones',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: rh(space1x)),

            UpperCaseText(
              'Su billetera ha sido creada',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: rh(space1x)),
            UpperCaseText(
              '* Mantenga su clave privada en un lugar secreto y no la comparta con nadie',
              textAlign: TextAlign.center,
            ),

            SizedBox(height: rh(space3x)),

            Consumer<WalletProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    SizedBox(height: rh(space4x)),
                    DataTile(
                      label: 'Dirección Pública',
                      value: provider.address.hex,
                      icon: Iconsax.copy,
                      onIconPressed: () => copy(provider.address.hex),
                    ),
                    SizedBox(height: rh(space2x)),
                    DataTile(
                      label: 'Clave Privada',
                      value: '****************',
                      icon: Iconsax.copy,
                      onIconPressed: () => copy(_walletService.getPrivateKey()),
                    ),
                    SizedBox(height: rh(space3x)),
                    DataTile(
                      label: 'Saldo de Billetera',
                      value: formatBalance(provider.balance) + ' MAT',
                    ),
                    SizedBox(height: rh(space2x)),
                  ],
                );
              },
            ),

            SizedBox(height: rh(space4x)),
            Buttons.flexible(
              width: double.infinity,
              context: context,
              text: 'OBTENGAMOS MATIC DE PRUEBA',
              onPressed: () =>
                  _openUrl('https://faucet.polygon.technology', context),
            ),
            SizedBox(height: rh(space3x)),
            Buttons.text(
              context: context,
              text: 'OMITIR POR AHORA',
              onPressed: () => _skipForNow(context),
            ),
          ],
        ),
      ),
    );
  }
}
