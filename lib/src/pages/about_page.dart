import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdsUtil.hideBannerAd();
    
    return Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: Text('Tentang Aplikasi',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 14.0)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Dikarenakan semakin banyak budaya-budaya luar yang terutama di bidang musik yang masuk ke indonesia, sehingga banyak dari kita (mungkin) lupa dengan lagu-lagu nasional yang sangat mempunyai makna yang luar biasa, dengan hadirnya aplikasi ini harapannya dapat membantu siapapun untuk mengingat-ingat kembali lagu-lagu nasional kita.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: Text('Disclaimer',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 14.0)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'The content in this app is not affliated with, endorsed, sponsoered, or specifically approved by any company.\nAll copyright and trademarks are owned by their respective owners. The images in this application are collected from around the web, if we are in breach of copyright, please let us know and it will be removed as soon as possible.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.envelope,
                color: Colors.red,
              ),
              title: Text('Send Feedback'),
              onTap: () async {
                const url = 'mailto:ajapro07@gmail.com?subject=User+Feedback';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'vesion 1.1',
                style: TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
            )
          ],
        ));
  }
}
