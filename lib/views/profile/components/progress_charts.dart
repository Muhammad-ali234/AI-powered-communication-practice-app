import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/chat_controller.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';
import 'dart:math' as math;

class ProgressCharts extends StatelessWidget {
  const ProgressCharts({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return SingleChildScrollView(
      padding: responsive.responsivePadding(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: responsive.fontSize(24),
            ),
          ),
          SizedBox(height: responsive.lg),
          _buildScoreChart(context, responsive),
          SizedBox(height: responsive.xl),
          _buildCategoryDistributionChart(context, responsive),
          SizedBox(height: responsive.xl),
          _buildWeeklyActivityChart(context, responsive),
        ],
      ),
    );
  }
  
  Widget _buildScoreChart(BuildContext context, ResponsiveUtil responsive) {
    final chatController = Provider.of<ChatController>(context);
    final conversations = chatController.getConversationHistorySorted();
    final completedConversations = conversations.where((c) => c.isCompleted && c.score != null).toList();
    
    if (completedConversations.isEmpty) {
      return _buildEmptyChartCard(
        context,
        responsive,
        'Score Progress',
        'Complete conversations to see your score progress',
      );
    }
    
    // Take last 10 conversations or less
    final recentConversations = completedConversations.take(10).toList();
    recentConversations.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      elevation: 1,
      child: Padding(
        padding: responsive.responsivePadding(all: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: responsive.fontSize(18),
              ),
            ),
            SizedBox(height: responsive.md),
            SizedBox(
              height: responsive.isSmallScreen ? 180 : 220,
              child: CustomPaint(
                size: Size(double.infinity, responsive.isSmallScreen ? 160 : 200),
                painter: ScoreChartPainter(
                  conversations: recentConversations,
                  lineColor: AppColors.primary,
                  pointColor: AppColors.secondary,
                  textColor: Theme.of(context).brightness == Brightness.light
                      ? AppColors.textSecondary
                      : AppColors.darkTextSecondary,
                  responsive: responsive,
                ),
              ),
            ),
            SizedBox(height: responsive.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: responsive.sm * 1.5,
                  height: responsive.sm * 1.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: responsive.xs),
                Text(
                  'Score (out of 5)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: responsive.fontSize(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryDistributionChart(BuildContext context, ResponsiveUtil responsive) {
    final chatController = Provider.of<ChatController>(context);
    final conversations = chatController.conversations;
    
    if (conversations.isEmpty) {
      return _buildEmptyChartCard(
        context,
        responsive,
        'Category Distribution',
        'Complete conversations in different categories to see your distribution',
      );
    }
    
    // Group by category
    final Map<String, int> categoryCount = {};
    for (var conversation in conversations) {
      categoryCount[conversation.categoryId] = 
          (categoryCount[conversation.categoryId] ?? 0) + 1;
    }
    
    final categoryColors = {
      '1': AppColors.primary,
      '2': AppColors.secondary,
      '3': AppColors.accent,
    };
    
    final categoryNames = {
      '1': 'Job Interviews',
      '2': 'Public Speaking',
      '3': 'Social Situations',
    };
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      elevation: 1,
      child: Padding(
        padding: responsive.responsivePadding(all: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: responsive.fontSize(18),
              ),
            ),
            SizedBox(height: responsive.md),
            SizedBox(
              height: responsive.isSmallScreen ? 200 : 220,
              child: responsive.isSmallScreen
                  ? _buildVerticalCategoryChart(context, responsive, categoryCount, categoryColors, categoryNames)
                  : _buildHorizontalCategoryChart(context, responsive, categoryCount, categoryColors, categoryNames),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHorizontalCategoryChart(
    BuildContext context,
    ResponsiveUtil responsive,
    Map<String, int> categoryCount,
    Map<String, Color> categoryColors,
    Map<String, String> categoryNames,
  ) {
    return Row(
      children: [
        SizedBox(
          width: responsive.isLargeScreen ? 180 : 150,
          height: responsive.isLargeScreen ? 180 : 150,
          child: CustomPaint(
            painter: PieChartPainter(
              categories: categoryCount.keys.toList(),
              values: categoryCount.values.toList(),
              colors: categoryCount.keys
                  .map((k) => categoryColors[k] ?? Colors.grey)
                  .toList(),
            ),
          ),
        ),
        SizedBox(width: responsive.md),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryCount.keys.map((categoryId) {
              final count = categoryCount[categoryId] ?? 0;
              final total = categoryCount.values.fold(0, (sum, val) => sum + val);
              final percentage = (count / total * 100).round();
              final color = categoryColors[categoryId] ?? Colors.grey;
              final name = categoryNames[categoryId] ?? 'Unknown';
              
              return Padding(
                padding: EdgeInsets.only(bottom: responsive.sm),
                child: Row(
                  children: [
                    Container(
                      width: responsive.md,
                      height: responsive.md,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    SizedBox(width: responsive.sm),
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.fontSize(14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildVerticalCategoryChart(
    BuildContext context,
    ResponsiveUtil responsive,
    Map<String, int> categoryCount,
    Map<String, Color> categoryColors,
    Map<String, String> categoryNames,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: PieChartPainter(
              categories: categoryCount.keys.toList(),
              values: categoryCount.values.toList(),
              colors: categoryCount.keys
                  .map((k) => categoryColors[k] ?? Colors.grey)
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: responsive.md),
        Expanded(
          child: Column(
            children: categoryCount.keys.map((categoryId) {
              final count = categoryCount[categoryId] ?? 0;
              final total = categoryCount.values.fold(0, (sum, val) => sum + val);
              final percentage = (count / total * 100).round();
              final color = categoryColors[categoryId] ?? Colors.grey;
              final name = categoryNames[categoryId] ?? 'Unknown';
              
              return Padding(
                padding: EdgeInsets.only(bottom: responsive.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.sm,
                      height: responsive.sm,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    SizedBox(width: responsive.xs),
                    Text(
                      '$name $percentage%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: responsive.fontSize(12),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildWeeklyActivityChart(BuildContext context, ResponsiveUtil responsive) {
    final userController = Provider.of<UserController>(context);
    final chatController = Provider.of<ChatController>(context);
    
    if (userController.user == null || chatController.conversations.isEmpty) {
      return _buildEmptyChartCard(
        context,
        responsive,
        'Weekly Activity',
        'Complete conversations on different days to see your activity pattern',
      );
    }
    
    final conversations = chatController.conversations;
    
    // Group conversations by day of week
    final Map<int, int> dayCount = {
      1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0,
    };
    
    for (var conversation in conversations) {
      // Adjust weekday to make Monday = 1, Sunday = 7
      final weekday = conversation.createdAt.weekday;
      dayCount[weekday] = (dayCount[weekday] ?? 0) + 1;
    }
    
    final dayNames = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      elevation: 1,
      child: Padding(
        padding: responsive.responsivePadding(all: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: responsive.fontSize(18),
              ),
            ),
            SizedBox(height: responsive.md),
            SizedBox(
              height: responsive.isSmallScreen ? 180 : 220,
              child: Column(
                children: [
                  Expanded(
                    child: BarChart(
                      dayCount: dayCount,
                      dayNames: dayNames,
                      responsive: responsive,
                    ),
                  ),
                  SizedBox(height: responsive.md),
                  Text(
                    'Most active on: ${_getMostActiveDayName(dayCount, dayNames)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getMostActiveDayName(Map<int, int> dayCount, Map<int, String> dayNames) {
    int maxDay = 1;
    int maxCount = 0;
    
    dayCount.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        maxDay = day;
      }
    });
    
    return dayNames[maxDay] ?? 'Unknown';
  }
  
  Widget _buildEmptyChartCard(BuildContext context, ResponsiveUtil responsive, String title, String message) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      elevation: 1,
      child: Padding(
        padding: responsive.responsivePadding(all: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: responsive.fontSize(18),
              ),
            ),
            SizedBox(height: responsive.md),
            SizedBox(
              height: responsive.isSmallScreen ? 160 : 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_chart_outlined,
                      size: responsive.iconSize(64),
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: responsive.md),
                    Padding(
                      padding: responsive.responsivePadding(horizontal: 16),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreChartPainter extends CustomPainter {
  final List<ConversationModel> conversations;
  final Color lineColor;
  final Color pointColor;
  final Color textColor;
  final ResponsiveUtil responsive;
  
  ScoreChartPainter({
    required this.conversations,
    required this.lineColor,
    required this.pointColor,
    required this.textColor,
    required this.responsive,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final strokeWidth = responsive.isSmallScreen ? 2.0 : 3.0;
    final pointRadius = responsive.isSmallScreen ? 4.0 : 6.0;
    
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final pointPaint = Paint()
      ..color = pointColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // Draw horizontal lines and labels
    for (int i = 0; i <= 5; i++) {
      final y = height - (height * i / 5);
      
      canvas.drawLine(
        Offset(0, y),
        Offset(width, y),
        Paint()
          ..color = textColor.withOpacity(0.2)
          ..strokeWidth = 1,
      );
      
      // Draw score label
      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: textColor,
          fontSize: responsive.fontSize(10),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-15, y - textPainter.height / 2));
    }
    
    if (conversations.isEmpty) {
      return;
    }
    
    final segmentWidth = width / (conversations.length - 1).clamp(1, double.infinity);
    final path = Path();
    
    for (int i = 0; i < conversations.length; i++) {
      final conversation = conversations[i];
      final x = i * segmentWidth;
      final y = height - (height * (conversation.score ?? 0) / 5);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // Draw points
      canvas.drawCircle(Offset(x, y), pointRadius, pointPaint);
      canvas.drawCircle(
        Offset(x, y),
        pointRadius - 2,
        Paint()..color = Colors.white,
      );
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PieChartPainter extends CustomPainter {
  final List<String> categories;
  final List<int> values;
  final List<Color> colors;
  
  PieChartPainter({
    required this.categories,
    required this.values,
    required this.colors,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    var total = 0;
    for (var value in values) {
      total += value;
    }
    
    if (total == 0) return;
    
    var startAngle = -math.pi / 2;
    
    for (int i = 0; i < categories.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
    
    // Draw center circle for donut effect
    canvas.drawCircle(
      center,
      radius * 0.6,
      Paint()..color = Colors.white,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BarChart extends StatelessWidget {
  final Map<int, int> dayCount;
  final Map<int, String> dayNames;
  final ResponsiveUtil responsive;
  
  const BarChart({
    super.key,
    required this.dayCount,
    required this.dayNames,
    required this.responsive,
  });
  
  @override
  Widget build(BuildContext context) {
    final maxCount = dayCount.values.isEmpty
        ? 1
        : dayCount.values.reduce(math.max).clamp(1, double.infinity);
    
    final barWidth = responsive.isSmallScreen ? 20.0 : 24.0;
    final maxBarHeight = responsive.isSmallScreen ? 100.0 : 120.0;
    
    return Padding(
      padding: responsive.responsivePadding(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: dayCount.keys.map((day) {
          final count = dayCount[day] ?? 0;
          final heightPercentage = count / maxCount;
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: barWidth,
                height: maxBarHeight * heightPercentage,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(responsive.xs),
                ),
                child: count > 0
                    ? Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.fontSize(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(height: responsive.sm),
              Text(
                dayNames[day] ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: responsive.fontSize(12),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}