import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/services/database.dart';
import 'package:todo/shared/app_bar.dart';
import 'package:todo/shared/constants.dart';

class AddNewCategory extends StatefulWidget {
  @override
  _AddNewCategoryState createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final _formKey = GlobalKey<FormState>();

  // state variables
  String _currentCategoryName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToDoAppBar(isHome: false,),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add new category",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _currentCategoryName = text;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.title),
                          labelText: "Category",
                          hintText: "Please name this category",
                        ),
                        validator: (value) => value.isEmpty ? "Enter category name" : null,
                      ),

                      SizedBox(
                        height: 40,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            TaskCategory categoryToAdd = TaskCategory(name: _currentCategoryName);
                            await DatabaseService().addNewCategoryToUserCategories(CURRENT_USER, categoryToAdd).catchError((error){
                              print(error);
                            });
                            Navigator.pop(context);
                          }
                          else{
                            // form is invalid
                          }

                        },
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
