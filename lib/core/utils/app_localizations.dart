import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // HAPUS 'const' DI SINI
  static List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  // All text strings
  String get goodMorning => _get('goodMorning', 'Selamat Pagi');
  String get goodAfternoon => _get('goodAfternoon', 'Selamat Siang');
  String get goodEvening => _get('goodEvening', 'Selamat Malam');
  String get target => _get('target', 'Target');
  String get consumed => _get('consumed', 'Dikonsumsi');
  String get remaining => _get('remaining', 'Tersisa');
  String get nutritionToday => _get('nutritionToday', 'Nutrisi Hari Ini');
  String get carbs => _get('carbs', 'Karbohidrat');
  String get protein => _get('protein', 'Protein');
  String get fat => _get('fat', 'Lemak');
  String get quickActions => _get('quickActions', 'Aksi Cepat');
  String get scanFood => _get('scanFood', 'Scan Makanan');
  String get mealPlan => _get('mealPlan', 'Rencana Makan');
  String get recordWater => _get('recordWater', 'Catat Air');
  String get recentMeals => _get('recentMeals', 'Makanan Terbaru');
  String get viewAll => _get('viewAll', 'Lihat Semua');
  String get historyTitle => _get('historyTitle', 'Riwayat');
  String get totalCalories => _get('totalCalories', 'Total Kalori');
  String get totalFoods => _get('totalFoods', 'Total Makanan');
  String get weeklyReport => _get('weeklyReport', 'Laporan Mingguan');
  String get weeklyCalories => _get('weeklyCalories', 'Kalori Mingguan');
  String get thisWeek => _get('thisWeek', 'Minggu ini');
  String get avgCalories => _get('avgCalories', 'Rata-rata Kalori');
  String get daysAchieved => _get('daysAchieved', 'Hari Tercapai');
  String get proteinAvg => _get('proteinAvg', 'Rata-rata Protein');
  String get totalFoodsReport => _get('totalFoodsReport', 'Total Makanan');
  String get mon => _get('mon', 'Sen');
  String get tue => _get('tue', 'Sel');
  String get wed => _get('wed', 'Rab');
  String get thu => _get('thu', 'Kam');
  String get fri => _get('fri', 'Jum');
  String get sat => _get('sat', 'Sab');
  String get sun => _get('sun', 'Min');
  
  // ============ NAVIGATION LABELS (TAMBAHKAN INI) ============
  String get navHome => _get('navHome', 'Beranda');
  String get navHistory => _get('navHistory', 'Riwayat');
  String get navReport => _get('navReport', 'Laporan');
  String get navProfile => _get('navProfile', 'Profil');
  String get navScan => _get('navScan', 'Pindai');

  String _get(String key, String idValue) {
    switch (locale.languageCode) {
      case 'id':
        return idValue;
      case 'en':
        return _enMap[key] ?? idValue;
      case 'zh':
        return _zhMap[key] ?? idValue;
      case 'ja':
        return _jaMap[key] ?? idValue;
      default:
        return idValue;
    }
  }

  static const Map<String, String> _enMap = {
    'goodMorning': 'Good Morning',
    'goodAfternoon': 'Good Afternoon',
    'goodEvening': 'Good Evening',
    'target': 'Target',
    'consumed': 'Consumed',
    'remaining': 'Remaining',
    'nutritionToday': "Today's Nutrition",
    'carbs': 'Carbs',
    'protein': 'Protein',
    'fat': 'Fat',
    'quickActions': 'Quick Actions',
    'scanFood': 'Scan Food',
    'mealPlan': 'Meal Plan',
    'recordWater': 'Record Water',
    'recentMeals': 'Recent Meals',
    'viewAll': 'View All',
    'historyTitle': 'History',
    'totalCalories': 'Total Calories',
    'totalFoods': 'Total Foods',
    'weeklyReport': 'Weekly Report',
    'weeklyCalories': 'Weekly Calories',
    'thisWeek': 'This Week',
    'avgCalories': 'Avg Calories',
    'daysAchieved': 'Days Achieved',
    'proteinAvg': 'Avg Protein',
    'totalFoodsReport': 'Total Foods',
    'mon': 'Mon',
    'tue': 'Tue',
    'wed': 'Wed',
    'thu': 'Thu',
    'fri': 'Fri',
    'sat': 'Sat',
    'sun': 'Sun',
    // Navigation
    'navHome': 'Home',
    'navHistory': 'History',
    'navReport': 'Report',
    'navProfile': 'Profile',
    'navScan': 'Scan',
  };

  static const Map<String, String> _zhMap = {
    'goodMorning': '早上好',
    'goodAfternoon': '下午好',
    'goodEvening': '晚上好',
    'target': '目标',
    'consumed': '已摄入',
    'remaining': '剩余',
    'nutritionToday': '今日营养',
    'carbs': '碳水化合物',
    'protein': '蛋白质',
    'fat': '脂肪',
    'quickActions': '快捷操作',
    'scanFood': '扫描食物',
    'mealPlan': '饮食计划',
    'recordWater': '记录饮水',
    'recentMeals': '最近餐食',
    'viewAll': '查看全部',
    'historyTitle': '历史记录',
    'totalCalories': '总卡路里',
    'totalFoods': '食物总数',
    'weeklyReport': '周报',
    'weeklyCalories': '每周卡路里',
    'thisWeek': '本周',
    'avgCalories': '平均卡路里',
    'daysAchieved': '达标天数',
    'proteinAvg': '平均蛋白质',
    'totalFoodsReport': '食物总数',
    'mon': '周一',
    'tue': '周二',
    'wed': '周三',
    'thu': '周四',
    'fri': '周五',
    'sat': '周六',
    'sun': '周日',
    // Navigation
    'navHome': '首页',
    'navHistory': '历史',
    'navReport': '报告',
    'navProfile': '个人资料',
    'navScan': '扫描',
  };

  static const Map<String, String> _jaMap = {
    'goodMorning': 'おはようございます',
    'goodAfternoon': 'こんにちは',
    'goodEvening': 'こんばんは',
    'target': '目標',
    'consumed': '摂取',
    'remaining': '残り',
    'nutritionToday': '今日の栄養',
    'carbs': '炭水化物',
    'protein': 'タンパク質',
    'fat': '脂肪',
    'quickActions': 'クイックアクション',
    'scanFood': '食品をスキャン',
    'mealPlan': '食事プラン',
    'recordWater': '水を記録',
    'recentMeals': '最近の食事',
    'viewAll': 'すべて表示',
    'historyTitle': '履歴',
    'totalCalories': '総カロリー',
    'totalFoods': '食品数',
    'weeklyReport': '週次レポート',
    'weeklyCalories': '週間カロリー',
    'thisWeek': '今週',
    'avgCalories': '平均カロリー',
    'daysAchieved': '達成日数',
    'proteinAvg': '平均タンパク質',
    'totalFoodsReport': '食品数',
    'mon': '月',
    'tue': '火',
    'wed': '水',
    'thu': '木',
    'fri': '金',
    'sat': '土',
    'sun': '日',
    // Navigation
    'navHome': 'ホーム',
    'navHistory': '履歴',
    'navReport': 'レポート',
    'navProfile': 'プロフィール',
    'navScan': 'スキャン',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['id', 'en', 'zh', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}