import 'package:flutter/material.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/Pages/profile/order_detail_page.dart';
import 'package:user/classes/order_class.dart';
import 'package:user/component/profile/order_preview_tile.dart';

class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage({super.key});

  @override
  State<AllOrdersPage> createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height - toppadding - bottompadding,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.15),
                child: ListView.builder(
                  itemCount: globalOrdersList.length,
                  itemBuilder: (context, index) {
                    OrderClass order = globalOrdersList[index];
                    return OrderPreviewTile(
                      order: order,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(
                            order: order,
                          ),
                        ),
                      ),
                      onPressed: (p0) {
                        setState(() {
                          if (order.Status != "picked up" &&
                              order.Status != "delivery" &&
                              order.Status != "cancelled") {
                            globalOrdersList[index].Status = "cancelled";
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.15,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SecondBackGround(ScreenHeight: height),
                    ),
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 103,
                            ),
                            const Text(
                              "All Orders",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
