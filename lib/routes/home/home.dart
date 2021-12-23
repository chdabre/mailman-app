import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mailman/bloc/auth/bloc.dart';
import 'package:mailman/bloc/jobs/bloc.dart';
import 'package:mailman/components/app_bar.dart';
import 'package:mailman/components/postcard_preview.dart';
import 'package:mailman/model/postcard.dart';
import 'package:mailman/routes/create_postcard/create_postcard.dart';
import 'package:mailman/routes/home/postcard_quick_actions_modal.dart';
import 'package:mailman/routes/onboarding/sign_up_modal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final GetIt getIt = GetIt.instance;

class HomeRoute extends StatefulWidget {
  static const routeName = '/home';

  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _jobsBloc = getIt<JobsBloc>();

  void _authListener(BuildContext context, AuthenticationState state) {
    if (state is Unauthenticated) {
      var signUpModal = SignUpModal.instance;
      signUpModal.startSignUp(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: getIt<AuthenticationBloc>(),
      listener: _authListener,
      builder: (_, authState) {
        return Scaffold(
          appBar: MailmanAppBar.buildAppBar(context),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              var created = await Navigator.pushNamed(
                  context, CreatePostcardRoute.routeName);
              if (created != null) _jobsBloc.add(RefreshJobsList());
            },
            backgroundColor: Theme.of(context).primaryColor,
            label: Text("CREATE"),
            icon: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Column(
              children: const [
                Expanded(
                  child: PostcardJobsList(),
                ),
                Divider(height: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PostcardJobsList extends StatefulWidget {
  const PostcardJobsList({Key? key}) : super(key: key);

  @override
  State<PostcardJobsList> createState() => _PostcardJobsListState();
}

class _PostcardJobsListState extends State<PostcardJobsList> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _jobsBloc = getIt<JobsBloc>();

  void _jobsListener(BuildContext context, JobsState state) {
    if (!state.loading) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.requestLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobsBloc, JobsState>(
      bloc: _jobsBloc,
      listener: _jobsListener,
      builder: (context, state) {
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () => _jobsBloc.add(RefreshJobsList()),
          child: state.jobsList.isEmpty ?
              const CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: PostcardJobsListEmptyPlaceholder(),
                  )
                ],
              ) :
              ListView.builder(
              itemCount: _jobsBloc.state.jobsList.length,
              itemBuilder: (c, i) {
                var postcard = _jobsBloc.state.jobsList[i];
                return PostcardJobsListItem(
                  key: Key(postcard.id.toString()),
                  isFirst: i == 0,
                  postcard: postcard,
                );
              }
          ),
        );
      },
    );
  }
}

class PostcardJobsListEmptyPlaceholder extends StatelessWidget {
  const PostcardJobsListEmptyPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              width: 175,
              image: AssetImage('assets/image/list_empty_placeholder.png')
            ),
            const SizedBox(height: 16),
            Text("Nothing here!",
              style: Theme.of(context).textTheme.headline6
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: 200,
              child: Text("Create your first Postcard using the button below.",
                textAlign: TextAlign.center,
              )
            ),
          ],
        )
    );
  }
}

class PostcardJobsListItem extends StatelessWidget {
  const PostcardJobsListItem({
    Key? key,
    required this.postcard,
    this.isFirst = false,
  }) : super(key: key);

  final Postcard postcard;
  final bool isFirst;

  String _getStatusString() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (postcard.status == 'SENT') return "Sent on ${postcard.timeSent != null ? DateFormat('MMM dd, kk:mm').format(postcard.timeSent!) : ""}";
    if (postcard.sendOn != null && postcard.sendOn!.isAfter(today)) return DateFormat('MMM dd, kk:mm').format(postcard.sendOn!);
    return "Waiting";
  }

  Color _getStatusColor() {
    if (postcard.status == 'SENT') return Colors.green;
    if (postcard.sendOn != null && postcard.sendOn!.isAfter(DateTime.now())) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isFirst) const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(backgroundColor: _getStatusColor(), radius: 6,),
              ),
              Text(_getStatusString().toUpperCase(),
                style: Theme.of(context).textTheme.overline,
              ),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                onPressed: () async {
                  bool refresh = await showQuickActionsModal(context, postcard);
                  if (refresh) {
                    getIt<JobsBloc>().add(RefreshJobsList());
                  }
                },
                icon: const Icon(Icons.more_vert, size: 20,)
              )
            ],
          ),
        ),
        PostcardPreview(postcard: postcard),
        const SizedBox(height: 8),
      ],
    );
  }
}
