import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final double height = 60.0;
  final double iconSize = 24.0;
  final int focusedTab;
  const BottomNavBar({Key key, this.focusedTab = 0}) : super(key: key);

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
    ValueChanged<int> onPressed,
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
            onTap: () => onPressed(index),
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
            icon: Icons.home,
            index: 0,
            onPressed: (value) {
              print(value.toString() + " HOME");
            },
          ),
          _buildTabItem(
            context: context,
            icon: Icons.search,
            index: 1,
            onPressed: (value) {
              print(value.toString() + " SEARCH");
            },
          ),
          _buildMiddleTabItem(),
          _buildTabItem(
            context: context,
            icon: Icons.collections,
            index: 2,
            onPressed: (value) {
              print(value.toString() + " COLLECTIONS");
            },
          ),
          _buildTabItem(
            context: context,
            icon: Icons.batch_prediction,
            index: 3,
            onPressed: (value) {
              print(value.toString() + " MEMORIES");
            },
          )
        ],
      ),
    );
  }
}
