# Stock Market Tips — Flutter

A Flutter screen for browsing stock tips alongside their price history.

## Features

- Stock tip cards with the key figures surfaced (`stock_info_card`)
- Price history rendered with `fl_chart` (`stock_price_chart`)
- Tabular breakdown via `chat_info_table`
- SVG iconography (`flutter_svg`), numbers and dates formatted with `intl`

## Structure

```
lib/
├── models/stock_tips_model.dart
├── services/stock_services.dart     # data access
├── logic/stock_tips_logic.dart      # derived values, kept out of the widgets
└── views/
    ├── home_screen.dart
    └── widgets/  stock_info_card · stock_price_chart · chat_info_table
```

Presentation logic lives in `logic/`, so `home_screen.dart` stays a layout file
and the chart/table widgets stay reusable.

## Running

```bash
flutter pub get
flutter run
```

## Stack

Flutter · Dart · fl_chart · flutter_svg · intl
