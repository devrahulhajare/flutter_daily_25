import 'package:equatable/equatable.dart';

class ProfilePrompt extends Equatable {
  const ProfilePrompt({required this.title, required this.answer});

  final String title;
  final String answer;

  @override
  List<Object?> get props => [title, answer];
}

class InterestTag extends Equatable {
  const InterestTag({required this.label, required this.icon});

  final String label;
  final String icon; // Material icon name key resolved in UI

  @override
  List<Object?> get props => [label, icon];
}

/// Display-only extended profile fields shown after scrolling the card.
class UserProfileDetails extends Equatable {
  const UserProfileDetails({
    required this.about,
    required this.birthDateLabel,
    required this.heightWithCm,
    required this.neighborhood,
    this.locationRegion = '',
    required this.loveLanguage,
    required this.loveLanguageDetail,
    required this.religion,
    required this.interestedIn,
    required this.zodiac,
    required this.zodiacTraits,
    required this.motherTongue,
    required this.communicationStyle,
    required this.education,
    required this.educationDetail,
    required this.workTitle,
    required this.workDetail,
    required this.workStyle,
    required this.ambitionLevel,
    required this.bigDream,
    required this.datingGoal,
    required this.datingGoalDetail,
    required this.diet,
    required this.drinking,
    required this.sleepSchedule,
    required this.videoDuration,
    required this.prompts,
    required this.interests,
    required this.secondaryPhotoSeeds,
  });

  final String about;
  final String birthDateLabel;
  final String heightWithCm;
  final String neighborhood;
  final String locationRegion;
  final String loveLanguage;
  final String loveLanguageDetail;
  final String religion;
  final String interestedIn;
  final String zodiac;
  final String zodiacTraits;
  final String motherTongue;
  final String communicationStyle;
  final String education;
  final String educationDetail;
  final String workTitle;
  final String workDetail;
  final String workStyle;
  final String ambitionLevel;
  final String bigDream;
  final String datingGoal;
  final String datingGoalDetail;
  final String diet;
  final String drinking;
  final String sleepSchedule;
  final String videoDuration;
  final List<ProfilePrompt> prompts;
  final List<InterestTag> interests;
  final List<String> secondaryPhotoSeeds;

  @override
  List<Object?> get props => [
        about,
        birthDateLabel,
        heightWithCm,
        neighborhood,
        locationRegion,
        loveLanguage,
        loveLanguageDetail,
        religion,
        interestedIn,
        zodiac,
        zodiacTraits,
        motherTongue,
        communicationStyle,
        education,
        educationDetail,
        workTitle,
        workDetail,
        workStyle,
        ambitionLevel,
        bigDream,
        datingGoal,
        datingGoalDetail,
        diet,
        drinking,
        sleepSchedule,
        videoDuration,
        prompts,
        interests,
        secondaryPhotoSeeds,
      ];
}
