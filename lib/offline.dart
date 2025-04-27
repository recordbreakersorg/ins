import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged.map(
        (results) =>
            results.isNotEmpty ? results.first : ConnectivityResult.none,
      ),
      builder: (context, snapshot) {
        print("building offline ${connectivity.offline}");
        if (connectivity.offline) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Offline',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

Widget appBarTitle(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      OfflineBanner(),
    ],
  );
}

class Connectif {
  bool offline;
  Connectif(this.offline);
  factory Connectif.listener() {
    Connectif obj = Connectif(false);
    Connectivity().onConnectivityChanged.listen(obj.update);
    return obj;
  }

  void update(List<ConnectivityResult> results) {
    if (results.isEmpty) return;
    offline = results.last == ConnectivityResult.none;
  }
}

Connectif connectivity = Connectif.listener();
