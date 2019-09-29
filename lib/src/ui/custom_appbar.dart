import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final Widget body;

  CustomAppbar(this.body);
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
              title: Text("Lirik Lagu Nasional",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: Stack(
                children: <Widget>[
                  Image.network(
                    'https://images.unsplash.com/photo-1555852441-ca0d327da1e5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80',
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
