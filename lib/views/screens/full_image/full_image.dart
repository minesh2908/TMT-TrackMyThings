import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  const FullImage({required this.imageUrl, super.key});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel_sharp,
              size: 28,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 12),
        //     child: Icon(
        //       Icons.download,
        //       size: 28,
        //       color: Theme.of(context).colorScheme.scrim,
        //     ),
        //   ),
        // ],
      ),
      body: Image.network(
        imageUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
