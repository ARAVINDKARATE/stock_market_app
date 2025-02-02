import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/stock_tips_model.dart'; // Make sure this import is correct

class StockService {
  static const String baseUrl = "https://nodeapi.finosauras.com/api/stock-info/";

  Future<StockTips?> fetchStockTips(String ticker) async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}getTips?ticker=$ticker"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return StockTips.fromJson(data); // Assuming StockTips.fromJson handles the correct structure
      } else {
        log("Failed to load stock tips: ${response.statusCode} - ${response.body}"); // log status code and body for debugging
        throw Exception("Failed to load stock tips");
      }
    } catch (e) {
      log("Error fetching stock tips: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchStockDetails(String ticker) async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}getStock?ticker=$ticker"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        log("Failed to load stock details: ${response.statusCode} - ${response.body}"); // log status code and body for debugging
        throw Exception("Failed to load stock details");
      }
    } catch (e) {
      log("Error fetching stock details: $e");
      return null;
    }
  }

  // Fetch OHLC data
  Future<Map<String, dynamic>?> fetchStockOHLCData(String ticker) async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}ohlc?symbol=$ticker&interval=1d"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        log(data.toString());
        return data;
      } else {
        log("Failed to load OHLC data: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to load OHLC data");
      }
    } catch (e) {
      log("Error fetching OHLC data: $e");
      return null;
    }
  }
}
