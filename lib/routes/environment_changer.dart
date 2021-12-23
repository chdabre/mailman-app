import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mailman/environment.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/secured_storage.dart';

import '../bloc/auth/bloc.dart';

final GetIt getIt = GetIt.instance;

class EnvironmentChangerRoute extends StatefulWidget {
  static const routeName = '/environment';

  @override
  _EnvironmentChangerRouteState createState() =>
      _EnvironmentChangerRouteState();
}

class _EnvironmentChangerRouteState extends State<EnvironmentChangerRoute> {
  final Logger _log = Logger('EnvironmentChangerRoute');
  late Environment _environment;
  late String _selectedFlavor;

  late TextEditingController _apiUrlTextController;

  @override
  void initState() {
    super.initState();
    _environment = getIt<Environment>();
    _selectedFlavor = _environment.flavor;
    _apiUrlTextController =
        TextEditingController(text: _environment.flavors[custom]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Environment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Current env: $_selectedFlavor"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton(
                      value: _selectedFlavor,
                      items: _environment.flavors.keys
                          .map(
                            (flavor) => DropdownMenuItem<String>(
                          value: flavor,
                          child: Text(flavor.toUpperCase()),
                        ),
                      )
                          .toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          _selectedFlavor = value;
                        });
                      },
                      selectedItemBuilder: (context) {
                        return _environment.flavors.keys
                            .map(
                              (flavor) =>
                              Center(child: Text(flavor.toUpperCase())),
                        )
                            .toList();
                      },
                    ),
                    if (_selectedFlavor != custom)
                      Text('${_environment.flavors[_selectedFlavor]}'),
                    if (_selectedFlavor == custom)
                      TextField(
                        controller: _apiUrlTextController,
                        onChanged: (text) {
                          _environment.flavors[custom] = text;
                        },
                        decoration:
                        InputDecoration(hintText: 'Enter custom URL'),
                      )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_selectedFlavor != _environment.flavor) {
                      _log.info('Updating flavor to $_selectedFlavor');

                      _environment.update(
                        flavor: _selectedFlavor,
                      );

                      getIt<ApiClient>().setEnvironment(_environment);
                      getIt<SecuredStorage>().persistEnvironment(_environment);

                      getIt<AuthenticationBloc>().add(Logout());
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
