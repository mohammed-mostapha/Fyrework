import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class ClientWorkerRating extends StatefulWidget {
  final int maximumRating;
  final int passedRatingCount;
  final Function(int) onRatingSelected;

  ClientWorkerRating(
      {this.onRatingSelected,
      @required this.passedRatingCount,
      this.maximumRating = 5});

  @override
  _ClientWorkerRatingState createState() => _ClientWorkerRatingState();
}

class _ClientWorkerRatingState extends State<ClientWorkerRating> {
  final String outlineStar = 'assets/svgs/flaticon/outline_star.svg';
  final String solidStar = 'assets/svgs/flaticon/solid_star.svg';

  int _selectedRating = 0;

  _buildRatingStars(int index) {
    if (index < _selectedRating) {
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
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget _buildClientWorkerRating() {
    final stars = List.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStars(index),
        onTap: () {
          setState(() {
            _selectedRating = index + 1;
          });
          this.widget.onRatingSelected(_selectedRating);
        },
      );
    });

    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        children: stars,
      ),
    );
  }

  _buildUserSelectedRatingStars(index, _passedRatingCount) {
    if (index < _passedRatingCount) {
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
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget _buildUserSelectedRating(int passedRatingCount) {
    final stars = List.generate(this.widget.maximumRating, (index) {
      return SizedBox(
        child: _buildUserSelectedRatingStars(index, passedRatingCount),
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
    return widget.passedRatingCount > 0
        ? _buildUserSelectedRating(widget.passedRatingCount)
        : _buildClientWorkerRating();
  }
}
