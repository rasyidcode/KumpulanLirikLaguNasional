import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomAppbar extends StatelessWidget {
  final Widget body;

  CustomAppbar({@required this.body});
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Lirik Lagu Nasional",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: 'Poppins'
                ),
              ),
              background: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1555852441-ca0d327da1e5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80',
                    placeholder: (_, __) => CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.red,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ];
      },
      body: body,
    );
  }
}
