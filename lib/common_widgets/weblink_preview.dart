import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLinkPreview extends StatelessWidget {
  final String url;

  const WebLinkPreview({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.link),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                url,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
