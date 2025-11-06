import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/creator.dart';
import '../manager/dashboard_controller.dart';
import '../widget/animated_card.dart';
import '../widget/creator_card_widget.dart';

class CreatorListPage extends StatefulWidget {
  const CreatorListPage({super.key});

  @override
  State<CreatorListPage> createState() => _CreatorListPageState();
}

class _CreatorListPageState extends State<CreatorListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedSort = 'name';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<DashboardController>(
        context,
        listen: false,
      );
      if (viewModel.creators.isEmpty) {
        viewModel.fetchCreators();
      }
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, Creator creator) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Delete Creator',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete ${creator.name}? This action cannot be undone.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await Provider.of<DashboardController>(
                  context,
                  listen: false,
                ).deleteCreator(creator.id);

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('${creator.name} deleted successfully'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Failed to delete creator'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  List<Creator> _getProcessedCreators(List<Creator> originalCreators) {
    List<Creator> processedList = List.from(originalCreators);

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      processedList = processedList
          .where(
            (c) =>
                c.name.toLowerCase().contains(query) ||
                c.designation.toLowerCase().contains(query),
          )
          .toList();
    }

    if (_selectedFilter != 'All') {
      processedList = processedList
          .where((creator) => creator.status == _selectedFilter)
          .toList();
    }

    switch (_selectedSort) {
      case 'name':
        processedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'followers':
        processedList.sort((a, b) => b.followers.compareTo(a.followers));
        break;
      // ... add other sort cases ...
    }

    return processedList;
  }

  @override
  Widget build(BuildContext context) {
    final creatorViewModel = Provider.of<DashboardController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Creator Profiles',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: Consumer<DashboardController>(
        builder: (context, viewModel, child) {
          final processedCreators = _getProcessedCreators(viewModel.creators);
          return Column(
            children: [
              // Search and Filter Bar
              _buildSearchFilterBar(context),

              // Main Content
              Expanded(
                child:
                    creatorViewModel.isLoading &&
                        creatorViewModel.creators.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00D4AA),
                          ),
                        ),
                      )
                    : AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: child,
                            ),
                          );
                        },
                        child: processedCreators.isEmpty
                            ? _buildEmptyState(creatorViewModel)
                            : _buildCreatorsGrid(
                                processedCreators,
                                creatorViewModel,
                              ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton(
          onPressed: () {
            context.push('/add-creator');
          },
          backgroundColor: const Color(0xFF00D4AA),
          foregroundColor: Colors.black,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildSearchFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search creators...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Filter Dropdown
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilter,
                dropdownColor: const Color(0xFF1A1A1A),
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                  });
                },
                items: ['All', 'Active', 'Away', 'Inactive'].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Sort Button
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: const Icon(Icons.sort, color: Colors.white),
            ),
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
              Provider.of<DashboardController>(
                context,
                listen: false,
              ).sortCreators(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem<String>(
                value: 'followers',
                child: Text('Sort by Followers'),
              ),
              const PopupMenuItem<String>(
                value: 'projects',
                child: Text('Sort by Projects'),
              ),
              const PopupMenuItem<String>(
                value: 'rating',
                child: Text('Sort by Rating'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(DashboardController viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            viewModel.creators.isEmpty
                ? 'No creators found'
                : 'No matching creators',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.creators.isEmpty
                ? 'Tap the + button to add your first creator'
                : 'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorsGrid(
    List<Creator> creators,
    DashboardController viewModel,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.75,
          ),
          itemCount: creators.length,
          itemBuilder: (context, index) {
            final creator = creators[index];
            return AnimatedCard(
              index: index,
              child: CreatorCard(
                creator: creator,
                onDelete: () => _showDeleteDialog(context, creator),
                onEdit: () {
                  context.push('/edit-creator/${creator.id}');
                },
              ),
            );
          },
        );
      },
    );
  }
}
