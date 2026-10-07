import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/glass_container.dart';
import 'cooking_detail_screen.dart';

class GenerateRecipeScreen extends StatefulWidget {
  static const String routeName = '/generate';
  const GenerateRecipeScreen({super.key});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen>
    with SingleTickerProviderStateMixin {
  final _dishController = TextEditingController();
  String _selectedStyle = 'Universal / Any Cuisine';
  bool _isGenerating = false;

  final List<String> _styles = [
    'Universal / Any Cuisine',
    'North Indian Traditional',
    'Maharashtrian Street',
    'South Indian Classic',
    'Gujarati Special',
    'Mughlai Royal',
  ];

  @override
  void dispose() {
    _dishController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerateRecipe() async {
    final dishName = _dishController.text.trim();
    if (dishName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a dish name to generate.')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final apiService = ApiService();

      final newRecipe = await apiService.generateRecipe(
        dishName: dishName,
        style: _selectedStyle,
      );

      if (!mounted) return;

      Provider.of<RecipeProvider>(context, listen: false).addGeneratedRecipe(newRecipe);

      Navigator.of(context).pushReplacementNamed(
        CookingDetailScreen.routeName,
        arguments: newRecipe,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating recipe: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI Culinary Generator',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What do you wish to cook?',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ChefSync will formulate an authentic step-by-step checklist and precise timing.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('DISH OR RECIPE NAME'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _dishController,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. Vada Pav, Truffle Pasta, Ramen...',
                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white30),
                    prefixIcon: const Icon(Icons.restaurant_menu_rounded, color: Color(0xFFF59E0B)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('REGIONAL STYLE & HERITAGE'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _styles.map((style) {
                  final isSelected = _selectedStyle == style;
                  return ChoiceChip(
                    label: Text(style),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedStyle = style);
                    },
                    selectedColor: const Color(0xFFF59E0B),
                    backgroundColor: Colors.white.withOpacity(0.05),
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.white70,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFF59E0B) : Colors.white.withOpacity(0.08),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _isGenerating ? 54 : MediaQuery.of(context).size.width - 40,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(_isGenerating ? 27 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(_isGenerating ? 27 : 16),
                      onTap: _isGenerating ? null : _handleGenerateRecipe,
                      child: Center(
                        child: _isGenerating
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(Colors.black87),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.bolt_rounded, color: Colors.black, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Generate Authentic Recipe',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        letterSpacing: 0.8,
      ),
    );
  }
}