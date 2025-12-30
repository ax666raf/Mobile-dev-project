// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'محصول';

  @override
  String get welcomeTo => 'أهلاً بك في';

  @override
  String get welcomeToMahsoul => 'أهلاً بك في محصول';

  @override
  String get welcomeBack => 'مرحباً بعودتك إلى محصول';

  @override
  String get welcomeDescription =>
      'اكتشف أطزج المنتجات مباشرة من المزارعين المحليين في منطقتك.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get back => 'رجوع';

  @override
  String get close => 'إغلاق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get selectMode => 'اختر الوضع المناسب لاحتياجاتك';

  @override
  String get pleaseSelectMode => 'الرجاء اختيار وضع';

  @override
  String get imFarmer => 'أنا مزارع';

  @override
  String get imConsumer => 'أنا مستهلك';

  @override
  String get farmerDescription => 'اعرض محصولك وتواصل مع المشترين';

  @override
  String get consumerDescription =>
      'اكتشف المنتجات الطازجة مباشرة من المزارعين';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterEmailAddress => 'أدخل عنوان بريدك الإلكتروني';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get confirmYourPassword => 'أكد كلمة المرور';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get createAccount => 'إنشاء حسابك';

  @override
  String get joinMahsoul =>
      'انضم إلى محصول للتواصل مع المزارعين المحليين والاستمتاع بالمنتجات الطازجة';

  @override
  String get agreeToThe => 'أوافق على ';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get subscribeNewsletter =>
      'الاشتراك في التحديثات والنشرات الإخبارية (اختياري)';

  @override
  String get signUpSuccessful => 'تم التسجيل بنجاح! جاري التحويل...';

  @override
  String get signUpFailed => 'فشل التسجيل';

  @override
  String get pleaseAgreeToTerms => 'الرجاء الموافقة على الشروط والأحكام';

  @override
  String get mahsoulPortal => 'بوابة محصول';

  @override
  String get connectWithFarmers =>
      'تواصل مع المزارعين المحليين واكتشف المنتجات الطازجة';

  @override
  String get shopSmarter => 'تسوق بذكاء';

  @override
  String get saveMore => 'وفر أكثر!';

  @override
  String get getDiscount => 'احصل على خصم 30% ✨';

  @override
  String get categories => 'الفئات';

  @override
  String get vegetables => 'الخضروات';

  @override
  String get fruits => 'الفواكه';

  @override
  String get cereals => 'الحبوب';

  @override
  String get grains => 'الحبوب';

  @override
  String get cotton => 'القطن';

  @override
  String get others => 'أخرى';

  @override
  String get all => 'الكل';

  @override
  String farmersCount(String count) {
    return '$count+ مزارع';
  }

  @override
  String get discoverMarket => 'اكتشف السوق';

  @override
  String get featuredFarmers => 'مزارعون مميزون';

  @override
  String get available => 'متاح';

  @override
  String distanceAway(String distance) {
    return '$distance كم';
  }

  @override
  String productsCount(String count) {
    return '$count+ منتج';
  }

  @override
  String get market => 'السوق';

  @override
  String get searchProducts => 'البحث عن منتجات...';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get price => 'السعر';

  @override
  String get rating => 'التقييم';

  @override
  String get reviews => 'المراجعات';

  @override
  String reviewsCount(int count) {
    return '$count مراجعة';
  }

  @override
  String get description => 'الوصف';

  @override
  String get origin => 'المصدر';

  @override
  String get harvestSeason => 'موسم الحصاد';

  @override
  String get organic => 'عضوي';

  @override
  String get storageInstructions => 'تعليمات التخزين';

  @override
  String get selectWeight => 'اختر الوزن';

  @override
  String get freeDelivery => 'توصيل مجاني';

  @override
  String get fastDelivery => 'توصيل سريع';

  @override
  String get bestPrice => 'أفضل سعر';

  @override
  String get verifiedSeller => 'بائع موثق';

  @override
  String get sellerInfo => 'معلومات البائع';

  @override
  String get farmName => 'اسم المزرعة';

  @override
  String get farmDescription => 'وصف المزرعة';

  @override
  String get yearsExperience => 'سنوات الخبرة';

  @override
  String get viewProfile => 'عرض الملف الشخصي';

  @override
  String get contactSeller => 'التواصل مع البائع';

  @override
  String get cart => 'السلة';

  @override
  String get myCart => 'سلتي';

  @override
  String get emptyCart => 'سلتك فارغة';

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get free => 'مجاني';

  @override
  String get total => 'المجموع';

  @override
  String get proceedToCheckout => 'متابعة الدفع';

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get removeItem => 'إزالة العنصر';

  @override
  String get quantity => 'الكمية';

  @override
  String itemsInCart(int count) {
    return '$count عناصر في السلة';
  }

  @override
  String get paymentInDelivery => 'الدفع عند التوصيل';

  @override
  String get orders => 'الطلبات';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get noOrders => 'لا توجد طلبات بعد';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get orderDate => 'تاريخ الطلب';

  @override
  String get orderStatus => 'حالة الطلب';

  @override
  String get orderTotal => 'مجموع الطلب';

  @override
  String get trackOrder => 'تتبع الطلب';

  @override
  String get reorder => 'إعادة الطلب';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get orderPlaced => 'تم تقديم الطلب بنجاح';

  @override
  String get awaitingConfirmation => 'في انتظار التأكيد';

  @override
  String get onGoing => 'جاري التنفيذ';

  @override
  String get processing => 'قيد المعالجة';

  @override
  String get shipped => 'تم الشحن';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get cancelled => 'ملغي';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get confirmed => 'مؤكد';

  @override
  String get viewOrderHistory => 'عرض سجل الطلبات وتتبع التوصيل';

  @override
  String get checkout => 'الدفع';

  @override
  String get placeOrder => 'تقديم الطلب';

  @override
  String get orderConfirmation => 'تأكيد الطلب';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get addDeliveryAddress => 'إضافة عنوان التوصيل';

  @override
  String get selectAddress => 'اختر العنوان';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get orderNotes => 'ملاحظات الطلب';

  @override
  String get addNotes => 'أضف ملاحظات لطلبك (اختياري)';

  @override
  String get confirmOrder => 'تأكيد الطلب';

  @override
  String get manageSavedLocations => 'إدارة عناوين التوصيل المحفوظة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get savedFarms => 'المزارع المحفوظة';

  @override
  String get deliveryAddresses => 'عناوين التوصيل';

  @override
  String get rewardsAndPoints => 'المكافآت والنقاط';

  @override
  String get loyaltyPoints => 'نقاط الولاء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get products => 'المنتجات';

  @override
  String get myProducts => 'منتجاتي';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get deleteProduct => 'حذف المنتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get productDescription => 'وصف المنتج';

  @override
  String get productPrice => 'سعر المنتج';

  @override
  String get productCategory => 'فئة المنتج';

  @override
  String get stockQuantity => 'كمية المخزون';

  @override
  String get productAdded => 'تمت إضافة المنتج بنجاح';

  @override
  String get productUpdated => 'تم تحديث المنتج بنجاح';

  @override
  String get productDeleted => 'تم حذف المنتج بنجاح';

  @override
  String get goodMorning => 'صباح الخير،';

  @override
  String get farmStatus => 'إليك كيف تسير مزرعتك اليوم.';

  @override
  String get ordersToday => 'طلبات اليوم';

  @override
  String get totalEarnings => 'إجمالي الأرباح';

  @override
  String get pendingDeliveries => 'التوصيلات المعلقة';

  @override
  String get viewOrders => 'عرض الطلبات';

  @override
  String get messages => 'الرسائل';

  @override
  String get myMessages => 'رسائلي';

  @override
  String get recentOrders => 'الطلبات الأخيرة';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get weeklySummary => 'ملخص مزرعتك الأسبوعي';

  @override
  String get farmerProfile => 'ملف المزارع';

  @override
  String get setupFarmProfile => 'إعداد ملف المزرعة';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get uploadProductImage => 'رفع صورة المنتج';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get address => 'العنوان';

  @override
  String get city => 'المدينة';

  @override
  String get state => 'الولاية';

  @override
  String get postalCode => 'الرمز البريدي';

  @override
  String get country => 'البلد';

  @override
  String get algeria => 'الجزائر';

  @override
  String get algiers => 'الجزائر العاصمة';

  @override
  String get oran => 'وهران';

  @override
  String get constantine => 'قسنطينة';

  @override
  String get blida => 'البليدة';

  @override
  String get call => 'اتصال';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get sendMessage => 'إرسال رسالة';

  @override
  String get invalidEmail => 'عنوان بريد إلكتروني غير صالح';

  @override
  String get invalidPassword => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صالح';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get pleaseEnterValidEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get connectionError => 'خطأ في الاتصال. يرجى التحقق من الإنترنت.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get sessionExpired => 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get da => 'دج';

  @override
  String get currency => 'دج';

  @override
  String get kg => 'كغ';

  @override
  String get g => 'غ';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get chooseLanguage => 'اختر لغتك المفضلة';

  @override
  String get home => 'الرئيسية';

  @override
  String get outOfStock => 'نفد المخزون';

  @override
  String get enterProductName => 'أدخل اسم المنتج';

  @override
  String get selectProductCategory => 'اختر فئة المنتج';

  @override
  String get productWeight => 'وزن المنتج';

  @override
  String get enterProductWeight => 'أدخل وزن المنتج';

  @override
  String get productLocation => 'موقع المنتج';

  @override
  String get enterProductLocation => 'أدخل موقع المنتج';

  @override
  String get availability => 'التوفر';

  @override
  String get completeYourProfile => 'أكمل ملفك الشخصي';

  @override
  String get tellUsMore =>
      'أخبرنا المزيد حتى نتمكن من تخصيص تجربة محصول الخاصة بك.';

  @override
  String get enterAddress => 'أدخل عنوانك';

  @override
  String get postalCodeOptional => 'الرمز البريدي (اختياري)';

  @override
  String get selectCity => 'اختر مدينة';

  @override
  String get saveContinue => 'حفظ ومتابعة';

  @override
  String get addressSavedSuccessfully => 'تم حفظ العنوان بنجاح';

  @override
  String get allOrders => 'جميع الطلبات';

  @override
  String get ongoing => 'جارية';

  @override
  String get viewMyOrders => 'عرض طلباتي';

  @override
  String get goHome => 'الذهاب للرئيسية';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get enterAddressHere => 'أدخل عنوانك هنا...';

  @override
  String get orderConfirmed => 'تم تأكيد الطلب!';

  @override
  String get thankYouShopping => 'شكراً لتسوقك مع محصول 🌱';

  @override
  String get farmerWillContact => 'سيتواصل معك المزارع قريباً';

  @override
  String get toConfirmOrder => 'لتأكيد طلبك.';

  @override
  String get choosePhoto => 'اختر صورة';

  @override
  String get remove => 'إزالة';

  @override
  String get noImageSelected => 'لم يتم اختيار صورة';

  @override
  String get deliveryDetails => 'تفاصيل التوصيل';

  @override
  String get contact => 'اتصال';

  @override
  String get paymentDetails => 'تفاصيل الدفع';

  @override
  String get paymentStatus => 'حالة الدفع';

  @override
  String get searchForProductsOrFarmers => 'البحث عن منتجات أو مزارعين...';

  @override
  String discoverFreshFromFarms(String category) {
    return 'اكتشف $category الطازجة من مزارع مختلفة';
  }

  @override
  String get discoverMore => 'اكتشف المزيد';

  @override
  String get tomatoes => 'طماطم';

  @override
  String freshTomatoesStartingFrom(String weight) {
    return 'طماطم طازجة تبدأ من $weight';
  }

  @override
  String get adamFarm => 'مزرعة آدم';

  @override
  String get harvestDate => 'تاريخ الحصاد';

  @override
  String daysAgo(int count) {
    return 'منذ $count أيام';
  }

  @override
  String get sarahAhmed => 'سارة أحمد';

  @override
  String get customerReviews => 'مراجعات العملاء';

  @override
  String get ratings => 'تقييمات';

  @override
  String get writeReview => 'اكتب مراجعة';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get yourReview => 'مراجعتك';

  @override
  String get writeYourReviewHere => 'شارك تجربتك مع هذا المنتج...';

  @override
  String get submitReview => 'إرسال المراجعة';

  @override
  String get noReviewsYet => 'لا توجد مراجعات بعد';

  @override
  String get beFirstToReview => 'كن أول من يشارك تجربته!';

  @override
  String get reviewSubmitted => 'تم إرسال المراجعة بنجاح';

  @override
  String get reviewUpdated => 'تم تحديث المراجعة بنجاح';

  @override
  String get yesCertified => 'نعم، معتمد';

  @override
  String get no => 'لا';

  @override
  String get originLabel => 'المصدر:';

  @override
  String get harvestDateLabel => 'تاريخ الحصاد:';

  @override
  String get organicLabel => 'عضوي:';

  @override
  String get storageLabel => 'التخزين:';

  @override
  String get october25th => '25 أكتوبر';

  @override
  String get pleaseLoginToViewProfile =>
      'الرجاء تسجيل الدخول لعرض الملف الشخصي';

  @override
  String get pleaseLoginToViewCart => 'الرجاء تسجيل الدخول لعرض السلة';

  @override
  String get pleaseLoginToViewOrders => 'الرجاء تسجيل الدخول لعرض الطلبات';

  @override
  String get pleaseLoginToViewProducts => 'الرجاء تسجيل الدخول لعرض المنتجات';

  @override
  String get pleaseLoginToViewDashboard =>
      'الرجاء تسجيل الدخول لعرض لوحة التحكم';

  @override
  String get pleaseLoginAsFarmer => 'الرجاء تسجيل الدخول كمزارع أولاً';

  @override
  String get pleaseLoginToProceed => 'الرجاء تسجيل الدخول للمتابعة';

  @override
  String get pleaseLoginToAddToCart =>
      'الرجاء تسجيل الدخول لإضافة العناصر إلى السلة';

  @override
  String get pleaseLoginToManageAddresses =>
      'الرجاء تسجيل الدخول لإدارة العناوين';

  @override
  String get pleaseLoginToViewOrdersHistory =>
      'الرجاء تسجيل الدخول لعرض الطلبات';

  @override
  String get noProfileDataAvailable => 'لا توجد بيانات الملف الشخصي متاحة';

  @override
  String get noOrdersFound => 'لم يتم العثور على طلبات';

  @override
  String get noOrdersAvailable => 'لا توجد طلبات متاحة';

  @override
  String get noProductsAvailable => 'لا توجد منتجات متاحة';

  @override
  String get noAddressesSaved => 'لا توجد عناوين محفوظة';

  @override
  String get unknownProduct => 'منتج غير معروف';

  @override
  String get unknownFarm => 'مزرعة غير معروفة';

  @override
  String get unknownCustomer => 'عميل';

  @override
  String get nA => 'غير متاح';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get anonymous => 'مجهول';

  @override
  String get pleaseSelectWeight => 'الرجاء اختيار الوزن';

  @override
  String get productAddedToCart => 'تمت إضافة المنتج إلى السلة!';

  @override
  String get failedToAddToCart => 'فشل إضافة المنتج إلى السلة';

  @override
  String get pleaseAddDeliveryAddress => 'الرجاء إضافة عنوان التوصيل';

  @override
  String get defaultAddressUpdated => 'تم تحديث العنوان الافتراضي بنجاح';

  @override
  String get addressDeletedSuccessfully => 'تم حذف العنوان بنجاح';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get profileNotLoadedYet =>
      'لم يتم تحميل الملف الشخصي بعد. الرجاء الانتظار...';

  @override
  String get farmOverview => 'نظرة عامة على المزرعة';

  @override
  String get ordersCompleted => 'الطلبات المكتملة';

  @override
  String get activeProducts => 'المنتجات النشطة';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get getHelpOrReportIssue => 'احصل على المساعدة أو أبلغ عن مشكلة';

  @override
  String get viewGeneralSettings => 'عرض الإعدادات العامة';

  @override
  String get areYouSureLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get deleteAddress => 'حذف العنوان';

  @override
  String get areYouSureDeleteAddress =>
      'هل أنت متأكد أنك تريد حذف هذا العنوان؟';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get enterStreetAddress => 'أدخل عنوان الشارع';

  @override
  String get enterCity => 'أدخل المدينة';

  @override
  String get addressIsRequired => 'العنوان مطلوب';

  @override
  String get cityIsRequired => 'المدينة مطلوبة';

  @override
  String get enterPostalCode => 'أدخل الرمز البريدي';

  @override
  String get homeDelivery => 'التوصيل إلى المنزل';

  @override
  String get cash => 'نقد';

  @override
  String get errorLoadingOrders => 'خطأ في تحميل الطلبات';

  @override
  String get noRecentOrders => 'لا توجد طلبات حديثة';

  @override
  String get errorOpeningEditProfile => 'خطأ في فتح تعديل الملف الشخصي';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get farmLocation => 'موقع المزرعة';

  @override
  String get enterFarmLocation => 'أدخل موقع المزرعة';

  @override
  String get descriptionMinLength => 'يجب أن يكون الوصف 20 حرفًا على الأقل';

  @override
  String get regularCustomer => 'عميل عادي';

  @override
  String get defaultAddress => 'العنوان الافتراضي';

  @override
  String get favorites => 'المفضلة';

  @override
  String get noFavorites => 'لا توجد مفضلات بعد';

  @override
  String get addFavoritesHint =>
      'اضغط على أيقونة القلب لإضافة المنتجات إلى المفضلة';

  @override
  String get addedToFavorites => 'تمت الإضافة إلى المفضلة';

  @override
  String get removedFromFavorites => 'تمت الإزالة من المفضلة';

  @override
  String get pleaseLogin => 'يرجى تسجيل الدخول للوصول إلى هذه الميزة';
}
