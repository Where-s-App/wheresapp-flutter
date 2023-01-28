import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool searchBarExpanded = false;

  void expandSearchBar() {
    setState(() {
      searchBarExpanded = !searchBarExpanded;
      print(searchBarExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: widget.preferredSize,
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Row(
            children: [
              IconButton(
                onPressed: (() {
                  print('drawer');
                }),
                icon: const Icon(Icons.search),
              )
            ],
          ),
        ));
  }
}
