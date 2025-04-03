import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

Future<void> _callSupport() async {
  final Uri phoneUri = Uri.parse('tel:8977778784');
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    debugPrint("Could not launch $phoneUri");
  }
}

Future<void> _emailSupport() async {
  final Uri emailUri = Uri.parse('mailto:support@example.com?subject=Support');
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    debugPrint("Could not launch $emailUri");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Back Arrow & Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Customer support",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Notification List
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Makes the column take only necessary space
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Contact Us
                GestureDetector(
                  onTap: () async {
                    _callSupport();
                  },
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.phone, color: Colors.red, size: 40),
                        SizedBox(height: 10),
                        Text("Contact Us", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Email Us
                GestureDetector(
                  onTap: () async {
                    _emailSupport();
                  },
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.email, color: Colors.red, size: 40),
                        SizedBox(height: 10),
                        Text("Email Us", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
