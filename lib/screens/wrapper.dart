import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/authenticate/authenticate.dart';
import 'package:todo/shared/constants.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null){
      return Authenticate();
    }
    else {
      CURRENT_USER = user;
      return Home(currentUser: user,);}
  }
}
