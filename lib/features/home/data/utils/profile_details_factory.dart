import '../../../../core/utils/profile_enrichment.dart';
import '../../domain/entities/user_profile_details.dart';

/// Builds extended profile sections.
/// API-backed fields (location, DOB, nationality) are preferred when present;
/// remaining dating fields are enriched because Random User does not provide them.
class ProfileDetailsFactory {
  ProfileDetailsFactory._();

  static const _heightCm = [
    157,
    160,
    163,
    165,
    168,
    170,
    173,
    175,
    178,
    183,
  ];

  static const _abouts = [
    'Building products by day, planning my next trek by night. Looking for someone equally driven and equally curious.',
    'Coffee snob, weekend baker, and forever chasing sunsets. Let’s swap playlists and bad jokes.',
    'Design-obsessed, travel-hungry, and always down for a spontaneous chai break.',
    'Quiet mornings, loud concerts, and conversations that go past midnight.',
  ];

  static const _loveLanguages = [
    ('Compliment', 'Words of affirmation'),
    ('Quality time', 'Undivided attention'),
    ('Acts of service', 'Thoughtful gestures'),
    ('Physical touch', 'Warm presence'),
  ];

  static const _religions = [
    'Spiritual',
    'Agnostic',
    'Christian',
    'Hindu',
    'Muslim',
    'Sikh',
    'Jewish',
    'Prefer not to say',
  ];

  static const _zodiacFallback = [
    ('Scorpio', 'Loyal · Passionate · Intuitive'),
    ('Leo', 'Warm · Bold · Creative'),
    ('Gemini', 'Curious · Witty · Social'),
    ('Virgo', 'Grounded · Thoughtful · Precise'),
    ('Pisces', 'Empathetic · Dreamy · Kind'),
    ('Aries', 'Energetic · Honest · Brave'),
  ];

  static const _comms = [
    'Calls over texts',
    'Voice notes',
    'Thoughtful texts',
    'Calls & chats',
  ];

  static const _educations = [
    ('Local University', 'Bachelor’s · Graduated'),
    ('State College', 'Master’s · Alum'),
    ('Design School', 'B.Des · Final year'),
    ('Business School', 'MBA · Alum'),
    ('Tech Institute', 'B.Tech · Alum'),
  ];

  static const _workDetails = [
    'Freelance · 2 yrs exp',
    'Full-time · 3 yrs exp',
    'Startup · 1 yr exp',
    'Agency · 4 yrs exp',
  ];

  static const _workStyles = [
    'Creative · Hybrid',
    'Remote-first',
    'Office · Collaborative',
    'Flexible · Travel-friendly',
  ];

  static const _ambitions = [
    'HIGHLY DRIVEN',
    'AMBITIOUS',
    'BALANCED',
    'GROWTH-FOCUSED',
  ];

  static const _dreams = [
    'Launch her own sustainable label — crafted with heart. Also wants to travel every fashion capital before 30.',
    'Build a product that makes everyday life a little kinder — and still find time for long weekend treks.',
    'Open a neighborhood café that doubles as a creative studio for local artists.',
    'Write a book, shoot a short film, and never stop learning something new.',
  ];

  static const _datingGoals = [
    (
      'Long-term, marriage-open',
      'No pressure, no timelines — just looking for the right person to build something real with.',
    ),
    (
      'Serious, exclusive',
      'Ready to invest in someone who values honesty, humor, and soft Sundays.',
    ),
    (
      'See where it goes',
      'Open to chemistry first — commitment when it feels right for both of us.',
    ),
  ];

  static const _diets = ['Vegetarian', 'Eggetarian', 'Non-vegetarian', 'Vegan'];
  static const _drinking = ['Socially', 'Rarely', 'Never', 'On weekends'];
  static const _sleep = ['Night Owl', 'Early Bird', 'Flexible'];

  static const _promptBank = [
    (
      'The way to win me over is...',
      'A good book rec and a strong chai opinion.',
    ),
    (
      "We'll get along if...",
      'You can debate me for an hour and still want dessert after.',
    ),
    (
      'My simple pleasures...',
      'Roadside chai after a long trek, no signal, good company.',
    ),
    (
      'I geek out on...',
      'Typography, thrift finds, and perfectly timed playlists.',
    ),
    (
      'A perfect Sunday looks like...',
      'Slow breakfast, a long walk, and zero notifications.',
    ),
  ];

  static const _interestBank = [
    ('Travel', 'flight'),
    ('Coffee', 'coffee'),
    ('Trekking', 'terrain'),
    ('Books', 'menu_book'),
    ('Yoga', 'self_improvement'),
    ('Indie music', 'music_note'),
    ('Cooking', 'restaurant'),
    ('Photography', 'photo_camera'),
    ('Art', 'palette'),
    ('Fitness', 'fitness_center'),
    ('Movies', 'movie'),
    ('Dancing', 'nightlife'),
  ];

  static const _natLanguage = {
    'AU': 'English',
    'BR': 'Portuguese',
    'CA': 'English',
    'CH': 'German',
    'DE': 'German',
    'DK': 'Danish',
    'ES': 'Spanish',
    'FI': 'Finnish',
    'FR': 'French',
    'GB': 'English',
    'IE': 'English',
    'IN': 'Hindi',
    'IR': 'Persian',
    'MX': 'Spanish',
    'NL': 'Dutch',
    'NO': 'Norwegian',
    'NZ': 'English',
    'RS': 'Serbian',
    'TR': 'Turkish',
    'UA': 'Ukrainian',
    'US': 'English',
  };

  static UserProfileDetails build({
    required String seed,
    required String occupation,
    required String height,
    required String gender,
    required String nationality,
    required String streetLine,
    required String city,
    required String state,
    required String country,
    String? birthDateIso,
  }) {
    final h = ProfileEnrichment.hash;
    final hIndex =
        ProfileEnrichment.heights.indexOf(height).clamp(0, _heightCm.length - 1);
    final love = _loveLanguages[h('${seed}ll') % _loveLanguages.length];
    final zodiac = _zodiacFromBirthDate(birthDateIso) ??
        _zodiacFallback[h('${seed}z') % _zodiacFallback.length];
    final edu = _educations[h('${seed}ed') % _educations.length];
    final goal = _datingGoals[h('${seed}dg') % _datingGoals.length];
    final dreamRaw = _dreams[h('${seed}bd') % _dreams.length];
    final dream = gender.toLowerCase() == 'male'
        ? dreamRaw.replaceAll(' her ', ' his ').replaceAll('Her ', 'His ')
        : dreamRaw;

    final promptStart = h('${seed}p') % _promptBank.length;
    final prompts = List.generate(3, (i) {
      final item = _promptBank[(promptStart + i) % _promptBank.length];
      return ProfilePrompt(title: item.$1, answer: item.$2);
    });

    final interestStart = h('${seed}in') % _interestBank.length;
    final interests = List.generate(8, (i) {
      final item = _interestBank[(interestStart + i) % _interestBank.length];
      return InterestTag(label: item.$1, icon: item.$2);
    });

    final livesIn = city.isNotEmpty
        ? city
        : (state.isNotEmpty ? state : (country.isNotEmpty ? country : 'Nearby'));

    final regionParts = <String>[
      if (state.isNotEmpty && state != city) state,
      if (country.isNotEmpty && country != city && country != state) country,
    ];

    return UserProfileDetails(
      about: _abouts[h('${seed}ab') % _abouts.length],
      birthDateLabel: _formatBirthDate(birthDateIso),
      heightWithCm: '$height (${_heightCm[hIndex]} cm)',
      neighborhood: livesIn,
      locationRegion: regionParts.join(', '),
      loveLanguage: love.$1,
      loveLanguageDetail: love.$2,
      religion: _religions[h('${seed}rel') % _religions.length],
      interestedIn:
          gender.toLowerCase() == 'male' ? 'Women · Dating' : 'Men · Dating',
      zodiac: zodiac.$1,
      zodiacTraits: zodiac.$2,
      motherTongue: _motherTongueFor(nationality, seed),
      communicationStyle: _comms[h('${seed}cs') % _comms.length],
      education: edu.$1,
      educationDetail: edu.$2,
      workTitle: occupation,
      workDetail: _workDetails[h('${seed}wd') % _workDetails.length],
      workStyle: _workStyles[h('${seed}ws') % _workStyles.length],
      ambitionLevel: _ambitions[h('${seed}al') % _ambitions.length],
      bigDream: dream,
      datingGoal: goal.$1,
      datingGoalDetail: goal.$2,
      diet: _diets[h('${seed}di') % _diets.length],
      drinking: _drinking[h('${seed}dr') % _drinking.length],
      sleepSchedule: _sleep[h('${seed}sl') % _sleep.length],
      videoDuration: '0:${20 + (h('${seed}vid') % 40)}',
      prompts: prompts,
      interests: interests,
      secondaryPhotoSeeds: ['${seed}_a', '${seed}_b', '${seed}_c'],
    );
  }

  static String _motherTongueFor(String nationality, String seed) {
    final mapped = _natLanguage[nationality.toUpperCase()];
    if (mapped != null) return mapped;
    const fallback = ['English', 'Spanish', 'French', 'German', 'Arabic'];
    return fallback[ProfileEnrichment.hash('${seed}mt') % fallback.length];
  }

  static (String, String)? _zodiacFromBirthDate(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      final dt = DateTime.parse(iso);
      final m = dt.month;
      final d = dt.day;
      if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) {
        return ('Aries', 'Energetic · Honest · Brave');
      }
      if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) {
        return ('Taurus', 'Reliable · Patient · Grounded');
      }
      if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) {
        return ('Gemini', 'Curious · Witty · Social');
      }
      if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) {
        return ('Cancer', 'Caring · Intuitive · Loyal');
      }
      if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) {
        return ('Leo', 'Warm · Bold · Creative');
      }
      if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) {
        return ('Virgo', 'Grounded · Thoughtful · Precise');
      }
      if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) {
        return ('Libra', 'Balanced · Charming · Fair');
      }
      if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) {
        return ('Scorpio', 'Loyal · Passionate · Intuitive');
      }
      if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) {
        return ('Sagittarius', 'Adventurous · Honest · Optimistic');
      }
      if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) {
        return ('Capricorn', 'Ambitious · Disciplined · Steady');
      }
      if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) {
        return ('Aquarius', 'Independent · Original · Humane');
      }
      return ('Pisces', 'Empathetic · Dreamy · Kind');
    } catch (_) {
      return null;
    }
  }

  static String _formatBirthDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
