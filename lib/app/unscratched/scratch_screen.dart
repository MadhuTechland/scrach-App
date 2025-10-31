// import 'package:flutter/material.dart';
// import 'package:flutter_scratcher/widgets.dart';
// import 'package:get/get.dart';
// import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
// import 'package:scratch_app/auth/controller/auth_controller.dart';
// import 'package:scratch_app/core/models/scratch_card_model.dart';
// import 'package:scratch_app/data/provider/api_client.dart';

// class ScratchCardScreen extends StatelessWidget {
//   final ScratchCard scratchCard;
//   const ScratchCardScreen({super.key, required this.scratchCard});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ScratchCardController>();
//     final authController = Get.find<AuthController>();

//     final userId = authController.user?.id;
//     final mediaWidth = MediaQuery.of(context).size.width;
//     final mediaHeight = MediaQuery.of(context).size.height;

//     final double cardSize = mediaWidth * 0.7; // 70% of screen width for a square

//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 16),
//           child: CircleAvatar(
//             backgroundColor: Colors.white,
//             child: IconButton(
//               icon: Icon(Icons.close, color: Colors.black),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: Center(
//               child: SizedBox(
//                 width: cardSize,
//                 height: cardSize,
//                 child: RepaintBoundary(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: Scratcher(
//                       brushSize: 50,
//                       threshold: 50,
//                       color: Colors.red,
//                       onThreshold: () async {
//                         final cardId = scratchCard.id;
//                         await controller.markAsScratched(cardId);
//                         controller.loadScratchCards(userId!);
//                         Get.back();

//                         // Bottom sheet
//                         Get.bottomSheet(
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(20)),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Text(
//                                   "🎉 Congratulations!",
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(16),
//                                   child: Image.network(
//                                     '${Get.find<ApiClient>().appBaseUrl}/${scratchCard.image}',
//                                     height: mediaHeight * 0.2,
//                                     fit: BoxFit.cover,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                             const Icon(Icons.error),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 const Text(
//                                   "You’ve just scratched a reward card!",
//                                   style: TextStyle(fontSize: 16),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     onPressed: () => Get.back(),
//                                     child: const Text("Awesome!"),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           isDismissible: true,
//                           enableDrag: true,
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           image: scratchCard.image != null
//                               ? DecorationImage(
//                                   image: NetworkImage(
//                                     '${Get.find<ApiClient>().appBaseUrl}/${scratchCard.image}',
//                                   ),
//                                   fit: BoxFit.cover,
//                                 )
//                               : null,
//                         ),
//                         child: scratchCard.image == null
//                             ? const Center(child: Icon(Icons.image_not_supported))
//                             : null,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: mediaHeight * 0.2,
//             padding: EdgeInsets.symmetric(
//               horizontal: mediaWidth * 0.05,
//               vertical: mediaHeight * 0.025,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.indigo[900],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Image.asset('assets/images/logo.jpg', height: mediaHeight * 0.05),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Gift card',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Rewarded for scratching a card in nudeal',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_scratcher/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:scratch_app/core/models/scratch_card_model.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/utils/app_constants.dart';

import '../../helper/app_routes.dart';
import '../dashboard/dashboard_screen.dart';

class ScratchCardScreen extends StatelessWidget {
  final ScratchCard scratchCard;
  const ScratchCardScreen({super.key, required this.scratchCard});

  // 🔹 POST call to update winner details
  Future<void> updateWinnerDetails({
    required int crashCardId,
    required String winnerName,
    required String phoneNumber,
  }) async {
    final String apiUrl = "${AppConstants.baseUrl}/api/update-winner";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "crash_card_id": crashCardId,
          "winner_user": winnerName,
          "phone_number": phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
         Get.snackbar("Success", "Winner details updated successfully");
          Get.back();
      // Wait a bit (optional, to close any open bottom sheets, etc.)
      await Future.delayed(const Duration(milliseconds: 200));
      dashboardKey.currentState?.switchToTab(1);
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error["message"] ?? "Failed to update winner");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScratchCardController>();
    final authController = Get.find<AuthController>();

    final userId = authController.user?.id;
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    final double cardSize = mediaWidth * 0.7;

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: cardSize,
                height: cardSize,
                child: RepaintBoundary(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Scratcher(
                      brushSize: 50,
                      threshold: 50,
                      color: Colors.red,
                      onThreshold: () async {
                        final cardId = scratchCard.id;
                        await controller.markAsScratched(cardId);
                        controller.loadScratchCards(userId!);

                        // ✅ Show bottom sheet with proper keyboard handling
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled:
                              true, // 🔥 Critical for keyboard handling
                          isDismissible: false,
                          enableDrag: false,
                          backgroundColor: Colors.transparent,
                          builder: (context) => WinnerBottomSheet(
                            cardId: cardId,
                            scratchCard: scratchCard,
                            onSubmit: updateWinnerDetails,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: scratchCard.image != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    '${Get.find<ApiClient>().appBaseUrl}/${scratchCard.image}',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: scratchCard.image == null
                            ? const Center(
                                child: Icon(Icons.image_not_supported))
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: mediaHeight * 0.2,
            padding: EdgeInsets.symmetric(
              horizontal: mediaWidth * 0.05,
              vertical: mediaHeight * 0.025,
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/logo.jpg',
                        height: mediaHeight * 0.05),
                    const SizedBox(width: 8),
                    const Text(
                      'Gift card',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rewarded for scratching a card in My Deal',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// 🔹 Custom BottomSheet Widget
class WinnerBottomSheet extends StatefulWidget {
  final int cardId;
  final ScratchCard scratchCard;
  final Future<void> Function({
    required int crashCardId,
    required String winnerName,
    required String phoneNumber,
  }) onSubmit;

  const WinnerBottomSheet({
    super.key,
    required this.cardId,
    required this.scratchCard,
    required this.onSubmit,
  });

  @override
  State<WinnerBottomSheet> createState() => _WinnerBottomSheetState();
}

class _WinnerBottomSheetState extends State<WinnerBottomSheet>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _confettiController;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize confetti animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _confettiAnimation = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    );
    // Start animation once
    _confettiController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool isValidPhone(String phone) {
    final regex = RegExp(r'^[6-9]\d{9}$'); // Valid Indian 10-digit numbers
    return regex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top bar
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "🎉 Congratulations!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // You're a Winner text
                  const Text(
                    "You're a Winner!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      '${Get.find<ApiClient>().appBaseUrl}/${widget.scratchCard.image}',
                      height: mediaHeight * 0.2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: mediaHeight * 0.2,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Please enter your details to claim your reward:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  TextField(
                    controller: phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: 'Phone Number',
                      prefixIcon:
                          Icon(Icons.phone_outlined, color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button with loader
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              final name = nameController.text.trim();
                              final phone = phoneController.text.trim();

                              if (name.isEmpty || phone.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all fields",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              if (!isValidPhone(phone)) {
                                Get.snackbar(
                                  "Invalid Number",
                                  "Please enter a valid 10-digit phone number",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              FocusScope.of(context).unfocus();
                              setState(() => _isLoading = true);

                              try {
                                await widget.onSubmit(
                                  crashCardId: widget.cardId,
                                  winnerName: name,
                                  phoneNumber: phone,
                                );
                                // ✅ Keep your original navigation behavior
                                Navigator.pop(context);
                                Get.back();
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "Claim Reward",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Confetti animation overlay - ONLY within bottom sheet
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: AnimatedBuilder(
                  animation: _confettiAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ConfettiPainter(_confettiAnimation.value),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Confetti Painter for birthday blast effect
class ConfettiPainter extends CustomPainter {
  final double progress;
  final List<Confetti> confettiPieces = [];

  ConfettiPainter(this.progress) {
    // Generate confetti pieces once
    final random = Random(42); // Fixed seed for consistency
    for (int i = 0; i < 50; i++) {
      confettiPieces.add(Confetti(
        color: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.purple,
          Colors.pink,
        ][random.nextInt(7)],
        x: random.nextDouble(),
        y: random.nextDouble() * 0.3 - 0.3,
        rotation: random.nextDouble() * 6.28,
        speed: 0.5 + random.nextDouble() * 0.5,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return; // Stop painting after animation completes

    final paint = Paint()..style = PaintingStyle.fill;

    for (var confetti in confettiPieces) {
      final x = confetti.x * size.width;
      final y = (confetti.y + progress * confetti.speed) * size.height;

      if (y > size.height) continue; // Don't draw if off screen

      paint.color = confetti.color.withOpacity(1 - progress);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(confetti.rotation + progress * 6.28);

      // Draw confetti as small rectangles
      canvas.drawRect(
        const Rect.fromLTWH(-4, -8, 8, 16),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class Confetti {
  final Color color;
  final double x;
  final double y;
  final double rotation;
  final double speed;

  Confetti({
    required this.color,
    required this.x,
    required this.y,
    required this.rotation,
    required this.speed,
  });
}