import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lilac/controller/auth_controller.dart';
import 'package:lilac/controller/credit_controller.dart';
import 'package:lilac/controller/nav_controller.dart';
import 'package:lilac/controller/transaction_controller.dart';
import 'package:lilac/widget/confirm_dialog.dart';
import 'package:lilac/widget/page_header.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

import '../core/app_constants.dart';
import '../data/database_helper.dart';

import 'login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  // ---- Change photo (camera / gallery) -> saved path in SharedPreferences
  Future<void> _pickImage(BuildContext context) async {
    final auth = context.read<AuthController>();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ]),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker()
        .pickImage(source: source, maxWidth: 800, imageQuality: 85);
    if (picked == null) return;

    // Copy to app storage so it survives cache clean-ups
    final dir = await getApplicationDocumentsDirectory();
    final saved = await File(picked.path).copy(
      p.join(dir.path, 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg'),
    );
    await auth.updateImage(saved.path);
  }

  // ---- Edit name
  Future<void> _editName(BuildContext context) async {
    final auth = context.read<AuthController>();
    final ctrl = TextEditingController(text: auth.userName);

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Name'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: kMutedText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Save', style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (name != null && name.isNotEmpty) await auth.updateName(name);
  }

  // ---- Clear Storage: DB + SharedPreferences, then back to Login
  Future<void> _clearStorage(BuildContext context) async {
    final auth = context.read<AuthController>();
    final tx = context.read<TransactionController>();
    final credit = context.read<CreditController>();
    final nav = context.read<NavController>();
    final navigator = Navigator.of(context, rootNavigator: true);

    final ok = await confirmDelete(
      context,
      title: 'Clear Storage',
      message: 'This will delete all your transactions, credits and profile '
          'data, and log you out.',
      confirmLabel: 'Clear',
    );
    if (!ok) return; 

    await DatabaseHelper.instance.clearAll();
    await tx.load();
    await credit.load();
    await auth.clearAll();
    nav.setIndex(0);

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (_) => false,
    );
  }

  Widget _avatar(String? imagePath) {
    const size = 120.0;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imagePath != null && File(imagePath).existsSync()
            ? Image.file(File(imagePath), fit: BoxFit.cover)
            : Container(
                color: const Color(0xFFB5B5B5),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 24,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                            color: Color(0xFFE6E6E6), shape: BoxShape.circle),
                      ),
                    ),
                    Positioned(
                      bottom: -26,
                      child: Container(
                        width: 96,
                        height: 76,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6E6E6),
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(96, 76)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Column(
      children: [
        PageHeader(
          title: 'Profile',
          showBack: true,
          onBack: () => context.read<NavController>().setIndex(0),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _avatar(auth.imagePath),
                      Positioned(
                        right: -2,
                        bottom: 2,
                        child: GestureDetector(
                          onTap: () => _pickImage(context),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.photo_camera,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(auth.userName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _editName(context),
                        child: const Icon(Icons.edit,
                            size: 15, color: kMutedText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton(
                    onPressed: () => _clearStorage(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kMutedText,
                      side: const BorderSide(color: kBorder),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                    ),
                    child: const Text('Clear Storage',
                        style: TextStyle(color: Color(0xFF9A9A9A))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}