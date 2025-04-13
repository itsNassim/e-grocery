import 'package:flutter/material.dart';

class ItemTile2 extends StatelessWidget {
  final String backgroundImageName;
  final String imageName;
  final String name;
  final String time;
  final String delivery;
  final Color fontColor;
  final Color timeColor;
  ItemTile2({
    super.key,
    required this.backgroundImageName,
    required this.imageName,
    required this.name,
    required this.time,
    required this.delivery,
    required this.fontColor,
    required this.timeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Color(0xffECE7CA)),
      child: Stack(
        children: [
          /*ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              backgroundImageName,
              height: 150,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                      ),
                    ),
                    Text(
                      "by" + time,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: timeColor,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      delivery,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 129, 120, 109),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                child: Image.asset(
                  imageName,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
