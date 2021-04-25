import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class ClientWorkerRating extends StatefulWidget {
  final int maximumRating;
  // final Function(int) onRatingSelected;

  ClientWorkerRating([this.maximumRating = 5]);

  @override
  _ClientWorkerRatingState createState() => _ClientWorkerRatingState();
}

class _ClientWorkerRatingState extends State<ClientWorkerRating> {
  final String outline_star = 'assets/svgs/flaticon/outline_star.svg';
  final String solid_star = 'assets/svgs/flaticon/solid_star.svg';

  _buildRatingStars(int index) {
    return SizedBox(
      width: 20,
      height: 20,
      child: SvgPicture.asset(outline_star,
          semanticsLabel: 'paperclip', color: Theme.of(context).accentColor),
    );
  }

  Widget _buildClientWorkerRating() {
    final stars = List.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStars(index),
        onTap: () {},
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
