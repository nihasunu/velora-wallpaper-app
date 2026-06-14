import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pexels_service.dart';
import 'detail_page.dart';
import 'favourites_page.dart';

class HomePage extends StatefulWidget {
  final String? moodQuery;
  const HomePage({super.key, this.moodQuery});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> wallpaperUrls = [];
  bool isLoading = true;
  String currentQuery = 'wallpaper';
  int selectedCategory = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'label': 'All',
      'query': 'wallpaper',
      'image':
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Nature',
      'query': 'nature',
      'image':
          'https://images.pexels.com/photos/1072179/pexels-photo-1072179.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Abstract',
      'query': 'abstract',
      'image':
          'https://images.pexels.com/photos/1939485/pexels-photo-1939485.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Minimal',
      'query': 'minimal',
      'image':
          'https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Architecture',
      'query': 'architecture',
      'image':
          'https://images.pexels.com/photos/凯/pexels-photo-凯.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Space',
      'query': 'space galaxy',
      'image':
          'https://images.pexels.com/photos/1529360/pexels-photo-1529360.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Aesthetic',
      'query': 'aesthetic',
      'image':
          'https://images.pexels.com/photos/931177/pexels-photo-931177.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Animals',
      'query': 'animals wildlife',
      'image':
          'https://images.pexels.com/photos/1661179/pexels-photo-1661179.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
    {
      'label': 'Landscape',
      'query': 'landscape',
      'image':
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=200',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.moodQuery != null) {
      currentQuery = widget.moodQuery!;
    }
    _loadWallpapers();
  }

  Future<void> _loadWallpapers() async {
    setState(() => isLoading = true);
    try {
      final urls = await PexelsService.fetchWallpapers(query: currentQuery);
      setState(() {
        wallpaperUrls = urls;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveRecentlyViewed(String url) async {
    // save logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBox(),
            _buildCategoryChips(),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Velora',
            style: GoogleFonts.greatVibes(fontSize: 30, color: Colors.white),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavouritesPage()),
            ),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                currentQuery = value;
                selectedCategory = -1;
              });
              _loadWallpapers();
            }
          },
          decoration: InputDecoration(
            hintText: 'Search wallpapers...',
            hintStyle: GoogleFonts.dmSans(color: Colors.white30, fontSize: 13),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white30,
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final bool isSelected = selectedCategory == index;
          final cat = categories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
                currentQuery = cat['query'];
              });
              _loadWallpapers();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: Image.network(
                        cat['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Container(color: Colors.grey.shade900),
                      ),
                    ),
                    // Dark overlay
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(
                          alpha: isSelected ? 0.3 : 0.55,
                        ),
                      ),
                    ),
                    // Label
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        cat['label'],
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    if (isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.65,
          ),
          itemCount: wallpaperUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _saveRecentlyViewed(wallpaperUrls[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      imageUrl: wallpaperUrls[index],
                      index: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      wallpaperUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFF1a1a1a),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white38,
                              strokeWidth: 1.5,
                            ),
                          ),
                        );
                      },
                    ),
                    // Download icon bottom right
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.download,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
