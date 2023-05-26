import 'package:flutter/material.dart';
import '../core/utils/utils.dart';
import '../core/widgets/custom_widgets.dart';

class Scratch extends StatelessWidget {
  const Scratch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: space2x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: rh(100)),

              SizedBox(height: rh(60)),
              const BidTile(
                text: ' ',
                isSelected: true,
                value: '',
              ),
              SizedBox(height: rh(16)),
              const BidTile(
                text: ' ',
                value: '',
              ),
              SizedBox(height: rh(60)),
              Row(
                children: const [
                ],
              ),
              SizedBox(height: rh(30)),
              SizedBox(
                height: rh(100),
                child: const CustomTabBar(
                  titles: ['Created', 'Collected', 'Info', 'Details'],
                  tabs: [
                    Text('Created'),
                    Text('Collected'),
                    Text('Info'),
                    Text('Details'),
                  ],
                ),
              ),
              SizedBox(height: rh(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      text: 'Crear Colección',
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: rw(space2x)),
                  Expanded(
                    child: Buttons.flexible(
                      // width: double.infinity,
                      context: context,
                      // isLoading: true,
                      text: 'Hacer oferta',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: rh(30)),
              Buttons.text(
                context: context,
                text: 'Create NFT',
                onPressed: () {},
              ),
              SizedBox(height: rh(30)),
              const ActivityTile(
                action: '',
                from: ' ',
                to: ' ',
                amount: '',
              ),
              SizedBox(height: rh(30)),
              const DataTile(
                label: ' ',
                value: '',
              ),
              SizedBox(height: rh(30)),
              SizedBox(height: rh(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  PropertiesChip(
                    label: '',
                    value: '',
                    percent: '',
                  ),
                  PropertiesChip(
                    label: '',
                    value: '',
                    percent: '',
                  ),
                  PropertiesChip(
                    label: '',
                    value: '',
                    percent: '',
                  ),
                ],
              ),
              SizedBox(height: rh(60)),

            ],
          ),
        ),
      ),
    );
  }
}
