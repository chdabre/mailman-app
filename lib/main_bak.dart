// /// -----------------------------------
// ///          External Packages
// /// -----------------------------------
//
// import 'package:flutter/material.dart';
//
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:oauth2_client/access_token_response.dart';
// import 'package:oauth2_client/oauth2_client.dart';
//
// final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//
// /// -----------------------------------
// ///           Post Auth Variables
// /// -----------------------------------
//
// const POST_AUTH_CLIENT_ID = 'ae9b9894f8728ca78800942cda638155';
// const POST_AUTH_CLIENT_SECRET = '89ff451ede545c3f408d792e8caaddf0';
//
// class PostOAuth2Client extends OAuth2Client {
//   PostOAuth2Client({required String redirectUri, required String customUriScheme}): super(
//       authorizeUrl: 'https://pccweb.api.post.ch/OAuth/authorization', //Your service's authorization url
//       tokenUrl: 'https://pccweb.api.post.ch/OAuth/token', //Your service access token url
//       redirectUri: redirectUri,
//       customUriScheme: customUriScheme
//   );
// }
//
// //Instantiate an OAuth2Client...
// PostOAuth2Client client = PostOAuth2Client(
//   customUriScheme: 'ch.post.pcc', //Must correspond to the AndroidManifest's "android:scheme" attribute
//   redirectUri: 'ch.post.pcc://auth/1016c75e-aa9c-493e-84b8-4eb3ba6177ef', //Can be any URI, but the scheme part must correspond to the customeUriScheme
// );
//
// /// -----------------------------------
// ///           Profile Widget
// /// -----------------------------------
//
// class Profile extends StatelessWidget {
//   final logoutAction;
//   final String name;
//   final String picture;
//
//   Profile(this.logoutAction, this.name, this.picture);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           width: 150,
//           height: 150,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.blue, width: 4.0),
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               fit: BoxFit.fill,
//               image: NetworkImage(picture ?? ''),
//             ),
//           ),
//         ),
//         SizedBox(height: 24.0),
//         Text('Name: $name'),
//         SizedBox(height: 48.0),
//         RaisedButton(
//           onPressed: () {
//             logoutAction();
//           },
//           child: Text('Logout'),
//         ),
//       ],
//     );
//   }
// }
//
// /// -----------------------------------
// ///            Login Widget
// /// -----------------------------------
//
// class Login extends StatelessWidget {
//   final loginAction;
//   final String loginError;
//
//   const Login(this.loginAction, this.loginError);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         RaisedButton(
//           onPressed: () {
//             loginAction();
//           },
//           child: Text('Login'),
//         ),
//         Text(loginError ?? ''),
//       ],
//     );
//   }
// }
//
// /// -----------------------------------
// ///                 App
// /// -----------------------------------
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// /// -----------------------------------
// ///              App State
// /// -----------------------------------
//
// class _MyAppState extends State<MyApp> {
//   bool isBusy = false;
//   bool isLoggedIn = false;
//   String errorMessage = "";
//   String token = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Auth0 Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Auth0 Demo'),
//         ),
//         body: Center(
//           child: isBusy
//               ? CircularProgressIndicator()
//               : isLoggedIn
//               ? SelectableText(token)
//               : Login(loginAction, errorMessage),
//         ),
//       ),
//     );
//   }
//
//   Future<void> loginAction() async {
//     setState(() {
//       isBusy = true;
//       errorMessage = '';
//     });
//
//     try {
//       AccessTokenResponse tknResp = await client.getTokenWithAuthCodeFlow(
//         clientId: POST_AUTH_CLIENT_ID,
//         clientSecret: POST_AUTH_CLIENT_SECRET,
//         scopes: ['PCCWEB%20offline_access'],
//         state: 'abcd',
//       );
//
//       secureStorage.write(key: 'refresh_token', value: tknResp.refreshToken);
//
//       setState(() {
//         isBusy = false;
//         isLoggedIn = true;
//         token = tknResp.accessToken;
//       });
//     } catch (e, s) {
//       print('login error: $e - stack: $s');
//
//       setState(() {
//         isBusy = false;
//         isLoggedIn = false;
//         errorMessage = e.toString();
//       });
//     }
//   }
//
//   void logoutAction() async {
//     await secureStorage.delete(key: 'refresh_token');
//     setState(() {
//       isLoggedIn = false;
//       isBusy = false;
//     });
//   }
//
//   @override
//   void initState() {
//     initAction();
//     super.initState();
//   }
//
//   void initAction() async {
//     final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
//     if (storedRefreshToken == null) return;
//
//     setState(() {
//       isBusy = true;
//     });
//
//     try {
//       final tknResp = await client.refreshToken(
//         storedRefreshToken,
//         clientId: POST_AUTH_CLIENT_ID,
//         clientSecret: POST_AUTH_CLIENT_SECRET,
//       );
//
//       secureStorage.write(key: 'refresh_token', value: tknResp.refreshToken);
//
//       print(tknResp.accessToken);
//
//       setState(() {
//         isBusy = false;
//         isLoggedIn = true;
//         token = tknResp.accessToken;
//       });
//     } catch (e, s) {
//       print('error on refresh token: $e - stack: $s');
//       logoutAction();
//     }
//   }
// }