/// Centralized Arabic user-facing strings for Phase 1.
///
/// Keep every user-visible Arabic string here; do not scatter raw strings
/// through widgets.
abstract final class AppStrings {
  // Branding.
  static const String appName = 'تذكّر';
  static const String appTagline = 'TATHAKKAR';

  // Onboarding.
  static const String onboardingSkip = 'تخطي';
  static const String onboardingNext = 'التالي';
  static const String onboardingFinish = 'ابدأ الآن';

  static const String onboardingTitle1 = 'دواوك في وقته';
  static const String onboardingBody1 =
      'تذكيرات واضحة تساعدك على الالتزام بمواعيد أدويتك.';

  static const String onboardingTitle2 = 'كل أدويتك منظّمة';
  static const String onboardingBody2 =
      'تابع جرعاتك ومواعيدك وكميات أدويتك بسهولة.';

  static const String onboardingTitle3 = 'اطمئن على أحبائك';
  static const String onboardingBody3 =
      'أدر أدوية عائلتك، وتابع الالتزام بالعلاج حتى عن بُعد.';

  // Onboarding illustration preview text (decorative, part of the design).
  static const String previewEarlyTime = '٨:٠٠ صباحاً';
  static const String previewMedicineName = 'ميتفورمين ٥٠٠ ملغ';
  static const String previewDose = 'حبة واحدة • بعد الأكل';
  static const String previewTakenAction = 'أخذت الدواء';
  static const String previewConfirmed = 'مؤكدة';
  static const String previewReminder = 'بعد ٣٠ دقيقة';
  static const String previewMedicineShort = 'ميتفورمين';
  static const String previewMedicineSecond = 'لوسارتان';
  static const String previewMedicineThird = 'فيتامين د';
  static const String previewMorningTime = '٨:٠٠ ص';
  static const String previewNoonTime = '٢:٠٠ م';
  static const String previewEveningTime = '٨:٠٠ م';
  static const String previewUpcoming = 'قادمة';
  static const String previewProfileOne = 'أحمد';
  static const String previewProfileTwo = 'أبي';

  // Login.
  static const String loginTitle = 'أهلاً بعودتك';
  static const String loginSubtitle = 'سجّل دخولك لمتابعة أدويتك.';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String passwordLabel = 'كلمة المرور';
  static const String showPassword = 'إظهار كلمة المرور';
  static const String hidePassword = 'إخفاء كلمة المرور';
  static const String forgotPasswordLink = 'نسيت كلمة المرور؟';
  static const String loginButton = 'تسجيل الدخول';
  static const String noAccountPrompt = 'ليس لديك حساب؟';
  static const String createAccountAction = 'إنشاء حساب';

  // Registration.
  static const String registerTitle = 'إنشاء حساب';
  static const String registerSubtitle = 'أدخل بياناتك الأساسية لتبدأ.';
  static const String fullNameLabel = 'الاسم الكامل';
  static const String confirmPasswordLabel = 'تأكيد كلمة المرور';
  static const String registerButton = 'إنشاء حساب';
  static const String hasAccountPrompt = 'هل لديك حساب؟';
  static const String loginAction = 'نعم';

  // Forgot / reset password.
  static const String forgotTitle = 'استعادة كلمة المرور';
  static const String forgotSubtitle = 'سنرسل لك تعليمات إعادة التعيين.';
  static const String sendButton = 'إرسال';
  static const String resetEmailSent = 'أرسلنا التعليمات إلى بريدك الإلكتروني.';

  /// Shown inside the single send button while the cooldown is active.
  static String sendCountdown(int seconds) => 'إرسال ($seconds)';

  // Validation messages.
  static const String emailRequired = 'يرجى إدخال البريد الإلكتروني';
  static const String emailInvalid = 'صيغة البريد الإلكتروني غير صحيحة';
  static const String passwordRequired = 'يرجى إدخال كلمة المرور';
  static const String passwordTooShort =
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
  static const String nameRequired = 'يرجى إدخال الاسم الكامل';
  static const String confirmPasswordRequired = 'يرجى تأكيد كلمة المرور';
  static const String passwordMismatch = 'كلمتا المرور غير متطابقتين';

  // Authentication failure messages (mapped from Firebase error codes).
  static const String authUserNotFound = 'لا يوجد حساب بهذا البريد الإلكتروني';
  static const String authWrongPassword = 'كلمة المرور غير صحيحة';
  static const String authInvalidCredential = 'بيانات الدخول غير صحيحة';
  static const String authEmailAlreadyInUse =
      'هذا البريد الإلكتروني مسجّل بالفعل';
  static const String authWeakPassword = 'كلمة المرور ضعيفة (6 أحرف على الأقل)';
  static const String authInvalidEmail = 'صيغة البريد الإلكتروني غير صحيحة';
  static const String authUserDisabled = 'هذا الحساب معطّل';
  static const String authTooManyRequests = 'محاولات كثيرة، حاول لاحقاً';
  static const String authNetworkRequestFailed =
      'تعذر الاتصال بالإنترنت، تحقق من الشبكة وحاول مرة أخرى';
  static const String authOperationNotAllowed =
      'طريقة الدخول غير مفعلة، تواصل مع الدعم';
  static const String authUnknown = 'حدث خطأ غير متوقع، حاول مرة أخرى';

  // Home placeholder (Phase 1 minimum destination only).
  static const String homePlaceholderTitle = 'الرئيسية';
  static const String homePlaceholderMessage =
      'ستتوفر هذه الشاشة بالكامل في المرحلة القادمة.';
}
