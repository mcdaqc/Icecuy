import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animations.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_placeholder/custom_placeholder.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/collection.dart';
import '../../provider/collection_provider.dart';
import '../../provider/fav_provider.dart';
import '../../provider/wallet_provider.dart';
import '../create_nft_screen/create_nft_screen.dart';
import '../nft_screen/nft_screen.dart';

import 'package:huawei_safetydetect/huawei_safetydetect.dart';


import 'dart:convert' show utf8;



class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key, required this.collection})
      : super(key: key);

  final Collection collection;

  @override
  _CollectionScreenState createState() => _CollectionScreenState();

}

// Example for obtaining the appID on a stateful widget's init state


// void getAppId() async {
//   String res = await SafetyDetect.getAppID;
//   if (!mounted) return;
//   setState(() {
//     appId = res;
//   });
// }


checkSysIntegrity() async {
  String res = await SafetyDetect.getAppID;

  Random secureRandom = Random.secure();
  final randomIntegers = <int>[];
  for (var i = 0; i < 24; i++) {
    randomIntegers.add(secureRandom.nextInt(255));
  }
  Uint8List nonce = Uint8List.fromList(randomIntegers);
  try {
    String result = await SafetyDetect.sysIntegrity(nonce, res);
    List<String> jwsSplit = result.split(".");
    String decodedText = utf8.decode(base64Url.decode(jwsSplit[1]));
    print("SysIntegrityCheck result is: $decodedText");
  } on PlatformException catch (e) {
    print("Error occured while getting SysIntegrityResult. Error is : $e");
  }
}


showAlertDialog (BuildContext context, String url) {


  // show the dialog
  showDialog(
    context: context,
    builder: (context) {
      String contentText = "Estás apunto de acceder a:\n"+url;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("ALERTA"),
            alignment: Alignment.center,
            backgroundColor: Color(0xff0b1d24),
            content: Text(contentText),
            actions: <Widget>[
              TextButton(
                onPressed: () {openUrl(url, context);},
                child: Text("Continuar"),
              ),
              TextButton(
                onPressed: () async {
                  contentText = await urlCheck(url);
                  setState(()  {
                    urlCheck(url).then((value) {

                    });
                  });
                },
                child: Text("Verificar URL"),
              ),
            ],
          );
        },
      );
    },
  );
}




Future<String> urlCheck(String url) async {
  String appId = await SafetyDetect.getAppID;
  String aea = '';
  List<UrlThreatType> threatTypes = [
    UrlThreatType.malware,
    UrlThreatType.phishing
  ];
  print("APPID: "+ appId);
  print("URL: "+url);
  print("threatTypes: "+threatTypes.toString());
  await SafetyDetect.initUrlCheck();

  List<UrlCheckThreat> urlCheckResults =
  await SafetyDetect.urlCheck(url , appId, threatTypes);

  //print("urlCheckResults: "+urlCheckResults.toString());
  if (urlCheckResults.isEmpty) {
    aea = 'No se detecta ninguna amenaza en la URL';
  } else {
    for (var element in urlCheckResults) {
      aea = 'Se detectó ${element.getUrlThreatType} en la URL';
    }
  }
  await SafetyDetect.shutdownUrlCheck();
  return aea;
}





class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<CollectionProvider>(context, listen: false)
        .fetchCollectionMeta(widget.collection);
  }

  _openUrl(String url) async {
    if (!await launch(url)) {}
  }






  _createNFT() {
    Navigation.push(
      context,
      screen: CreateNFTScreen(collection: widget.collection),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),

              SizedBox(height: rh(space2x)),

              //LIST TILE
              Consumer<FavProvider>(builder: (context, favProvider, child) {
                return CollectionListTile(
                  image: widget.collection.image,
                  title: widget.collection.name,
                  subtitle: 'Por ' + formatAddress(widget.collection.creator),
                  isFav: favProvider.isFavCollection(widget.collection),
                  onFavPressed: () =>
                      favProvider.setFavCollection(widget.collection),
                );
              }),
              SizedBox(height: rh(space3x)),

              //DESCRIPTION
              Consumer<CollectionProvider>(
                builder: (context, provider, child) {
                  return Text(
                    //para que la ñ y las tildes no se bugeen gaaaaaaaaaaa
                    utf8.decode(provider.metaData.description.runes.toList()), //este funciona pero a veces se bugea
                    //utf8.decode(utf8.encode(provider.metaData.description)), //este no funciona pipipi
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  );
                },
              ),
              SizedBox(height: rh(space3x)),

              //INSIGHTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpperCaseText(
                    // '25 Items',
                    ' ${widget.collection.nItems} NFTs',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  UpperCaseText(
                    '|',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Consumer<CollectionProvider>(
                      builder: (context, provider, child) {
                    return UpperCaseText(
                      '${provider.distinctOwners.length} Propietario(s)',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }),
                  UpperCaseText(
                    '|',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  UpperCaseText(
                    '${widget.collection.volumeOfEth} MAT Vol',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              SizedBox(height: rh(space3x)),

              //LINKS
              Consumer<CollectionProvider>(
                builder: (context, provider, child) {
                  final metaData = provider.metaData;
                  return Row(
                    children: <Widget>[
                      if (metaData.twitterUrl.isNotEmpty)
                        SlideAnimation(
                          begin: const Offset(-60, 0),
                          child: Buttons.icon(
                            context: context,
                            svgPath: 'assets/images/twitter.svg',
                            iconColor: Color(0xff1da1f2),
                            right: rw(space1x),
                            semanticLabel: 'twitter',
                            onPressed: () => showAlertDialog(context, metaData.twitterUrl),
                          ),
                        ),
                      if (metaData.websiteUrl.isNotEmpty)
                        SlideAnimation(
                          begin: const Offset(-40, 0),
                          child: Buttons.icon(
                            context: context,
                            icon: Iconsax.global5,
                            iconColor: Color(0xffffffff),
                            right: rw(space2x),
                            semanticLabel: 'Website',
                            onPressed: () => showAlertDialog(context, metaData.websiteUrl),
                          ),
                        ),
                      Buttons.icon(
                        context: context,
                        icon: Iconsax.copy,
                        iconColor: Color(0xffffffff),
                        right: rw(space2x),
                        semanticLabel: 'Copy',
                        onPressed: () => copy(widget.collection.cAddress),
                      ),
                      Buttons.icon(
                        context: context,
                        icon: Iconsax.share,
                        iconColor: Colors.white,
                        right: rw(space2x),
                        top: 0,
                        bottom: 0,
                        semanticLabel: 'Share',
                        onPressed: () => share(
                          widget.collection.name + " collection",
                          widget.collection.image,
                          metaData.description,
                        ),
                      ),
                      const Spacer(),
                      Consumer<WalletProvider>(
                          builder: (context, walletProvider, child) {
                        // print(widget.collection.creator);
                        if (walletProvider.address.hex ==
                            widget.collection.creator) {
                          return Buttons.text(
                            context: context,
                            right: 0,
                            text: 'Crear NFT',

                            onPressed: _createNFT,
                          );
                        }
                        return Container();
                      }),
                    ],
                  );
                },
              ),

              SizedBox(height: rh(space3x)),
              const Divider(),
              SizedBox(height: rh(space3x)),

              //ITEMS
              UpperCaseText(
                'NFTs',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: rh(space3x)),

              Consumer<CollectionProvider>(builder: (context, provider, child) {
                if (provider.state == CollectionState.loading) {
                  return const LoadingIndicator();
                } else if (provider.state == CollectionState.empty) {
                  return const EmptyWidget(text: 'Sin NFTs ');
                }
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: rh(space2x),
                    crossAxisSpacing: rw(space2x),
                  ),
                  itemCount: provider.collectionItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final nft = provider.collectionItems[index];
                    return GestureDetector(
                      onTap: () =>
                          Navigation.push(context, screen: NFTScreen(nft: nft)),
                      child: Hero(
                        tag: '${nft.cAddress}-${nft.tokenId}',
                        child: _ItemsTile(
                          image: nft.image,
                          title: nft.name,
                          // 'Stuck in time',
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemsTile extends StatelessWidget {
  const _ItemsTile({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //BACKGROUND IMAGE
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(space1x),
            child: CachedNetworkImage(
              //aqui abajo era gaaa
              imageUrl: 'https://ipfs.io/ipfs/$image',
              //imageUrl: '$image',
              fit: BoxFit.cover,
              placeholder: (_, url) => CustomPlaceHolder(size: rw(56)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        //OverLay
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: rh(60),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(
              bottom: space2x,
              left: space1x,
              right: space1x,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(space1x),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
            child: UpperCaseText(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
