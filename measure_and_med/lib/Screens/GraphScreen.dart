// import 'package:flutter/material.dart';
// import 'package:flutter_charts/flutter_charts.dart';

// class GraphScreen extends StatefulWidget {
//   final List<DataPoint> data;

//   GraphScreen({Key? key, required this.data}) : super(key: key);

//   @override
//   _GraphScreenState createState() => _GraphScreenState();
// }

// class _GraphScreenState extends State<GraphScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Temperature Graph'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: LineChart(
//                 data: widget.data,
//                 grid: SimpleGrid(),
//                 chartLegendSpacing: 48.0,
//                 chartPadding: EdgeInsets.all(32.0),
//                 useUserProvidedYLabels: true,
//                 chartScale: 0.75,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DataPoint {
//   final double x;
//   final double y;

//   DataPoint({required this.x, required this.y});
// }
