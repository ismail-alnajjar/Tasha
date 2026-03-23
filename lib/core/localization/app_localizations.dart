import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Onboarding
      'onboarding_title_1': 'Welcome to Tasha',
      'onboarding_desc_1':
          'Discover amazing experiences with our application. Everything you need in one place.',
      'onboarding_title_2': 'Easy Navigation',
      'onboarding_desc_2':
          'Browse through different sections easily and find what you are looking for in seconds.',
      'onboarding_title_3': 'Start Now',
      'onboarding_desc_3':
          'Join our community today and enjoy all the premium features we offer.',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',

      // HomePage
      'welcome_back': 'WELCOME BACK',
      'find_your_place': 'Find your place',
      'discover_jordan': 'Discover Jordan',
      'search_places': 'Where is your next adventure?',
      'popular_destinations': 'Popular Destinations',
      'see_all': 'See all',

      // Categories
      'cat_popular': 'Popular',
      'cat_museum': 'Museum',
      'cat_nature': 'Nature',
      'cat_foodie': 'Foodie',
      'cat_history': 'History',
      'cat_shopping': 'Shopping',
      'cat_all': 'All',
      'cat_beach': 'Beach',
      'cat_mountain': 'Mountain',
      'cat_city': 'City',
      'cat_forest': 'Forest',

      // Tags
      'collaborative_choice': 'Collaborative Choice',
      'trending_now': 'Trending Now',
      'alpine_luxury': 'Alpine Luxury',
      'cultural_immersion': 'Cultural Immersion',

      'home': 'Home',
      'new_trip': 'New Trip',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout from Tashah',
      'trips_taken': 'Trips Taken',
      'bucket_list': 'Bucket List',
      'reviews': 'Reviews',
      'travel_management': 'Travel Management',
      'preferences': 'Preferences',
      'my_bookings': 'My Bookings',
      'payment_methods': 'Payment Methods',
      'collaborative_groups': 'Collaborative Groups',
      'pro_member': 'Pro Member',
      'app_version': 'App Version 2.4.0 (Gold)',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'explore': 'Explore',
      'saved': 'Saved',
      'offers': 'Offers',
      'report': 'Report',
      'add_place': 'Add Place',
      'host_tourist': 'Host a Tourist',
      'explore_gems': 'Explore Gems',
      'saved_places': 'Saved Places',

      // UserTypePage
      'welcome_tashah': 'Welcome to Tashah',
      'select_role_desc': 'Please select your role to continue',
      'i_am_citizen': 'I am a Citizen',
      'citizen_desc': 'Discover places in my country',
      'i_am_tourist': 'I am a Tourist',
      'tourist_desc': 'Visiting Jordan for vacation',
      'continue_btn': 'Continue',
    },
    'ar': {
      // Onboarding
      'onboarding_title_1': 'مرحباً بك في طَشّة',
      'onboarding_desc_1':
          'اكتشف تجارب مذهلة مع تطبيقنا. كل ما تحتاجه في مكان واحد.',
      'onboarding_title_2': 'تصفح سهل',
      'onboarding_desc_2':
          'تصفح الأقسام المختلفة بسهولة وابحث عما تريده في ثوانٍ.',
      'onboarding_title_3': 'ابدا الان',
      'onboarding_desc_3':
          'انضم إلى مجتمعنا اليوم واستمتع بجميع الميزات المميزة التي نقدمها.',
      'skip': 'تخطي',
      'next': 'التالي',
      'get_started': 'ابدأ الآن',

      // HomePage
      'welcome_back': 'مرحباً بعودتك',
      'find_your_place': 'ابحث عن وجهتك',
      'discover_jordan': 'اكتشف الأردن',
      'search_places': 'أين هي مغامرتك القادمة؟',
      'popular_destinations': 'الوجهات الشائعة',
      'see_all': 'عرض الكل',

      // Categories
      'cat_popular': 'شائع',
      'cat_museum': 'متاحف',
      'cat_nature': 'طبيعة',
      'cat_foodie': 'طعام',
      'cat_history': 'تاريخ',
      'cat_shopping': 'تسوق',
      'cat_all': 'الكل',
      'cat_beach': 'شاطئ',
      'cat_mountain': 'جبل',
      'cat_city': 'مدينة',
      'cat_forest': 'غابة',

      // Tags
      'collaborative_choice': 'خيار تعاوني',
      'trending_now': 'رائج الآن',
      'alpine_luxury': 'فخامة الجبال',
      'cultural_immersion': 'انغماس ثقافي',

      'home': 'الرئيسية',
      'new_trip': 'رحلة جديدة',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'trips_taken': 'رحلات قمت بها',
      'bucket_list': 'قائمة الأمنيات',
      'reviews': 'المراجعات',
      'travel_management': 'إدارة السفر',
      'preferences': 'التفضيلات',
      'my_bookings': 'حجوزاتي',
      'payment_methods': 'طرق الدفع',
      'collaborative_groups': 'المجموعات التعاونية',
      'pro_member': 'عضو محترف',
      'app_version': 'إصدار التطبيق 2.4.0 (الذهبي)',
      'language': 'اللغة',
      'dark_mode': 'الوضع الليلي',
      'explore': 'استكشاف',
      'saved': 'المحفوظات',
      'offers': 'العروض',
      'report': 'إبلاغ',
      'add_place': 'إضافة مكان',
      'host_tourist': 'استضافة سائح',
      'explore_gems': 'استكشاف الوجهات',
      'saved_places': 'الأماكن المحفوظة',

      // UserTypePage
      'welcome_tashah': 'مرحباً بك في طَشّة',
      'select_role_desc': 'يرجى اختيار دورك للمتابعة',
      'i_am_citizen': 'أنا مواطن',
      'citizen_desc': 'استكشف أماكن في بلدي',
      'i_am_tourist': 'أنا سائح',
      'tourist_desc': 'زيارة الأردن لقضاء إجازة',
      'continue_btn': 'متابعة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
