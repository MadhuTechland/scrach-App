import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/notification_screen.dart';
import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';

class CardStatisticsScreen extends StatefulWidget {
  const CardStatisticsScreen({super.key});

  @override
  State<CardStatisticsScreen> createState() => _CardStatisticsScreenState();
}

class _CardStatisticsScreenState extends State<CardStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScratchCardController>();
    final authController = Get.find<AuthController>();
    final userId = authController.user?.id;

    if (userId != null) {
      controller.loadScratchCards(userId);
    }

    final media = MediaQuery.of(context).size;
    final height = media.height;
    final width = media.width;

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.yellowAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
        );
      }

      final totalCards = controller.totalCards;
      final usedCards = controller.scratchedCards.length;
      final availableCards = controller.unscratchedCards.length;

      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            if (userId != null) {
              controller.loadScratchCards(userId);
              _animationController.reset();
              _animationController.forward();
            }
          },
          child: Stack(
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
                    height: height * 0.18,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.025,
                    ),
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
                        SizedBox(height: height * 0.0625),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            Text(
                              "Card Statistics",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 40), 
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Statistics Cards
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            // Total Cards Designed
                            _buildStatCard(
                              context,
                              icon: Icons.credit_card,
                              title: "Total Cards Designed",
                              count: totalCards,
                              color: Colors.purple,
                              delay: 0,
                            ),
                            const SizedBox(height: 20),

                            // Cards Used
                            _buildStatCard(
                              context,
                              icon: Icons.check_circle,
                              title: "Cards Used",
                              count: usedCards,
                              color: Colors.green,
                              delay: 100,
                            ),
                            const SizedBox(height: 20),

                            // Cards Available
                            _buildStatCard(
                              context,
                              icon: Icons.card_giftcard,
                              title: "Cards Available",
                              count: availableCards,
                              color: Colors.orange,
                              delay: 200,
                            ),
                            const SizedBox(height: 30),

                            // Progress Bar Card
                            _buildProgressCard(
                              context,
                              totalCards: totalCards,
                              usedCards: usedCards,
                              availableCards: availableCards,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Card(
            elevation: 8,
            shadowColor: color.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TweenAnimationBuilder<int>(
                          duration: Duration(milliseconds: 1000 + delay),
                          tween: IntTween(begin: 0, end: count),
                          builder: (context, value, child) {
                            return Text(
                              '$value',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required int totalCards,
    required int usedCards,
    required int availableCards,
  }) {
    final usedPercentage = totalCards > 0 ? (usedCards / totalCards) : 0.0;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Card(
            elevation: 8,
            shadowColor: Colors.blue.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Usage Overview",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1200),
                      tween: Tween(begin: 0.0, end: usedPercentage),
                      curve: Curves.easeOutCubic,
                      builder: (context, animValue, child) {
                        return LinearProgressIndicator(
                          value: animValue,
                          minHeight: 20,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            usedPercentage > 0.7
                                ? Colors.red
                                : usedPercentage > 0.4
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Percentage Text
                  Text(
                    "${(usedPercentage * 100).toStringAsFixed(1)}% Cards Used",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}