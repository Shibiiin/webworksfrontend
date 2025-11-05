import 'package:go_router/go_router.dart';

import '../pages/creator_details_page.dart';
import '../pages/creator_individual_page.dart';

class AppPages {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const CreatorListPage()),
      GoRoute(
        path: '/creator/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreatorDetailPage(creatorId: id);
        },
      ),
    ],
  );
}
