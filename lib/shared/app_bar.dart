import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/shared/constants.dart';

class ToDoAppBar extends StatelessWidget implements PreferredSizeWidget {
 final bool isHome ;

  ToDoAppBar({this.isHome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$APP_NAME"),
          ],
        ),
        actions: isHome ? [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthService().signOut();
            },
          )
        ] : null,
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 60);
}
