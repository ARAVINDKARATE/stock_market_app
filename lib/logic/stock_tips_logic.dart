import 'package:intl/intl.dart';
import '../../models/stock_tips_model.dart';

class StockTipsLogic {
  static List<UniqueChats> filterChats({
    required List<UniqueChats> chatInfoList,
    required String searchQuery,
    required bool sebiFilter,
    String? selectedPeriod,
    String? selectedCategory,
  }) {
    return chatInfoList.where((chat) {
      final matchesSearch = chat.title?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
      final matchesSebi = !sebiFilter || (chat.sebiRegistered ?? false);
      final matchesPeriod = selectedPeriod == null || (chat.period?.contains(selectedPeriod) ?? false);
      final matchesCategory = selectedCategory == null || (chat.category?.contains(selectedCategory) ?? false);
      return matchesSearch && matchesSebi && matchesPeriod && matchesCategory;
    }).toList();
  }

  static List<UniqueChats> paginateChats({
    required List<UniqueChats> filteredChats,
    required int currentPage,
    required int itemsPerPage,
  }) {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredChats.sublist(startIndex, endIndex > filteredChats.length ? filteredChats.length : endIndex);
  }

  static String formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }
}
