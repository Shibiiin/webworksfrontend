import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/creator.dart';
import '../manager/dashboard_controller.dart';

class CreatorFormPage extends StatefulWidget {
  final Creator? creator;

  const CreatorFormPage({super.key, this.creator});

  @override
  State<CreatorFormPage> createState() => _CreatorFormPageState();
}

class _CreatorFormPageState extends State<CreatorFormPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  final _aboutController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _profileImageController = TextEditingController();

  String _status = 'Active';
  final List<String> _skills = [];
  final _skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    if (widget.creator != null) {
      _nameController.text = widget.creator!.name;
      _designationController.text = widget.creator!.designation;
      _aboutController.text = widget.creator!.about;
      _emailController.text = widget.creator!.email;
      _locationController.text = widget.creator!.location;
      _profileImageController.text = widget.creator!.profileImageUrl;
      _status = widget.creator!.status;
      _skills.addAll(widget.creator!.skills);
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _designationController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _profileImageController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _saveCreator() async {
    if (_formKey.currentState!.validate()) {
      final creator = Creator(
        id: widget.creator?.id ?? '',
        name: _nameController.text.trim(),
        designation: _designationController.text.trim(),
        about: _aboutController.text.trim(),
        profileImageUrl: _profileImageController.text.trim(),
        portfolioImageUrls: widget.creator?.portfolioImageUrls ?? [],
        email: _emailController.text.trim(),
        location: _locationController.text.trim(),
        skills: _skills,
        status: _status,
        joinDate: widget.creator?.joinDate ?? DateTime.now(),
        lastActive: DateTime.now(),
        followers: widget.creator?.followers ?? 0,
        projects: widget.creator?.projects ?? 0,
        rating: widget.creator?.rating ?? 0.0,
      );

      final viewModel = Provider.of<DashboardController>(
        context,
        listen: false,
      );
      bool success;

      if (widget.creator == null) {
        success = await viewModel.addCreator(creator);
      } else {
        success = await viewModel.updateCreator(
          creator.copyWith(id: widget.creator!.id),
        );
      }

      if (success && mounted) {
        context.go('/');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.creator == null
                  ? 'Creator added successfully'
                  : 'Creator updated successfully',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to save creator'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.creator == null ? 'Add Creator' : 'Edit Creator',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF00D4AA)),
            onPressed: _saveCreator,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(position: _slideAnimation, child: child),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _designationController,
                  label: 'Designation',
                  icon: Icons.work,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a designation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _profileImageController,
                  label: 'Profile Image URL',
                  icon: Icons.link,
                ),
                const SizedBox(height: 20),
                _buildStatusDropdown(),
                const SizedBox(height: 20),
                _buildSkillsSection(),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _aboutController,
                  label: 'About',
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter about information';
                    }
                    if (value.trim().length < 10) {
                      return 'About should be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFF00D4AA)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00D4AA)),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _status,
            isExpanded: true,
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                _status = newValue!;
              });
            },
            items: ['Active', 'Away', 'Inactive'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _skillController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a skill',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00D4AA)),
                  ),
                ),
                onFieldSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: _addSkill,
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills.map((skill) {
            return Chip(
              label: Text(skill, style: const TextStyle(color: Colors.black)),
              backgroundColor: const Color(0xFF00D4AA).withOpacity(0.2),
              deleteIcon: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
              onDeleted: () => _removeSkill(skill),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D4AA), Color(0xFF009F7F)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: _saveCreator,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          widget.creator == null ? 'Create Creator' : 'Update Creator',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
