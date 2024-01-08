import 'package:custom_graph/custom_graph.dart';
import 'package:custom_graph/models/data_model.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {


  final List<DataModel> dataSet = [
    DataModel(0.20, 'A', Colors.red),
    DataModel(0.20, 'B', Colors.brown),
    DataModel(0.30, 'C', Colors.green),
    DataModel(0.20, 'D', Colors.lime),
    DataModel(0.10, 'E', Colors.blue),
  ];


  @override
  Widget build(BuildContext context) {
    return PieChart(dataSet: dataSet);
  }
}
