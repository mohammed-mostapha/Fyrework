import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class ClientWorkerRating extends StatefulWidget {
  final int maximumRating;
  final Function(int) onRatingSelected;

  ClientWorkerRating(this.onRatingSelected, [this.maximumRating = 5]);

  @override
  _ClientWorkerRatingState createState() => _ClientWorkerRatingState();
}

class _ClientWorkerRatingState extends State<ClientWorkerRating> {
  final String outlineStar = 'assets/svgs/flaticon/outline_star.svg';
  final String solidStar = 'assets/svgs/flaticon/solid_star.svg';

  int _workerRating = 0;

  _buildRatingStars(int index) {
    if (index < _workerRating) {
      return SizedBox(
        width: 20,
        height: 20,
        child: SvgPicture.asset(
          solidStar,
          semanticsLabel: 'rating_star',
          color: Colors.orange,
        ),
      );
    }
    return SizedBox(
      width: 20,
      height: 20,
      child: SvgPicture.asset(
        outlineStar,
        semanticsLabel: 'rating_star',
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _buildClientWorkerRating() {
    final stars = List.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStars(index),
        onTap: () {
          setState(() {
            _workerRating = index + 1;
          });
          this.widget.onRatingSelected(_workerRating);
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

  @override
  Widget build(BuildContext context) {
    return _buildClientWorkerRating();
  }
}
