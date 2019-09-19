import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                subtitle: Text('Lagu lagu perjuangan Indonesia adalah musik yang diciptakan untuk tujuan nasional. Lirik lagu wajib mengandung unsur-unsur yang dapat membangkitkan semangat perjuangan. Utamanya untuk para pejuang di masa penjajahan.\n\nKemudian, lagu -lagu tersebut disebut lagu wajib karena guru-guru disekolah diharuskan mengajarkan lagu tersebut pada siswanya dengan tujuan untuk menanamkan rasa cinta tangah air, menghargai dan mengingat jasa pahlawan serta meneladani semangat perjuangannya.\n\nLagu nasional diciptakan oleh komponis- komponis Indonesia yang hidup di masa sebelum kemerdekaan Indonesia. Beberapa namanya mungkin pernah kita dengar seperti WR. Supratman, Ismail Marzuki, Kusbini C. Simanjuntak dan seterusnya.\n\n'),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Ahmad Jamil Al Rasyid'),
              subtitle: Text('Programmer'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.globe),
              title: Text('jamilalrasyidis.me'),
              onTap: () async {
                const url = 'http://jamilalrasyidis.me/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.linkedin),
              title: Text('Ahmad Jamil Al Rasyid'),
              onTap: () async {
                const url = 'https://www.linkedin.com/in/jamilalrasyid/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.instagram),
              title: Text('@jamilchan'),
              onTap: () async {
                const url = 'https://www.instagram.com/jamilchan/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.facebook),
              title: Text('Ahmad Jamil Al Rasyid'),
              onTap: () async {
                const url = 'https://www.facebook.com/chulundsangadt';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            )
          ],
        ),
      )
    );
  }
}