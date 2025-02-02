import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/stock_tips_model.dart';

class StockInfoCard extends StatelessWidget {
  final Map<String, dynamic> stockDetails;
  final StockTips stockTips;

  const StockInfoCard({
    super.key,
    required this.stockDetails,
    required this.stockTips,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${stockDetails['stockName']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SvgPicture.network(
              stockDetails['imgUrl'],
              placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              'Stock Value: ${stockDetails['value']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Stock Price: ${stockDetails['stockPrice']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stock Tips Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStockTipColumn('Unique Channels', stockTips.uniqueChannelCount),
                _buildStockTipColumn('Total Trades', stockTips.totalTrades),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStockTipColumn('Win Count', stockTips.winCount),
                _buildStockTipColumn('Loss Count', stockTips.lossCount),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStockTipColumn('Buy Count', stockTips.buyCount),
                _buildStockTipColumn('Sell Count', stockTips.sellCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockTipColumn(String title, int? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          '${value ?? 0}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
