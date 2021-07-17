import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey();
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return FutureBuilder(
      future: auth.initUniLinks(),
      builder: (ctx, snapshot) {
        print("state: ${snapshot.connectionState}");
        return Scaffold(
            appBar: AppBar(
              title: Text("Spotify Search"),
            ),
            body: Center(
              child: Card(
                elevation: 6.0,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "password"),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              auth.launchAuthorization();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Login with spotify"),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(Icons.login),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
