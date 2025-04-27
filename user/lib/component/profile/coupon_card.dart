import 'package:flutter/material.dart';
import 'package:user/component/profile/dotted_divider.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({
    super.key,
    this.couponBackground,
    required this.discounts,
    required this.title,
    required this.expire,
    this.color,
  });

  final String? couponBackground;
  final String discounts;
  final String title;
  final String expire;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 162,
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              color: color ?? Colors.blue,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(
                  couponBackground ?? "assets/coupon/coupon_background_1.png",
                ),
                // opacity: 0.25,
                fit: BoxFit.cover,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              discounts,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              'Off',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 160,
                      child:
                          DottedDivider(isVertical: true, color: Colors.white),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF00AD48),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 30,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Collect',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Color(0xFF00AD48),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              expire,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }
}
