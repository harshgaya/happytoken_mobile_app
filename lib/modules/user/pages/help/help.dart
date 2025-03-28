import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final userController = Get.put(UserController());

  @override
  void initState() {
    userController.getHelp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get in Touch',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ContactOption(
                  icon: Icons.email,
                  title: 'Email Us',
                  subtitle: userController.helpEmail.value,
                  color: Colors.orange,
                  onTap: () async {
                    final uri = Uri(
                      scheme: 'mailto',
                      path: userController.helpEmail.value,
                      query:
                          'subject=Hello&body=Please help me regarding Happy Tokens?', // Add subject and body (optional)
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      print('Could not launch $uri');
                    }
                  },
                ),
                const SizedBox(height: 12),
                // ContactOption(
                //   icon: Icons.phone,
                //   title: 'Call Us',
                //   subtitle: userController.helpMobileNo.value,
                //   color: Colors.green,
                //   onTap: () async {
                //     final uri =
                //         Uri.parse('tel:${userController.helpMobileNo.value}');
                //     if (await canLaunchUrl(uri)) {
                //       await launchUrl(uri);
                //     } else {
                //       print('Could not launch $uri');
                //     }
                //   },
                // ),
                // const SizedBox(height: 12),
                // ContactOption(
                //   icon: Icons.chat,
                //   title: 'Chat with Us',
                //   subtitle: 'Start a live chat',
                //   color: Colors.blue,
                //   onTap: () {
                //     // Handle live chat action
                //   },
                // ),
                const SizedBox(height: 12),
                ContactOption(
                  icon: Icons.chat_bubble,
                  title: 'WhatsApp Us',
                  subtitle: userController.helpWhatsapp.value,
                  color: Colors.teal,
                  onTap: () async {
                    final message =
                        Uri.encodeComponent("Please help me in Happy Tokens");
                    final uri = Uri.parse(
                        'https://wa.me/91${userController.helpWhatsapp.value}?text=$message');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      print('Could not launch $uri');
                    }
                  },
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle support action
                    },
                    icon: const Icon(Icons.headset_mic),
                    label: const Text('Contact Support'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ContactOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
