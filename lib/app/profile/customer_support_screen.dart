import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  Future<void> _callSupport() async {
    final Uri phoneUri = Uri.parse('tel:9000263029');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint("Could not launch $phoneUri");
    }
  }

  Future<void> _emailSupport() async {
    final Uri emailUri = Uri.parse('mailto:customercare12brandsk@gmail.com?subject=Support');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint("Could not launch $emailUri");
    }
  }

  Future<void> _whatsappSupport() async {
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/+919000263029?text=Hello%20Support%2C%20I%20need%20assistance');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Customer Support",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Center Buttons
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Call Support
                GestureDetector(
                  onTap: _callSupport,
                  child: _buildSupportCard(
                    icon: Icons.phone,
                    label: "Call Us",
                  ),
                ),
                const SizedBox(height: 25),

                // Email Support
                GestureDetector(
                  onTap: _emailSupport,
                  child: _buildSupportCard(
                    icon: Icons.email,
                    label: "Email Us",
                  ),
                ),
                const SizedBox(height: 25),

                // WhatsApp Support
                GestureDetector(
                  onTap: _whatsappSupport,
                  child: _buildSupportCard(
                    icon: Icons.chat,
                    label: "Purchase Cards",
                    iconColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String label,
    Color iconColor = Colors.red,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
