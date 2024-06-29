import 'package:flutter/material.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/util/extension.dart';

/// A widget representing the body of a screen with optional loading indicator.
class BodyWidget extends StatelessWidget {
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
            child: Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(14),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      width: 4,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    top: BorderSide(
                      width: 4,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    right: BorderSide(
                      width: 4,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    left: BorderSide(
                      width: 4,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (AppPrefHelper.getDisplayName() != '')
                      Text(
                        '''${AppPrefHelper.getDisplayName().beforeFirstSpace} Please wait''',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    else
                      Text(
                        'Hello, Please wait',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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
