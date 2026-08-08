/// Derives display-only profile fields that Random User does not provide.
class ProfileEnrichment {
  ProfileEnrichment._();

  static const _occupations = [
    'Fashion Designer',
    'Software Engineer',
    'Product Designer',
    'Marketing Manager',
    'Photographer',
    'Architect',
    'Doctor',
    'Teacher',
    'Entrepreneur',
    'UX Designer',
    'Content Creator',
    'Journalist',
  ];

  static const _heights = [
    "5'2\"",
    "5'3\"",
    "5'4\"",
    "5'5\"",
    "5'6\"",
    "5'7\"",
    "5'8\"",
    "5'9\"",
    "5'10\"",
    "6'0\"",
  ];

  static const _intentions = [
    'Serious relationship',
    'Long-term partner',
    'Something casual',
    'New friends',
    'Open to see',
  ];

  static int hash(String seed) {
    var h = 0;
    for (var i = 0; i < seed.length; i++) {
      h = 0x1fffffff & (h + seed.codeUnitAt(i));
      h = 0x1fffffff & (h + ((0x0007ffff & h) << 10));
      h ^= h >> 6;
    }
    h = 0x1fffffff & (h + ((0x03ffffff & h) << 3));
    h ^= h >> 11;
    return 0x1fffffff & (h + ((0x00003fff & h) << 15));
  }

  static int matchPercent(String seed) => 55 + (hash('${seed}m') % 41);

  static int trustPercent(String seed) => 70 + (hash('${seed}t') % 29);

  static String replyTime(String seed) {
    final options = ['~2m', '~5m', '~8m', '~12m', '~20m', '~1h'];
    return options[hash('${seed}r') % options.length];
  }

  static String occupation(String seed) =>
      _occupations[hash('${seed}o') % _occupations.length];

  static String height(String seed) =>
      _heights[hash('${seed}h') % _heights.length];

  static String intention(String seed) =>
      _intentions[hash('${seed}i') % _intentions.length];

  static bool isOnline(String seed) => hash('${seed}on') % 3 != 0;

  static bool isVerified(String seed) => hash('${seed}v') % 4 != 0;

  static double distanceKm(String seed) =>
      1 + (hash('${seed}d') % 250) / 10; // 1.0 – 25.9

  static List<String> get heights => _heights;
}
