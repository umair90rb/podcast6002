import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Mentorreviews extends StatelessWidget {

  DbServices _db = DbServices();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return FutureBuilder(
        future: _db.getSnapshot("reviews/${user.uid}/reviews"),
        builder: (context, snapshot) {
          print(snapshot.data);
          if(snapshot.hasData){
            if(snapshot.data.length == 0){
              return Center(
                  child: Text(
                    "There are no reviews yet",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ));
            }
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50.0,

                                backgroundImage:
                                NetworkImage(snapshot.data[index]['avatar']),
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(width: 10,),
                              Text(snapshot.data[index]['name']),
                              SizedBox(width: 15,),
                              SmoothStarRating(
                                rating: double.parse(snapshot.data[index]['stars']),
                                isReadOnly: true,
                                size: 25,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: true,
                                spacing: 1.0,
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data[index]['review'], textAlign: TextAlign.justify,),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder:(context, index){
                return Divider();
              },
              itemCount: snapshot.data.length,
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }

    );
  }

}
