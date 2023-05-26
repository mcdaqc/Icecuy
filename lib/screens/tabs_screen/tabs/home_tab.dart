import 'package:flutter/material.dart';
import '../../../provider/fav_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/app_provider.dart';
import '../../collection_screen/collection_screen.dart';
import '../../nft_screen/nft_screen.dart';
import '../widgets/home_app_bar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: rh(70)),
            //APPBAR
            const HomeAppBar(),
            SizedBox(height: rh(space4x)),

            //TOP COLLECTIONS
            UpperCaseText(
              'Colecciones Destacadas',
              style: Theme.of(context).textTheme.headline4,
            ),

            SizedBox(height: rh(space3x)),

            Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.state == AppState.loading) {
                  return const LoadingIndicator();
                }

                return Consumer<FavProvider>(
                    builder: (context, favProvider, child) {
                  return ListView.separated(
                    itemCount: provider.topCollections.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space2x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final collection = provider.topCollections[index];
                      return GestureDetector(
                        onTap: () => Navigation.push(
                          context,
                          screen: CollectionScreen(collection: collection),
                        ),
                        child: CollectionListTile(
                          image: collection.image,
                          title: collection.name,
                          subtitle: 'Por ${formatAddress(collection.creator)}',
                          isFav: favProvider.isFavCollection(collection),
                          onFavPressed: () =>
                              favProvider.setFavCollection(collection),
                        ),
                      );
                    },
                  );
                });
              },
            ),
            // ListView.separated(
            //   itemCount: 3,
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   separatorBuilder: (BuildContext context, int index) {
            //     return SizedBox(height: rh(space2x));
            //   },
            //   itemBuilder: (BuildContext context, int index) {
            //     return GestureDetector(
            //       onTap: () => Navigation.push(
            //         context,
            //         screen: const CollectionScreen(),
            //       ),
            //       child: CollectionListTile(
            //         image: 'assets/images/collection-${index + 1}.png',
            //         title: 'Less is More',
            //         subtitle: 'By The Minimalist',
            //       ),
            //     );
            //   },
            // ),

            SizedBox(height: rh(space3x)),
            const Divider(),
            SizedBox(height: rh(space3x)),

            //FEATURED NFTS
            UpperCaseText(
              'NFTS Destacados',
              style: Theme.of(context).textTheme.headline4,
            ),

            SizedBox(height: rh(space3x)),

            Consumer<AppProvider>(
              builder: (context, provider, child) {
                return Consumer<FavProvider>(
                    builder: (context, favProvider, child) {
                  return GridView.builder(
                    itemCount: provider.featuredNFTs.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: rh(space2x),
                      crossAxisSpacing: rw(space2x),
                    ),
                    // separatorBuilder: (BuildContext context, int index) {
                    //   return SizedBox(height: rh(space3x));
                    // },
                    itemBuilder: (BuildContext context, int index) {
                      final nft = provider.featuredNFTs[index];
                      final nftname = nft.name.length < 24 ? nft.name: nft.name.substring(0, 23) + '...';

                      return NFTCard(
                        onTap: () => Navigation.push(context,
                            screen: NFTScreen(nft: nft)),
                        heroTag: '${nft.cAddress}-${nft.tokenId}',
                        image: nft.image,
                        title: nftname,
                        subtitle: nft.cName,
                        isFav: favProvider.isFavNFT(nft),
                        onFavPressed: () => favProvider.setFavNFT(nft),
                      );
                    },
                  );
                });
              },
            ),

            // ListView.separated(
            //   itemCount: 3,
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   separatorBuilder: (BuildContext context, int index) {
            //     return SizedBox(height: rh(space3x));
            //   },
            //   itemBuilder: (BuildContext context, int index) {
            //     return NFTCard(
            //       onTap: () =>
            //           Navigation.push(context, screen: const NFTScreen()),
            //       heroTag: '$index',
            //       image: 'assets/images/nft-${index + 1}.png',
            //       title: 'Woven Into Fabric',
            //       subtitle: 'Fabric Cloths',
            //     );
            //   },
            // ),

            SizedBox(height: rh(space7x)),
            SizedBox(height: rh(space7x))
          ],
        ),
      ),
    );
  }
}
