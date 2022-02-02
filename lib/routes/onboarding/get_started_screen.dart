import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetStartedScreen extends StatefulWidget {
  final void Function() onLoginPressed;
  final void Function() onSignUpPressed;

  const GetStartedScreen({
    Key? key,
    required this.onLoginPressed,
    required this.onSignUpPressed,
  }) : super(key: key);

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(AppLocalizations.of(context)!.appTitle,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text(AppLocalizations.of(context)!.appIntroDescription,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 24,),
                  SellingPoint(
                    title: AppLocalizations.of(context)!.appIntroQueueUpTitle,
                    subtitle: AppLocalizations.of(context)!.appIntroQueueUpDescription,
                    icon: Icons.all_inbox,
                  ),
                  SellingPoint(
                    title: AppLocalizations.of(context)!.appIntroScheduleDeliveryTitle,
                    subtitle: AppLocalizations.of(context)!.appIntroScheduleDeliveryDescription,
                    icon: Icons.schedule,
                  ),
                  SellingPoint(
                    title: AppLocalizations.of(context)!.appIntroCreateTitle,
                    subtitle: AppLocalizations.of(context)!.appIntroCreateDescription,
                    icon: Icons.bolt,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: widget.onSignUpPressed,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
              ),
              child: Text(AppLocalizations.of(context)!.appIntroSignUpCTA.toUpperCase())
          ),
          const SizedBox(height: 16,),
          OutlinedButton(
              onPressed: widget.onLoginPressed,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(AppLocalizations.of(context)!.appIntroLogInCTA.toUpperCase(),
                style: Theme.of(context).textTheme.button?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary
                ),
              )
          )
        ],
      ),
    );
  }
}

class SellingPoint extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SellingPoint({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ListTile(
        leading: CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary,)
        ),
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 16,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.headline6,),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyText1,),
      ),
    );
  }
}
