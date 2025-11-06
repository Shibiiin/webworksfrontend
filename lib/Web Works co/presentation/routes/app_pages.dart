// lib/presentation/routes/app_pages.dart

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webworksco/Web%20Works%20co/presentation/manager/dashboard_controller.dart';
import 'package:webworksco/Web%20Works%20co/presentation/pages/creator_details_page.dart';
import 'package:webworksco/Web%20Works%20co/presentation/pages/homepage.dart';
import 'package:webworksco/Web%20Works%20co/presentation/widget/creator_form_page.dart';

class AppPages {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const CreatorListPage()),
      GoRoute(
        path: '/creator/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreatorDetailPage(creatorId: id);
        },
      ),
      GoRoute(
        path: '/add-creator',
        builder: (context, state) => const CreatorFormPage(),
      ),
      GoRoute(
        path: '/edit-creator/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;

          final creator = context.read<DashboardController>().getCreatorById(
            id,
          );
          return CreatorFormPage(creator: creator);
        },
      ),
    ],
  );
}
