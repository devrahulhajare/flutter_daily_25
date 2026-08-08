class ComplimentIdea {
  const ComplimentIdea({
    required this.category,
    required this.text,
  });

  final String category;
  final String text;
}

class ComplimentCatalog {
  ComplimentCatalog._();

  static const categories = [
    'Sweet',
    'Playful',
    'Admiring',
    'Flirty',
    'Funny',
  ];

  static const ideas = <ComplimentIdea>[
    ComplimentIdea(
      category: 'Sweet',
      text: 'Your smile is absolutely contagious 😊',
    ),
    ComplimentIdea(
      category: 'Sweet',
      text: 'You have the kind of warmth that makes people feel at home.',
    ),
    ComplimentIdea(
      category: 'Sweet',
      text: "There's something genuinely lovely about your energy.",
    ),
    ComplimentIdea(
      category: 'Sweet',
      text: 'I could probably talk to you for hours and never get bored.',
    ),
    ComplimentIdea(
      category: 'Sweet',
      text: 'You seem like the kind of person who makes ordinary days better.',
    ),
    ComplimentIdea(
      category: 'Sweet',
      text: 'Your kindness really comes through in your profile.',
    ),
    ComplimentIdea(
      category: 'Playful',
      text: 'Warning: your profile may cause spontaneous smile attacks.',
    ),
    ComplimentIdea(
      category: 'Playful',
      text: 'I came for the photos. Stayed for the vibe.',
    ),
    ComplimentIdea(
      category: 'Playful',
      text: 'If charm were a sport, you’d be unfairly good at it.',
    ),
    ComplimentIdea(
      category: 'Admiring',
      text: 'Your ambition is honestly inspiring.',
    ),
    ComplimentIdea(
      category: 'Admiring',
      text: 'You carry yourself with such quiet confidence.',
    ),
    ComplimentIdea(
      category: 'Admiring',
      text: 'That mix of style and substance? Hard to find.',
    ),
    ComplimentIdea(
      category: 'Flirty',
      text: 'Not gonna lie, your smile stopped my scroll 😍',
    ),
    ComplimentIdea(
      category: 'Flirty',
      text: 'You’re trouble, I can already tell — the good kind.',
    ),
    ComplimentIdea(
      category: 'Flirty',
      text: 'If you’re as fun in person as your profile, I’m in.',
    ),
    ComplimentIdea(
      category: 'Flirty',
      text: 'I think we’d make a dangerously good team ☕️ ➡️ 🍷',
    ),
    ComplimentIdea(
      category: 'Flirty',
      text: 'You’ve got a vibe I can’t quite look away from.',
    ),
    ComplimentIdea(
      category: 'Flirty',
      text: 'Coffee, you, and good conversation — when’s good for you?',
    ),
    ComplimentIdea(
      category: 'Funny',
      text: 'I’d say “marry me” but let’s start with chai first.',
    ),
    ComplimentIdea(
      category: 'Funny',
      text: 'Your profile made my algorithm look smart for once.',
    ),
  ];

  static List<ComplimentIdea> byCategory(String category) =>
      ideas.where((e) => e.category == category).toList();
}
