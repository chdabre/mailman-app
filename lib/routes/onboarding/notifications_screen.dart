import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mailman/bloc/credentials/bloc.dart';
import 'package:mailman/repository/credentials_repository.dart';
import 'package:mailman/services/cloud_notification_service.dart';
import 'package:mailman/services/postcard_auth_service.dart';

final GetIt getIt = GetIt.instance;

class PushNotificationsScreen extends StatefulWidget {
  final void Function() onCompleted;

  const PushNotificationsScreen({
    Key? key,
    required this.onCompleted,
  }) : super(key: key);

  @override
  _PushNotificationsScreenState createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  void _requestNotificationPermissions() async {
    final notificationService = CloudNotificationService.instance;
    var success = await notificationService.requestNotificationPermission();
    if (success) { // In some cases, this method might be called twice.
      widget.onCompleted.call();
    }
  }

  @override
  void initState() {
    _requestNotificationPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Receive Push Notifications",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text("We can send you push notifications about the status of your postcards.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 24,),
                ],
              ),
            ),
          ),
          OutlinedButton(
              onPressed: () => widget.onCompleted.call(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                elevation: 0,
              ),
              child: Text("Done".toUpperCase(),
                style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
          ),
        ],
      ),
    );
  }
}