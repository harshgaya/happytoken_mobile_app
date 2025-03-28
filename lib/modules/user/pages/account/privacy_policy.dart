import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Effective Date: January 1, 2025',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Introduction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to Happy Tokens! Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our services.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Information We Collect',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- **Personal Information**: Your name, email address, phone number, and payment details when you sign up or make transactions.\n'
              '- **Usage Data**: Information about how you use our app, such as transaction history and interaction patterns.\n'
              '- **Device Information**: Details about your device, such as IP address, operating system, and browser type.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'How We Use Your Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We use your information to:\n'
              '- Process transactions and provide cashback rewards.\n'
              '- Improve and personalize your user experience.\n'
              '- Send you promotional offers and updates.\n'
              '- Ensure security and prevent fraud.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Sharing Your Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We do not sell your personal information to third parties. However, we may share your data with trusted partners to process transactions, comply with legal requirements, or enhance our services.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Your Rights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You have the right to:\n'
              '- Access and update your personal information.\n'
              '- Request the deletion of your data.\n'
              '- Opt-out of promotional communications.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Data Security',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We take appropriate measures to protect your information from unauthorized access, alteration, or disclosure. However, please note that no system is completely secure.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about our Privacy Policy, feel free to reach out to us at:\n\n'
              '📧 Email: enquiry.adpro@gmail.com\n\n'
              '📍 Office: #1207/343, 9th MAIN, 7th SECTOR, HSR LAYOUT,\nBengaluru, KA, 560102, India.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Thank you for trusting Happy Tokens!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
