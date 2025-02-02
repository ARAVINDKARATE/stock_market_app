import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/stock_services.dart';

class StockPriceChart extends StatefulWidget {
  const StockPriceChart({super.key});

  @override
  _StockPriceChartState createState() => _StockPriceChartState();
}

class _StockPriceChartState extends State<StockPriceChart> {
  late Future<Map<String, dynamic>?> futureChartData;
  final StockService stockService = StockService();

  @override
  void initState() {
    super.initState();
    futureChartData = stockService.fetchStockOHLCData("DIXON");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: futureChartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text("No chart data available");
        }

        final data = snapshot.data!;
        final ohlcData = data['data']['data']?['NSE_EQ:DIXON']?['ohlc'];
        if (ohlcData == null) {
          return _buildFallbackChart(data);
        }

        List<ChartData> chartData = [
          ChartData(
            date: DateTime.now(),
            open: (ohlcData['open'] is int) ? (ohlcData['open'] as int).toDouble() : ohlcData['open'],
            high: (ohlcData['high'] is int) ? (ohlcData['high'] as int).toDouble() : ohlcData['high'],
            low: (ohlcData['low'] is int) ? (ohlcData['low'] as int).toDouble() : ohlcData['low'],
            close: (ohlcData['close'] is int) ? (ohlcData['close'] as int).toDouble() : ohlcData['close'],
          ),
        ];

        return _buildChartWithData(chartData, data);
      },
    );
  }

  Widget _buildFallbackChart(Map<String, dynamic> data) {
    final lastPrice = data['data']?['NSE_EQ:DIXON']?['last_price'] ?? 'N/A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dixon Technologies Ltd Price Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            '02/02/2025, 16:51:33',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            'Last Price: $lastPrice',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            width: 400,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: 0,
                        color: Colors.grey,
                        width: 6,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartWithData(List<ChartData> chartData, Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dixon Technologies Ltd Price Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            chartData[0].date.toString(),
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 400,
            height: 300,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                barGroups: chartData.map((dataPoint) {
                  double validHigh = dataPoint.high.isFinite ? dataPoint.high : 0.0;
                  double validLow = dataPoint.low.isFinite ? dataPoint.low : 0.0;
                  double validClose = dataPoint.close.isFinite ? dataPoint.close : 0.0;
                  double validOpen = dataPoint.open.isFinite ? dataPoint.open : 0.0;

                  int validX = (dataPoint.date.millisecondsSinceEpoch).isFinite ? dataPoint.date.millisecondsSinceEpoch : 0;

                  return BarChartGroupData(
                    x: validX,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: validHigh,
                        color: validClose > validOpen ? Colors.green : Colors.red,
                        width: 6,
                      ),
                      BarChartRodData(
                        fromY: 0,
                        toY: validLow,
                        color: Colors.black,
                        width: 6,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  ChartData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}
