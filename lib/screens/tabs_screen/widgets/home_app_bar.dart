import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/wallet_provider.dart';
import '../../wallet_screen/wallet_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        // UpperCaseText(
        //   'EXPLORA',
        //   style: Theme.of(context).textTheme.headline2!.copyWith(
        //     letterSpacing: 2,
        //     fontWeight: FontWeight.w300,
        //   ),
        // ),

        ///WALLET

        GestureDetector(
          onTap: () => Navigation.push(
            context,
            screen: const WalletScreen(),
          ),
          child: Row(
            children: [
              Hero(
                tag: 'wallet',
                child: SvgPicture.asset(
                  'assets/images/wallet.svg',
                  width: rf(32),
                  //aqui gaaa
                  color: Colors.white,
                ),
              ),
              SizedBox(width: rw(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UpperCaseText(
                    'Saldo Total',
                    style: Theme.of(context).textTheme.overline,
                  ),
                  SizedBox(height: rh(2)),
                  Consumer<WalletProvider>(builder: (context, provider, child) {
                    return UpperCaseText(
                      formatBalance(provider.balance, 5) + ' MAT',
                      key: ValueKey(provider.balance),
                      style: Theme.of(context).textTheme.headline2,
                    );
                  }),
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }
}
