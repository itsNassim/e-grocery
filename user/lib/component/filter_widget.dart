import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/blocs/data_bloc.dart';
import 'package:user/classes/shop_class.dart';

class FilterWidget extends StatefulWidget {
  final String? selectedStore;
  final double? minPrice;
  final double? maxPrice;
  final String? sortOrder;
  final void Function({
    required String selectedStore,
    required double minPrice,
    required double maxPrice,
    required String sortOrder,
  }) onApply;

  FilterWidget({
    super.key,
    required this.onApply,
    required this.selectedStore,
    required this.minPrice,
    required this.maxPrice,
    required this.sortOrder,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedStore = "All";
  double minPrice = 0;
  double maxPrice = 1000;
  String sortOrder = 'A-Z';

  final List<String> stores = ['All'];
  late List<ShopClass> storesList = [];
  bool _added = false;

  final List<String> sortOptions = ['A-Z', 'Z-A'];

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.minPrice);
      selectedStore = widget.selectedStore ?? selectedStore;
      minPrice = widget.minPrice ?? minPrice;
      maxPrice = widget.maxPrice ?? maxPrice;
      sortOrder = widget.sortOrder ?? sortOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoadedState) {
          storesList = state.stores;
          if (!_added) {
            stores.addAll(storesList.map((e) => e.name).toList());
            _added = true;
          }
        }

        return ClipPath(
          clipper: CustomTopClipper(),
          child: Container(
            height: height * 0.55,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  spreadRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Filter Products",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),

                  _sectionTitle("Store"),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: stores.map((store) {
                      final isSelected = selectedStore == store;
                      return ChoiceChip(
                        label: Text(store),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Color(0xff055222),
                          fontWeight: FontWeight.w600,
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xff055222),
                        backgroundColor: Colors.white,
                        onSelected: (_) {
                          setState(() {
                            selectedStore = store;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle(
                      "Price Range (\$${minPrice.round()} - \$${maxPrice.round()})"),
                  RangeSlider(
                    activeColor: const Color(0xff055222),
                    values: RangeValues(minPrice, maxPrice),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    onChanged: (values) {
                      setState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Sort Order"),
                  Wrap(
                    spacing: 10,
                    children: sortOptions.map((option) {
                      final isSelected = sortOrder == option;
                      return ChoiceChip(
                        label: Text(option),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Color(0xff055222),
                          fontWeight: FontWeight.w600,
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xff055222),
                        backgroundColor: Colors.white,
                        onSelected: (_) {
                          setState(() {
                            sortOrder = option;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const Spacer(),

                  // Reset button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff055222),
                        side: const BorderSide(
                            color: Color(0xff055222), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedStore = "All";
                          minPrice = 0;
                          maxPrice = 1000;
                          sortOrder = 'A-Z';
                        });
                        widget.onApply(
                          selectedStore: selectedStore,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          sortOrder: sortOrder,
                        );
                      },
                      child: const Text(
                        "Reset Filters",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffBBEA70),
                        foregroundColor: const Color(0xff055222),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        widget.onApply(
                          selectedStore: selectedStore,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          sortOrder: sortOrder,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class CustomTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
