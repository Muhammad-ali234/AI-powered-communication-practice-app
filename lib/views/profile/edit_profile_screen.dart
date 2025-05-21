import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  String? _photoUrl;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _initFields();
  }
  
  void _initFields() {
    final user = Provider.of<UserController>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _bioController.text = user.bio;
      _emailController.text = user.email;
      _photoUrl = user.photoUrl;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter your name',
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: false, // Email editing is disabled in this demo
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Simple email validation
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _bioController,
                label: 'Bio',
                hint: 'Tell us about yourself',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                'Profile Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your profile information is visible to you only. '
                'It helps personalize your experience. '
                'Stats and achievements are calculated based on your activity.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfilePicture() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                ? NetworkImage(_photoUrl!) as ImageProvider
                : const AssetImage('assets/images/default_avatar.png'),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: _showImagePickerModal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Change Profile Picture',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.textPrimary
                : AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
  
  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Profile Picture',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      // In a real app, implement camera integration
                      Navigator.pop(context);
                      _showSnackBar('Camera functionality would be implemented in a real app');
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      // In a real app, implement gallery integration
                      Navigator.pop(context);
                      _showSnackBar('Gallery functionality would be implemented in a real app');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_photoUrl != null && _photoUrl!.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _photoUrl = '';
                    });
                    _showSnackBar('Profile picture removed');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Remove Photo'),
                ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.textPrimary
                  : AppColors.darkTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final userController = Provider.of<UserController>(context, listen: false);
        await userController.updateUserProfile(
          name: _nameController.text,
          bio: _bioController.text,
          photoUrl: _photoUrl,
        );
        
        if (mounted) {
          _showSnackBar('Profile updated successfully');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to update profile: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 