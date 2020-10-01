class GigModel {
  String gigHashtags;
  String gigPost;
  DateTime gigDeadLine;
  String gigCurrency;
  int gigBudget;
  String gigValue;
  String adultContentText;
  bool adultContentBool;

  GigModel({
    this.gigHashtags,
    this.gigPost,
    this.gigDeadLine,
    this.gigCurrency,
    this.gigBudget,
    this.adultContentText =
        'This is adult content that should not be visible to minors.',
    this.adultContentBool = false,
    this.gigValue,
  });

  Map<String, dynamic> toJson() => {
        'Gig Hashtags': gigHashtags,
        'Gig Post': gigPost,
        'Gig Deadline': gigDeadLine,
        'Gig Currency': gigCurrency,
        'Gig Budget': gigBudget,
        'Gig adult content': adultContentBool,
        'Gig Value': gigValue,
      };
}
