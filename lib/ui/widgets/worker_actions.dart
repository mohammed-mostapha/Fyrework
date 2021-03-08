import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class WorkerActions extends StatelessWidget {
  final String unsatisfied = 'assets/svgs/flaticon/unsatisfied.svg';
  final String leaveReviewIcon = 'assets/svgs/flaticon/leave_review.svg';
  final String markAsCompletedIcon =
      'assets/svgs/flaticon/mark_as_completed.svg';
  final String releaseEscrowPaymentIcon =
      'assets/svgs/flaticon/release_escrow_payment.svg';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Actions',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Theme.of(context).accentColor),
              )
            ],
          ),
          Wrap(
            children: [
              GestureDetector(
                child: Column(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(unsatisfied,
                          semanticsLabel: 'check-circle', color: Colors.green),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Unsatisfied',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Theme.of(context).accentColor),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
