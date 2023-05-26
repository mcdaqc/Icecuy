
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/utils.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final int currentIndex;

  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 30, 70, 30),
      child: SizedBox(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            //backgroundColor: Colors.black,
            elevation: 0,
            iconSize: rf(20),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Iconsax.home, color: Colors.white60),
                activeIcon: Icon(Iconsax.home_15),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.search_normal_1, color: Colors.white60),
                activeIcon: SvgPicture.asset(
                  "assets/images/search.svg",
                  color: Colors.white,
                  width: rf(20),
                ),
                label: 'Buscar',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Iconsax.heart, color: Colors.white60),
                activeIcon: Icon(Iconsax.heart5),
                label: 'Favoritos',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.user, color: Colors.white60),
                activeIcon: SvgPicture.asset(
                  "assets/images/user-active.svg",
                  color: Colors.white,
                  width: rf(20),
                ),
                label: 'Cuenta',
              ),
            ],
          ),
      ),
      ),
    );
  }
}
