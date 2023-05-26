import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../models/nft.dart';

//para abrir enlace de metadata
_openUrl(String url) async {
  if (!await launch(url)) {}
}


class ContractDetailsWidget extends StatelessWidget {
  const ContractDetailsWidget({Key? key, required this.nft}) : super(key: key);

  final NFT nft;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UpperCaseText(
          'Detalles del contrato',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: rh(space3x)),
        DataTile(
          label: 'Dirección de Contrato',
          value: nft.cAddress,
          icon: Iconsax.copy,
          onIconPressed: () => copy(nft.cAddress),
          isValueBold: false,
        ),
        SizedBox(height: rh(space3x)),
        DataTile(
          label: 'Dirección de Metadata',
          value: nft.metadata.substring(21, 35)+"..."+nft.metadata.substring(nft.metadata.length-15, nft.metadata.length),
          icon: Iconsax.data,
          onIconPressed: () => _openUrl(nft.metadata),
          isValueBold: false,
        ),
        SizedBox(height: rh(space2x)),
        DataTile(
          label: 'Identificador de token',
          value: nft.tokenId.toString(),
          isValueBold: false,
        ),
        SizedBox(height: rh(space2x)),
        const DataTile(
          label: 'Estándar de token',
          value: 'ERC 721',
          isValueBold: false,
        ),
        SizedBox(height: rh(space2x)),
        const DataTile(
          label: 'Blockchain',
          value: 'Polygon Testnet',
          isValueBold: false,
        ),
      ],
    );
  }
}
