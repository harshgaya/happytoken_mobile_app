import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Effective Date: January 1, 2025',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to Happy Tokens!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'These terms and conditions outline the rules and regulations for the use of our application, Happy Tokens. By accessing or using our app, you agree to be bound by these terms.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Use of Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Happy Tokens is designed to provide cashback and discounts for purchases made through our app. Users must adhere to all applicable laws and regulations while using our services.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'User Accounts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '- Users must provide accurate and complete information when creating an account.\n'
              '- You are responsible for maintaining the confidentiality of your account credentials.\n'
              '- Happy Tokens reserves the right to suspend or terminate accounts found to be in violation of these terms.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Transactions and Cashback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '- All transactions are subject to verification and approval.\n'
              '- Cashback offers range from 10-30% and are credited to your account within 48 hours of a successful transaction.\n'
              '- Misuse of the cashback system may lead to account suspension or forfeiture of rewards.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Prohibited Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Users are strictly prohibited from engaging in activities such as:\n'
              '- Attempting to manipulate or exploit cashback rewards.\n'
              '- Using automated systems or bots to access the app.\n'
              '- Violating the intellectual property rights of Happy Tokens or third parties.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Limitation of Liability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Happy Tokens is not liable for any:\n'
              '- Financial losses or damages arising from the use of our app.\n'
              '- Disruptions caused by technical issues or third-party services.\n'
              '- Unauthorized access to user accounts due to user negligence.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Modifications to Terms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We reserve the right to modify these terms at any time. Users will be notified of significant changes via email or in-app notifications. Continued use of the app after updates constitutes acceptance of the revised terms.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about these terms, please contact us at:\n\n'
              '📧 Email: enquiry.adpro@gmail.com\n\n'
              '📍 Office: #1207/343, 9th MAIN, 7th SECTOR, HSR LAYOUT,\nBengaluru, KA, 560102, India.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Thank you for choosing Happy Tokens!',
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
