import 'package:flutter/material.dart';

class CustomMenu extends StatefulWidget {
  final bool isOpen;
  final Function onClose;

  const CustomMenu({super.key, required this.isOpen, required this.onClose});

  @override
  CustomMenuState createState() => CustomMenuState();
}

class CustomMenuState extends State<CustomMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the right
      end: const Offset(0.0, 0.0), // Slide to on-screen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The shadow effect on the rest of the screen
        if (widget.isOpen)
          GestureDetector(
            onTap: () => widget.onClose(),
            child: Container(
              color: Colors.black.withOpacity(0.05),
            ),
          ),

        // The sliding menu
        SlideTransition(
          position: _offsetAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              height: double.infinity,
              color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('قائمة 1', style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('قائمة 2', style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('قائمة 3', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
