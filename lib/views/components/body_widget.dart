import 'package:flutter/material.dart';

/// A widget representing the body of a screen with optional loading indicator.
class BodyWidget extends StatelessWidget {
  /// Constructs a [BodyWidget] with required child and optional loading indicator parameters.
  const BodyWidget({
    required this.child,
    this.isLoading = false,
    this.padding,
    super.key,
  });

  /// Indicates whether the body is in a loading state.
  final bool isLoading;

  /// The main content of the body.
  final Widget child;

  /// The padding around the body content.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        IgnorePointer(
          ignoring: isLoading,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
        // Loading indicator
        if (isLoading)
          Material(
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.tertiary.withOpacity(0.5)
                : Theme.of(context).colorScheme.tertiary.withOpacity(.15),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
