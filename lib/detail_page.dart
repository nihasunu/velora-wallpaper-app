import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
  bool isSettingWallpaper = false;

  @override
  void initState() {
    super.initState();
    _checkFavourite();
  }

  Future<void> _checkFavourite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favourites') ?? [];
    setState(() => isFavourite = favs.contains(widget.imageUrl));
  }

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
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _shareImage() async {
    setState(() => isSharing = true);
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/share_temp.jpg');
      await file.writeAsBytes(response.bodyBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out this wallpaper from Velora!',
      );
    } catch (e) {
      await Share.share(widget.imageUrl);
    }
    setState(() => isSharing = false);
  }

  Future<void> _downloadImage() async {
    setState(() => isDownloading = true);
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      final result = await SaverGallery.saveImage(
        response.bodyBytes,
        quality: 100,
        name: "velora_${DateTime.now().millisecondsSinceEpoch}",
        androidExistNotSave: false,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              result.isSuccess ? 'Saved to gallery!' : 'Download failed'),
          backgroundColor: result.isSuccess
              ? const Color.fromARGB(255, 5, 5, 5)
              : const Color.fromARGB(255, 222, 24, 10),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed')),
      );
    }
    setState(() => isDownloading = false);
  }

  Future<void> _setWallpaper(WallpaperLocation location) async {
    setState(() => isSettingWallpaper = true);
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/wallpaper_temp.jpg');
      await file.writeAsBytes(response.bodyBytes);

      await WallpaperHandler.instance.setWallpaperFromFile(file.path, location);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallpaper set successfully!'),
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to set wallpaper'),
          backgroundColor: Color.fromARGB(255, 222, 24, 10),
        ),
      );
    }
    setState(() => isSettingWallpaper = false);
  }

  void _showWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Wallpaper As',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _wallpaperOption(
              icon: Icons.home_outlined,
              label: 'Home Screen',
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(WallpaperLocation.homeScreen);
              },
            ),
            const SizedBox(height: 14),
            _wallpaperOption(
              icon: Icons.lock_outline,
              label: 'Lock Screen',
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(WallpaperLocation.lockScreen);
              },
            ),
            const SizedBox(height: 14),
            _wallpaperOption(
              icon: Icons.phone_android_outlined,
              label: 'Both',
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(WallpaperLocation.bothScreens);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _wallpaperOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
        
          Positioned.fill(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),

          // Back button
          Positioned(
            top: 48,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
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
                 
                  Row(
                    children: [
                      GestureDetector(
                        onTap: isDownloading ? null : _downloadImage,
                        child: isDownloading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.download,
                                color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: isSharing ? null : _shareImage,
                        child: isSharing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.share,
                                color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: isSettingWallpaper
                            ? null
                            : _showWallpaperOptions,
                        child: isSettingWallpaper
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.wallpaper,
                                color: Colors.white, size: 26),
                      ),
                    ],
                  ),

                 
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