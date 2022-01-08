import 'package:logging/logging.dart';
import 'package:mailman/model/credentials.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';

const _postAuthClientId = 'ae9b9894f8728ca78800942cda638155';
const _postAuthClientSecret = '89ff451ede545c3f408d792e8caaddf0';
const _postAuthScopes = ['PCCWEB offline_access'];
const _postAuthState = 'abcd';

class PostOAuth2Client extends OAuth2Client {
  PostOAuth2Client({required String redirectUri, required String customUriScheme}) : super(
      authorizeUrl: 'https://pccweb.api.post.ch/OAuth/authorization',
      tokenUrl: 'https://pccweb.api.post.ch/OAuth/token',
      redirectUri: redirectUri,
      customUriScheme: customUriScheme
  );
}

class PostcardAuthService {
  static PostcardAuthService? _instance;
  final Logger _log = Logger('PostcardAuthService');

  final PostOAuth2Client _client = PostOAuth2Client(
    customUriScheme: 'ch.post.pcc', // Must correspond to the AndroidManifest's "android:scheme" attribute
    redirectUri: 'ch.post.pcc://auth/1016c75e-aa9c-493e-84b8-4eb3ba6177ef', // Can be any URI, but the scheme part must correspond to the customeUriScheme
  );

  PostcardAuthService._();

  static PostcardAuthService get instance => _instance ??= PostcardAuthService._();

  Future<Credentials?> doLoginAction() async {
    try {
      _log.info('Trying to authenticate with post.ch');

      AccessTokenResponse tokenResponse = await _client.getTokenWithAuthCodeFlow(
        clientId: _postAuthClientId,
        clientSecret: _postAuthClientSecret,
        scopes: _postAuthScopes,
        state: _postAuthState,
        webAuthOpts: {
          "preferEphemeral": false,
        }
      );

      _log.info('Success');

      return Credentials(
          accessToken: tokenResponse.accessToken,
          refreshToken: tokenResponse.refreshToken,
          expiresAt: tokenResponse.expirationDate
      );
    } catch (error, stacktrace) {
      _log.info('Failed to authenticate', error, stacktrace);
      rethrow;
    }
  }
}