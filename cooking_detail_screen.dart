import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../widgets/floating_timer.dart';
import '../widgets/glass_container.dart';
import 'plating_showcase_screen.dart';

class CookingDetailScreen extends StatefulWidget {
  static const String routeName = '/detail';
  final Recipe recipe;

  const CookingDetailScreen({super.key, required this.recipe});

  @override
  State<CookingDetailScreen> createState() => _CookingDetailScreenState();
}

class _CookingDetailScreenState extends State<CookingDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  void _toggleStep(CookingStep step) {
    setState(() {
      step.isCompleted = !step.isCompleted;
    });

    if (widget.recipe.isAllCompleted) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(
          PlatingShowcaseScreen.routeName,
          arguments: widget.recipe,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.recipe.progressRatio;
    final completedCount = widget.recipe.steps.where((s) => s.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF090D14),
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  widget.recipe.title,
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              // Clean Header (Replaced 3D Pot and Debug Text)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131A26),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.recipe.description,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROGRESS: ${(progress * 100).toInt()}% COMPLETED',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: progress == 1.0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        '$completedCount of ${widget.recipe.steps.length} Steps Done',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final step = widget.recipe.steps[index];
                      return _buildSlidableStepItem(step, index);
                    },
                    childCount: widget.recipe.steps.length,
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: FloatingGlassTimer(
              initialMinutes: widget.recipe.steps.isNotEmpty
                  ? widget.recipe.steps.first.durationMinutes
                  : 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidableStepItem(CookingStep step, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(step.id),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          dismissible: null,
          children: [
            SlidableAction(
              onPressed: (_) => _toggleStep(step),
              backgroundColor: step.isCompleted
                  ? const Color(0xFF64748B)
                  : const Color(0xFF10B981),
              foregroundColor: Colors.white,
              icon: step.isCompleted ? Icons.undo_rounded : Icons.check_circle_rounded,
              label: step.isCompleted ? 'Undo' : 'Complete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => _toggleStep(step),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: step.isCompleted
                  ? const Color(0xFF10B981).withOpacity(0.12)
                  : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: step.isCompleted
                    ? const Color(0xFF10B981).withOpacity(0.4)
                    : Colors.white.withOpacity(0.08),
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isCompleted
                        ? const Color(0xFF10B981)
                        : Colors.white.withOpacity(0.08),
                  ),
                  child: Center(
                    child: step.isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                        : Text(
                            '${step.order}',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.instruction,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: step.isCompleted
                              ? const Color(0xFF94A3B8)
                              : Colors.white,
                          decoration: step.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: const Color(0xFF10B981),
                          height: 1.45,
                        ),
                      ),
                      if (step.tip != null && step.tip!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Icon(Icons.lightbulb_outline_rounded,
                                    size: 13, color: Color(0xFFF59E0B)),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  step.tip!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: const Color(0xFFF59E0B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}