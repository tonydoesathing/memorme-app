import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/presentation/theme/memor_me_icons_icons.dart';

class BottomNavBar extends StatelessWidget {
  final double height = 60.0;
  final double iconSize = 24.0;
  final int focusedTab;
  final ValueChanged<int> onPressed;
  const BottomNavBar({Key key, this.focusedTab = 0, this.onPressed})
      : super(key: key);

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[SizedBox(height: iconSize)],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    BuildContext context,
    IconData icon,
    int index,
  }) {
    Color color = focusedTab == index
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed != null ? onPressed(index) : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: color, size: iconSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(
            context: context,
            icon: focusedTab == 0
                ? MemorMeIcons.homefilled
                : MemorMeIcons.homeunfilled,
            index: 0,
          ),
          _buildTabItem(
            context: context,
            icon: MemorMeIcons.search,
            index: 1,
          ),
          _buildMiddleTabItem(),
          _buildTabItem(
            context: context,
            icon: focusedTab == 2
                ? MemorMeIcons.collectionsfilled
                : MemorMeIcons.collectionsunfilled,
            index: 2,
          ),
          _buildTabItem(
            context: context,
            icon: MemorMeIcons.memoryoutlined,
            index: 3,
          )
        ],
      ),
    );
  }
}
