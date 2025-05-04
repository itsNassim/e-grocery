import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:user/classes/order_class.dart';

class OrderPreviewTile extends StatelessWidget {
  const OrderPreviewTile({
    super.key,
    required this.order,
    required this.onTap,
    required this.onPressed,
  });

  final Order order;
  final void Function() onTap;
  final void Function(BuildContext)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: onPressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 3, // Added a small shadow for better card feel
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Order ID:'),
                      const SizedBox(width: 5),
                      Text(
                        order.id.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.black),
                      ),
                      const Spacer(),
                      Text(
                        order.createdAt,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Status'),
                      Expanded(
                        child: RangeSlider(
                          values: RangeValues(0, _orderSliderValue()),
                          max: 3,
                          divisions: 3,
                          onChanged: (v) {},
                          activeColor: _orderColor(),
                          inactiveColor:
                              const Color(0xFF8B8B97).withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Opacity(
                              opacity: order.status == "confirmed" ? 1 : 0,
                              child: Text(
                                'Confirmed',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: _orderColor()),
                              ),
                            ),
                            Opacity(
                              opacity: order.status == "processing" ? 1 : 0,
                              child: Text(
                                'Processing',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: _orderColor()),
                              ),
                            ),
                            Opacity(
                              opacity: order.status == "shipped" ? 1 : 0,
                              child: Text(
                                'Shipped',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: _orderColor()),
                              ),
                            ),
                            Row(
                              children: [
                                if (order.status == "delivery" ||
                                    order.status == "picked up" ||
                                    order.status == "cancelled")
                                  Text(
                                    order.status == "delivery"
                                        ? 'Delivery'
                                        : order.status == "picked up"
                                            ? 'Picked Up'
                                            : 'Cancelled',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: _orderColor()),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _orderSliderValue() {
    switch (order.status) {
      case "confirmed":
        return 0;
      case "processing":
        return 1;
      case "shipped":
        return 2;
      case "delivery":
      case "picked up":
      case "cancelled":
        return 3;
      default:
        return 0;
    }
  }

  Color _orderColor() {
    switch (order.status) {
      case "confirmed":
        return const Color(0xFF4044AA);
      case "processing":
        return const Color(0xFF41A954);
      case "shipped":
        return const Color(0xFFE19603);
      case "delivery":
      case "picked up":
        return const Color(0xFF41AA55);
      case "cancelled":
        return const Color(0xFFFF1F1F);
      default:
        return const Color(0xFF4044AA);
    }
  }
}
