import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final void Function() onIncrement;
  final void Function() onDecrement;

  const CounterWidget({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final widthB = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthB * 0.015),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(widthB * 0.1),
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthB * 0.015),
              child: SizedBox(
                width: widthB * 0.06,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '$value',
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
