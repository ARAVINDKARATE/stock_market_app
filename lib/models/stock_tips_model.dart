class StockTips {
  int? uniqueChannelCount;
  int? winCount;
  int? lossCount;
  int? buyCount;
  int? sellCount;
  int? totalTrades;
  List<UniqueChats>? uniqueChats;

  StockTips({this.uniqueChannelCount, this.winCount, this.lossCount, this.buyCount, this.sellCount, this.totalTrades, this.uniqueChats});

  StockTips.fromJson(Map<String, dynamic> json) {
    uniqueChannelCount = json['uniqueChannelCount'];
    winCount = json['winCount'];
    lossCount = json['lossCount'];
    buyCount = json['buyCount'];
    sellCount = json['sellCount'];
    totalTrades = json['totalTrades'];

    if (json['uniqueChats'] != null && json['uniqueChats'] is List) {
      uniqueChats = (json['uniqueChats'] as List).map((v) => UniqueChats.fromJson(v)).toList();
    } else {
      uniqueChats = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniqueChannelCount'] = this.uniqueChannelCount;
    data['winCount'] = this.winCount;
    data['lossCount'] = this.lossCount;
    data['buyCount'] = this.buyCount;
    data['sellCount'] = this.sellCount;
    data['totalTrades'] = this.totalTrades;
    if (this.uniqueChats != null) {
      data['uniqueChats'] = this.uniqueChats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UniqueChats {
  String? sId;
  int? telegramId;
  String? createdOn;
  String? title;
  String? username;
  int? averageViews;
  int? participants;
  String? about;
  Null? adminsCount;
  Null? bannedCount;
  bool? hasGeo;
  bool? scam;
  bool? verified;
  List<String>? category;
  List<String>? period;
  String? creationDate;
  bool? sebiRegistered;

  UniqueChats(
      {this.sId,
      this.telegramId,
      this.createdOn,
      this.title,
      this.username,
      this.averageViews,
      this.participants,
      this.about,
      this.adminsCount,
      this.bannedCount,
      this.hasGeo,
      this.scam,
      this.verified,
      this.category,
      this.period,
      this.creationDate,
      this.sebiRegistered});

  UniqueChats.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    telegramId = json['telegramId'];
    createdOn = json['createdOn'];
    title = json['title'];
    username = json['username'];
    averageViews = json['averageViews'];
    participants = json['participants'];
    about = json['about'];
    adminsCount = json['admins_count'];
    bannedCount = json['banned_count'];
    hasGeo = json['has_geo'];
    scam = json['scam'];
    verified = json['verified'];

    category = json['category'] != null ? List<String>.from(json['category']) : [];
    period = json['period'] != null ? List<String>.from(json['period']) : [];

    creationDate = json['creation_date'];
    sebiRegistered = json['sebiRegistered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['telegramId'] = this.telegramId;
    data['createdOn'] = this.createdOn;
    data['title'] = this.title;
    data['username'] = this.username;
    data['averageViews'] = this.averageViews;
    data['participants'] = this.participants;
    data['about'] = this.about;
    data['admins_count'] = this.adminsCount;
    data['banned_count'] = this.bannedCount;
    data['has_geo'] = this.hasGeo;
    data['scam'] = this.scam;
    data['verified'] = this.verified;
    data['category'] = this.category;
    data['period'] = this.period;
    data['creation_date'] = this.creationDate;
    data['sebiRegistered'] = this.sebiRegistered;
    return data;
  }
}
