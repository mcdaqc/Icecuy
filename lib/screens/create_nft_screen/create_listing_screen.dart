import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/animations/animations.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/collection.dart';
import '../../models/listing_info.dart';
import '../../models/nft_metadata.dart';
import '../../provider/nft_provider.dart';
import '../../provider/wallet_provider.dart';
import '../confirmation_screen/confirmation_screen.dart';
import '../network_confirmation/network_confirmation_screen.dart';
import 'widgets/selectable_container.dart';

class CreateNFTListingScreen extends StatefulWidget {
  const CreateNFTListingScreen({
    Key? key,
    required this.nftMetadata,
    required this.collection,
  }) : super(key: key);

  final NFTMetadata nftMetadata;
  final Collection collection;

  @override
  _CreateNFTListingScreenState createState() => _CreateNFTListingScreenState();
}

class _CreateNFTListingScreenState extends State<CreateNFTListingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _royaltiesController = TextEditingController();

  _mintNFT() async {
    final provider = Provider.of<NFTProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      //aqui gaaa cuando un nft no esta a la venta, el valor de precio es 0
      final pricee = (_priceController.text).isEmpty?'0':_priceController.text;

      final listing = ListingInfo(
        listingType: provider.listingType,
        price: double.parse(pricee),
        royalties: int.parse(_royaltiesController.text),
      );
      // provider.mintNFT(listing);
      final transaction =
          await provider.buildTransaction(listing, widget.collection);

      Provider.of<WalletProvider>(context, listen: false)
          .getTransactionFee(transaction);

      Navigation.push(
        context,
        screen: ConfirmationScreen(
            action: 'Minting NFT',
            image: widget.nftMetadata.image,
            title: widget.nftMetadata.name,
            subtitle: widget.collection.name,
            onConfirmation: () {
              provider.mintNFT(listing, widget.collection);
              Navigation.popTillNamedAndPush(
                context,
                popTill: 'tabs_screen',
                screen: const NetworkConfirmationScreen(),
              );
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //para que no se bugee al dividir pantallas
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Consumer<NFTProvider>(builder: (context, provider, child) {
          final _listingType = provider.listingType;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              SizedBox(height: rh(space3x)),

              _NFTListTile(
                imagePath: widget.nftMetadata.image,
                title: widget.nftMetadata.name,
                subtitle: widget.collection.name,
              ),
              SizedBox(height: rh(space4x)),
              Row(
                children: [
                  Expanded(
                    child: SelectableContainer(
                      isSelected: _listingType == ListingType.fixedPriceSale ||
                          _listingType == ListingType.fixedPriceNotSale,
                      text: 'Precio Fijo',
                      onPressed: () =>
                          provider.listingType = (ListingType.fixedPriceSale),
                    ),
                  ),
                  SizedBox(width: rw(space1x)),
                  Expanded(
                    child: SelectableContainer(
                      isSelected: _listingType == ListingType.bidding,
                      text: 'Abierto \na ofertas',
                      onPressed: () =>
                          provider.listingType = (ListingType.bidding),
                    ),
                  ),
                ],
              ),
              SizedBox(height: rh(space3x)),

              //DYNAMIC CONTENT

              if (_listingType != ListingType.bidding)
                FadeAnimation(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UpperCaseText(
                        'En Venta',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      CupertinoSwitch(
                        value: _listingType == ListingType.fixedPriceSale,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (bool value) => provider.listingType = (value
                            ? ListingType.fixedPriceSale
                            : ListingType.fixedPriceNotSale),
                      ),
                    ],
                  ),
                ),

              if (_listingType != ListingType.bidding)
                SizedBox(height: rh(space1x)),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextFormField(
                      controller: _royaltiesController,
                      labelText: 'Regalías en %',
                      validator: validator,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    if (_listingType != ListingType.fixedPriceNotSale)
                      SizedBox(height: rh(space2x)),
                    if (_listingType != ListingType.fixedPriceNotSale)
                      FadeAnimation(
                        child: CustomTextFormField(
                          controller: _priceController,
                          labelText: _listingType == ListingType.bidding
                              ? 'Precio mínimo de oferta en MAT'
                              : 'Precio fijo en MAT',
                          validator: validator,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: rh(space4x)),

              Buttons.flexible(
                width: double.infinity,
                context: context,
                text: 'Mintear NFT',
                onPressed: _mintNFT,
              ),
              const Spacer(),

                UpperCaseText(
                  '* La plataforma no toma ningún porcentaje de las regalías.',
                  textAlign: TextAlign.center,
                ),

              SizedBox(height: rh(space2x)),
            ],
          );
        }),
      ),
    );
  }
}

class _NFTListTile extends StatelessWidget {
  const _NFTListTile({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(space1x),
          child: Image.file(
            File(imagePath),
            width: rf(56),
            height: rf(56),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: rw(space2x)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VerifiedText(
                text: title,
                isVerified: false,
              ),
              SizedBox(height: rh(4)),
              VerifiedText(
                text: subtitle,
                isUpperCase: false,
                isVerified: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
