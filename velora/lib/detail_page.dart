import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatefulWidget {
  final String imageUrl;
  final int index;

  const DetailPage({super.key, required this.imageUrl, required this.index});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavourite = false;
  bool isDownloading = false;
  bool isSharing = false;

  @override
  void initState() {
    super.initState();
    _checkFavourite();
  }

  // Check if already favourited
  Future<void> _checkFavourite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favourites') ?? [];
    setState(() => isFavourite = favs.contains(widget.imageUrl));
  }

  // Toggle favourite
  Future<void> _toggleFavourite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favourites') ?? [];
    if (isFavourite) {
      favs.remove(widget.imageUrl);
    } else {
      favs.add(widget.imageUrl);
    }
    await prefs.setStringList('favourites', favs);
    if (!mounted) return;
    setState(() => isFavourite = !isFavourite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavourite ? 'Added to favourites!' : 'Removed from favourites',
        ),
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Share image
  Future<void> _shareImage() async {
    setState(() => isSharing = true);
    await Share.share(
      widget.imageUrl,
      subject: 'Check out this wallpaper from Velora!',
    );
    setState(() => isSharing = false);
  }

  // Download image
  Future<void> _downloadImage() async {
    setState(() => isDownloading = true);
    try {
      final success = await GallerySaver.saveImage(widget.imageUrl);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success == true ? 'Saved to gallery!' : 'Download failed',
          ),
          backgroundColor: success == true
              ? const Color.fromARGB(255, 5, 5, 5)
              : const Color.fromARGB(255, 222, 24, 10),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Download failed')));
    }
    setState(() => isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen image
          Positioned.fill(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),

          // Top back button
          Positioned(
            top: 48,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.4,
                  ), // fixed: single dot
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // Bottom action buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Download + Share icons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: isDownloading ? null : _downloadImage,
                        child: isDownloading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 26,
                              ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: isSharing ? null : _shareImage,
                        child: isSharing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 26,
                              ),
                      ),
                    ],
                  ),

                  // Heart / favourite icon
                  GestureDetector(
                    onTap: _toggleFavourite,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavourite),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
