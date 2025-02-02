import 'package:flutter/material.dart';
import '../models/stock_tips_model.dart';
import '../services/stock_services.dart';
import 'widgets/chat_info_table.dart';
import 'widgets/stock_info_card.dart';
import 'widgets/stock_price_chart.dart';

class StockHomeScreen extends StatefulWidget {
  const StockHomeScreen({Key? key}) : super(key: key);

  @override
  State<StockHomeScreen> createState() => _StockHomeScreenState();
}

class _StockHomeScreenState extends State<StockHomeScreen> {
  final StockService stockService = StockService();
  late Future<StockTips?> futureStockTips;
  late Future<Map<String, dynamic>?> futureStockDetails;

  @override
  void initState() {
    super.initState();
    futureStockTips = stockService.fetchStockTips("DIXON");
    futureStockDetails = stockService.fetchStockDetails("DIXON");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStockContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.blue[900],
      pinned: true,
      expandedHeight: 60.0,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('Finosauras'),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStockContent() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Home > Stocks > DIXON', style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          FutureBuilder<Map<String, dynamic>?>(
            // Stock details FutureBuilder
            future: futureStockDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text("No data available");
              }

              final stockDetails = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<StockTips?>(
                    future: futureStockTips,
                    builder: (context, stockTipsSnapshot) {
                      if (stockTipsSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (stockTipsSnapshot.hasError) {
                        return Text("Error: ${stockTipsSnapshot.error}");
                      } else if (!stockTipsSnapshot.hasData || stockTipsSnapshot.data == null) {
                        return const Text("No data available");
                      }

                      final stockTips = stockTipsSnapshot.data!;
                      return StockInfoCard(
                        stockDetails: stockDetails,
                        stockTips: stockTips,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const StockPriceChart(),
                  const SizedBox(height: 20),
                  const Text('Telegram Chat Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  FutureBuilder<StockTips?>(
                    // Stock tips table
                    future: futureStockTips,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text("No data available");
                      }

                      StockTips stockTips = snapshot.data!;
                      return SizedBox(
                        height: 900, // Add height constraint
                        child: StockTipsTable(chatInfoList: stockTips.uniqueChats ?? []),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
