import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileRatingStars extends StatefulWidget {
  final int maximumRating;

  ProfileRatingStars({this.maximumRating = 5});

  @override
  _ProfileRatingStarsState createState() => _ProfileRatingStarsState();
}

class _ProfileRatingStarsState extends State<ProfileRatingStars> {
  final String outlineStar = 'assets/svgs/flaticon/outline_star.svg';
  final String solidStar = 'assets/svgs/flaticon/solid_star.svg';

  int _userProfileRating = 0;

  _buildRatingStars(int index) {
    if (index < _userProfileRating) {
      return SizedBox(
        width: 25,
        height: 20,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: SvgPicture.asset(
            solidStar,
            semanticsLabel: 'rating_star',
            color: Colors.amber,
          ),
        ),
      );
    }
    return SizedBox(
      width: 25,
      height: 20,
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SvgPicture.asset(
          outlineStar,
          semanticsLabel: 'rating_star',
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildProfileRatingStars() {
    final stars = List.generate(this.widget.maximumRating, (index) {
      return Container(
        child: _buildRatingStars(index),
      );
    });

    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        children: stars,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProfileRatingStars();
  }
}
