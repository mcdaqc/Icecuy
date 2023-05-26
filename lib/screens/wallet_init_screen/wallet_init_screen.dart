import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/app_provider.dart';
import '../../provider/wallet_provider.dart';
import '../edit_user_info_screen/edit_user_info_screen.dart';
import '../splash_screen/splash_screen.dart';

class WalletInitScreen extends StatefulWidget {
  const WalletInitScreen({Key? key}) : super(key: key);

  @override
  _WalletInitScreenState createState() => _WalletInitScreenState();
}

class _WalletInitScreenState extends State<WalletInitScreen> {
  final TextEditingController _keyController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Github source code
  _navigateToGithub() async {
    if (await launch('https://github.com/mcdaqc')) {}
  }

  _next() async {
    if (_formKey.currentState!.validate()) {
      await Provider.of<WalletProvider>(context, listen: false)
          .initializeFromKey(_keyController.text);

      await Provider.of<AppProvider>(context, listen: false).initialize();

      Navigation.popAllAndPush(context, screen: const SplashScreen());
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: space2x),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomAppBar(),
              SizedBox(height: rh(60)),
              Center(
                child: UpperCaseText(
                  'Bienvenido a IceCuy.',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),

              SizedBox(height: rh(space4x)),

              //HELPER TEXT
              Text(
                'Requerimos el acceso a su billetera para firmar transacciones e interactuar con Blockchain.',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: rh(space4x)),

              Form(
                key: _formKey,
                child: Consumer<WalletProvider>(
                  builder: (_, provider, child) {
                    if (provider.state == WalletState.success) {
                      scheduleMicrotask(() {
                        Navigation.push(
                          context,
                          screen: const EditUserInfoScreen(),
                        );
                      });
                    }

                    return CustomTextFormField(
                      controller: _keyController,
                      obscureText: true,
                      labelText: 'CLAVE PRIVADA',
                      validator: validator,
                      errorText: provider.errMessage.isEmpty
                          ? null
                          : provider.errMessage.toUpperCase(),
                    );
                  },
                ),
              ),

              SizedBox(height: rh(space3x)),

              Buttons.flexible(
                width: double.infinity,
                context: context,
                text: 'INGRESAR',
                onPressed: _next,
              ),

              SizedBox(height: rh(space5x)),

              UpperCaseText(
                "** AVISO **",
                style: Theme.of(context).textTheme.headline2,
              ),

              SizedBox(height: rh(space3x)),

              //PRIVACY
              Text(
                'No compartimos su clave privada en ningún lado. Se almacena localmente en su dispositivo.', //Nuestro código está disponible públicamente en github.
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: rh(space3x)),

              //GITHUB LINK
              Buttons.text(
                context: context,
                text: '',
                //text: 'Echa un vistazo a nuestro código',
                onPressed: _navigateToGithub,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
