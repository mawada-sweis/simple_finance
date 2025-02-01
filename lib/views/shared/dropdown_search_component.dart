import 'package:flutter/material.dart';

class DropdownSearchComponent<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final List<T> items;
  final String Function(T) displayValue;
  final String Function(T) idValue;
  final void Function(String) onItemSelected;
  final void Function(String) onSearch;
  final void Function() onReset;
  final String? initialValue;

  const DropdownSearchComponent(
      {super.key,
      required this.label,
      required this.hintText,
      required this.items,
      required this.displayValue,
      required this.idValue,
      required this.onItemSelected,
      required this.onSearch,
      required this.onReset,
      this.initialValue});

  @override
  State<DropdownSearchComponent<T>> createState() =>
      DropdownSearchComponentState<T>();
}

class DropdownSearchComponentState<T>
    extends State<DropdownSearchComponent<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
    widget.onReset();
    _searchController.clear();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset fieldPosition = renderBox.localToGlobal(Offset.zero);
    const double dropdownHeight = 200.0;

    final TextPainter labelPainter = TextPainter(
      text: TextSpan(
        text: widget.label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double labelWidth = labelPainter.size.width + 10;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _closeDropdown();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: const Color.fromARGB(10, 0, 0, 0),
              ),
            ),
            Positioned(
              left: fieldPosition.dx,
              width: renderBox.size.width - labelWidth + 5,
              top: fieldPosition.dy +
                  renderBox.size.height -
                  renderBox.size.height,
              child: Material(
                elevation: 2,
                color: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                borderRadius: BorderRadius.circular(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'بحث',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            widget.onSearch(value);
                          });
                        },
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    LimitedBox(
                      maxHeight: dropdownHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount:
                            widget.items.isNotEmpty ? widget.items.length : 0,
                        itemBuilder: (context, index) {
                          if (index >= widget.items.length) {
                            return const SizedBox();
                          }
                          if (widget.items.isEmpty) {
                            return const Center(child: Text("لا توجد نتائج"));
                          }
                          final item = widget.items[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedValue = widget.displayValue(item);
                                widget.onItemSelected(widget.idValue(item));
                                _closeDropdown();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.displayValue(item),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: widget.label == "اسم الشخص" ? 2 : 4,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: () {
                if (_isDropdownOpen) {
                  _closeDropdown();
                } else {
                  _openDropdown();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedValue ?? widget.hintText,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
