import 'package:flutter/material.dart';
import 'package:flutter_scratcher/scratcher.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/notification_screen.dart';

class UnscratchedScreen extends StatefulWidget {
  @override
  _UnscratchedScreenState createState() => _UnscratchedScreenState();
}

class _UnscratchedScreenState extends State<UnscratchedScreen> {
  List<bool> scratched =
      List.generate(6, (index) => false); // Store scratched state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.yellowAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // Custom AppBar
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Unscratched cards",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Notification Icon
                        InkWell(
                          onTap: () {
                            Get.to(() => const NotificationListScreen());
                          },
                          child: Center(
                            child: Image.asset(
                              'assets/images/notification_image.png',
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Grid of Unscratched Cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: 6, // Number of scratch cards
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two items per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1, // Square shape
                    ),
                    itemBuilder: (context, index) {
                      return Scratcher(
                        brushSize: 50,
                        threshold: 50,
                        color: Colors.red,
                        onChange: (value) {},
                        onThreshold: () {
                          setState(() {
                            scratched[index] = true; // Mark as scratched
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: scratched[index]
                              ? _scratchedCardContent()
                              : _unscratchedCardContent(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Unscratched Card Cover
  Widget _unscratchedCardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/unscratch_image.png', // Cover image
        ),
      ],
    );
  }

  // Scratched Card Content (Revealed)
  Widget _scratchedCardContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(
              'assets/images/congratulations.png'), // Background Image
          fit: BoxFit.cover, // Cover entire card
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 54),
          Text(
            "₹50",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "cashback",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
