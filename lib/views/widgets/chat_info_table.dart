import 'package:flutter/material.dart';
import '../../logic/stock_tips_logic.dart';
import '../../models/stock_tips_model.dart';

class StockTipsTable extends StatefulWidget {
  final List<UniqueChats> chatInfoList;

  const StockTipsTable({super.key, required this.chatInfoList});

  @override
  _StockTipsTableState createState() => _StockTipsTableState();
}

class _StockTipsTableState extends State<StockTipsTable> {
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  String _searchQuery = '';
  bool _sebiFilter = false;
  String? _selectedPeriod;
  String? _selectedCategory;

  List<UniqueChats> get _filteredChats {
    return StockTipsLogic.filterChats(
      chatInfoList: widget.chatInfoList,
      searchQuery: _searchQuery,
      sebiFilter: _sebiFilter,
      selectedPeriod: _selectedPeriod,
      selectedCategory: _selectedCategory,
    );
  }

  List<UniqueChats> get _paginatedChats {
    return StockTipsLogic.paginateChats(
      filteredChats: _filteredChats,
      currentPage: _currentPage,
      itemsPerPage: _itemsPerPage,
    );
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _filteredChats.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Script',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _currentPage = 0;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('SEBI REG'),
                  SizedBox(width: 10),
                  Switch(
                    value: _sebiFilter,
                    onChanged: (bool newValue) {
                      setState(() {
                        _sebiFilter = newValue;
                        _currentPage = 0;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Period'),
                        value: _selectedPeriod,
                        padding: EdgeInsets.only(left: 12, right: 5),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPeriod = newValue;
                            _currentPage = 0;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text('Select Period'),
                          ),
                          ...widget.chatInfoList.expand((chat) => chat.period ?? []).toSet().map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ],
                        underline: SizedBox.shrink(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Category'),
                        value: _selectedCategory,
                        padding: EdgeInsets.only(left: 12, right: 5),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                            _currentPage = 0;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text('Select Category'),
                          ),
                          ...widget.chatInfoList.expand((chat) => chat.category ?? []).toSet().map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ],
                        underline: SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowHeight: 40,
              dataRowHeight: 60,
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade900),
              columns: const [
                DataColumn(label: _HeaderText('Sr.No')),
                DataColumn(label: _HeaderText('SCRIPT')),
                DataColumn(label: _HeaderText('Channel')),
                DataColumn(label: _HeaderText('SEBI REG')),
                DataColumn(label: _HeaderText('CATEGORY')),
                DataColumn(label: _HeaderText('PERIOD')),
                DataColumn(label: _HeaderText('TELEGRAM ID')),
                DataColumn(label: _HeaderText('AVERAGE VIEWS')),
                DataColumn(label: _HeaderText('PARTICIPANTS')),
                DataColumn(label: _HeaderText('TARGET')),
                DataColumn(label: _HeaderText('VERIFIED')),
              ],
              rows: _paginatedChats.asMap().entries.map((entry) {
                final index = entry.key;
                final chat = entry.value;
                return DataRow(cells: [
                  DataCell(Center(child: Text('${index + 1 + _currentPage * _itemsPerPage}'))),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.title ?? 'N/A',
                            style: _boldStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text('FUT', style: _subStyle),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        chat.about ?? 'N/A',
                        style: _boldStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  DataCell(_SebiRegCell(chat.sebiRegistered ?? false)),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Text(
                        chat.category?.join(', ') ?? 'N/A',
                        style: _boldStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Text(
                        chat.period?.join(', ') ?? 'N/A',
                        style: _boldStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  DataCell(Center(child: Text(chat.telegramId?.toString() ?? 'N/A'))),
                  DataCell(_PriceDateCell(
                    chat.averageViews?.toString() ?? 'N/A',
                    StockTipsLogic.formatDate(chat.creationDate),
                  )),
                  DataCell(_PriceDateCell(
                    chat.participants?.toString() ?? 'N/A',
                    StockTipsLogic.formatDate(chat.creationDate),
                  )),
                  DataCell(Center(child: Text('N/A'))),
                  DataCell(Center(child: Text(chat.verified == true ? 'Yes' : 'No'))),
                ]);
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousPage,
              ),
              Text('Page ${_currentPage + 1} of ${(_filteredChats.length / _itemsPerPage).ceil()}'),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextPage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDropdown({
    required String hint,
    required String? value,
    required void Function(String?) onChanged,
    required Iterable<String?> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        hint: Text(hint),
        value: value,
        padding: EdgeInsets.only(left: 12, right: 5),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: SizedBox.shrink(),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _SebiRegCell extends StatelessWidget {
  final bool isRegistered;
  const _SebiRegCell(this.isRegistered);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        isRegistered ? Icons.check_circle : Icons.cancel,
        color: isRegistered ? Colors.green : Colors.red,
      ),
    );
  }
}

class _PriceDateCell extends StatelessWidget {
  final String value;
  final String date;
  const _PriceDateCell(this.value, this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: _boldStyle),
        Text(date, style: _subStyle),
      ],
    );
  }
}

const TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);
const TextStyle _subStyle = TextStyle(fontSize: 12, color: Colors.grey);
