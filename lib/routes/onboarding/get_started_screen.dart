import 'package:flutter/material.dart';

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
                    child: Text("mailman",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text("Mailman connects with your Postcard Creator account and sends free postcards for you, whenever they are available.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 24,),
                  const SellingPoint(
                    title: "Queue up postcards.",
                    subtitle: "Mailman automatically sends your postcards one by one after each 24-hour waiting period.",
                    icon: Icons.all_inbox,
                  ),
                  const SellingPoint(
                    title: "Share with friends.",
                    subtitle: "Select multiple recipients and send out the same postcard to each one.",
                    icon: Icons.people,
                  ),
                  const SellingPoint(
                    title: "A brilliant selling point.",
                    subtitle: "This is one more reason why you should be convinced this is a good idea.",
                    icon: Icons.favorite,
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
              child: Text("Sign up".toUpperCase())
          ),
          const SizedBox(height: 16,),
          OutlinedButton(
              onPressed: widget.onLoginPressed,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text("Log In".toUpperCase(),
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
