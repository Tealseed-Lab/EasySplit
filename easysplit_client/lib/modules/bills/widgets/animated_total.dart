import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';

class AnimatedTotal extends StatefulWidget {
  final ReceiptStore receiptStore;

  const AnimatedTotal({super.key, required this.receiptStore});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedTotalState();
  }
}

class _AnimatedTotalState extends State<AnimatedTotal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.receiptStore.oldTotal.toDouble(),
      end: widget.receiptStore.total.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(_animationListener);
    _controller.forward();
  }

  void _animationListener() {
    if (_controller.isCompleted) {
      setState(() {
        widget.receiptStore.updateOldTotal();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedTotal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.receiptStore.total != widget.receiptStore.total) {
      _animation = Tween<double>(
        begin: widget.receiptStore.oldTotal.toDouble(),
        end: widget.receiptStore.total.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_animationListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          children: [
            Text(
              'Total:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                '\$${_animation.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        );
      },
    );
  }
}
