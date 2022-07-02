import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_interview/models/user.dart';

class ItemCard extends StatefulWidget {
  User user;

  ItemCard(
      {this.user,
        Key key})
      : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
      ),

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20,20,20,20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 15,
                        letterSpacing: 0.8,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text: "${widget.user.name}\n",
                      ),
                      TextSpan(
                        text: "${widget.user.phone}\n",
                        style: TextStyle(
                        ),
                      ),
                      TextSpan(
                          text: "${widget.user.gender}\n",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "${widget.user.address}",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
              ),
    );
  }



}
