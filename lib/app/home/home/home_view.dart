import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/home_controller.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';
import 'package:nj_pizza_delivery/constants/images_files.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();
    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      backgroundColor: const Color(0xFFFDFAF5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            _pizzaSliderCard(),
            const SizedBox(height: 30),
            _features(),
            const SizedBox(height: 40),
            _orderNow(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Pizza Hub 🍕",
              style: GoogleFonts.playfairDisplay(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Build your pizza with live animation",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── CARD ─────────────────
  Widget _pizzaSliderCard() {
    return Obx(() {
      return GestureDetector(
        onTap: controller.goToPizzaSlider,
        child: AnimatedScale(
          scale: controller.cardScale.value,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -10,
                  child: Image.asset(ImagesFiles.fullPizza, height: 190),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Your Pizza",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Choose toppings, size &\nwatch it live",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Start ➜",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ───────────────── FEATURES ─────────────────
  Widget _features() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why Pizza Hub?",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              _Feature(icon: Icons.local_fire_department, text: "Fresh"),
              SizedBox(width: 12),
              _Feature(icon: Icons.delivery_dining, text: "Fast"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _Feature(icon: Icons.security, text: "Safe"),
              SizedBox(width: 12),
              _Feature(icon: Icons.star, text: "Top Rated"),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── CTA ─────────────────
  Widget _orderNow() {
    return ElevatedButton(
      onPressed: controller.goToPizzaSlider,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
      ),
      child: Text(
        "Order Now 🍕",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ───────────────── FEATURE CARD ─────────────────
class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepOrange, size: 30),
            const SizedBox(height: 8),
            Text(text, style: GoogleFonts.poppins(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
