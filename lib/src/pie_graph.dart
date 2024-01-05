import 'dart:async';
import 'dart:math';
import 'package:custom_graph/models/data_model.dart';
import 'package:flutter/material.dart';

class PieChart extends StatefulWidget {
  final List<DataModel> dataSet;

  const PieChart({super.key, required this.dataSet});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  late Timer timer;
  double fullAngle = 0.0;
  double secondsToComplete = 5.0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        fullAngle += 360 / (secondsToComplete * 1000 ~/ 60);
        if (fullAngle >= 360.0) {
          timer.cancel();
          fullAngle = 360.0;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie Chart'),
      ),
      body: CustomPaint(
        painter: PieChartPainter(widget.dataSet, fullAngle),
        child: Container(),
      ),
    );
  }
}

final lineBg = Paint()
  ..color = Colors.black
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2.0;
final midPaint = Paint()
  ..color = Colors.white24
  ..style = PaintingStyle.fill;

const textFieldTextBigStyle = TextStyle(
    color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 30.0);

const labelStyle = TextStyle(color: Colors.black, fontSize: 12.0);

class PieChartPainter extends CustomPainter {
  final List<DataModel> dataSet;
  final double fullAngle;

  PieChartPainter(this.dataSet, this.fullAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    var startAngle = 0.0;
    final radius = size.width * 0.9;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);
    canvas.drawArc(rect, startAngle, fullAngle * pi / 180.0, false, lineBg);
    for (var element in dataSet) {
      final sweepAngle = element.value! * fullAngle * pi / 180.0;
      drawSectors(element, canvas, rect, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }
    startAngle = 0.0;
    for (var element in dataSet) {
      final sweepAngle = element.value! * fullAngle * pi / 180.0;
      drawLines(radius, startAngle, c, canvas);
      startAngle += sweepAngle;
    }
    startAngle = 0.0;
    for (var element in dataSet) {
      final sweepAngle = element.value! * fullAngle * pi / 180.0;
      drawLabels(canvas, c, radius, startAngle, sweepAngle, element.label);
      startAngle += sweepAngle;
    }
    canvas.drawCircle(c, radius * 0.3, midPaint);
  }

  void drawLines(double radius, double startAngle, Offset c, Canvas canvas) {
    final dx = radius / 2.0 * cos(startAngle);
    final dy = radius / 2.0 * sin(startAngle);
    final p2 = c + Offset(dx, dy);

    canvas.drawLine(c, p2, lineBg);
  }

  TextPainter textPainter(
      String s, TextStyle style, double maxWidth, TextAlign align) {
    final span = TextSpan(
      text: s,
      style: style,
    );
    final tp = TextPainter(
        text: span, textAlign: align, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  Size drawText(Canvas canvas, Offset position, String s, TextStyle style,
      double maxWidth, Function(Size z) bgCb) {
    final tp = textPainter(s, style, maxWidth, TextAlign.center);
    final pos = position + Offset(-tp.width / 2.0, -tp.height / 2.0);
    bgCb(tp.size);
    tp.paint(canvas, pos);
    return tp.size;
  }

  double drawSectors(DataModel element, Canvas canvas, Rect rect,
      double startAngle, double sweepAngle) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = element.color!;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
    return sweepAngle;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawLabels(Canvas canvas, Offset c, double radius, double startAngle,
      double sweepAngle, String? label) {
    final r = radius * 0.4;
    final dx = r * cos(startAngle + sweepAngle / 2.0);
    final dy = r * sin(startAngle + sweepAngle / 2.0);
    final position = c + Offset(dx, dy);
    drawText(canvas, position, label!, labelStyle, 100.0, (Size z) {
      final rect = Rect.fromCenter(
          center: position, width: z.width + 5, height: z.height + 5);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));
      canvas.drawRRect(rrect, midPaint);
    });
  }
}