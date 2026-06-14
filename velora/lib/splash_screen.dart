import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  String? selectedMood;

  final List<Map<String, dynamic>> moods = [
    {
      'emoji': '😊',
      'label': 'Happy',
      'query': 'bright sunny cheerful',
      'image':
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '😌',
      'label': 'Calm',
      'query': 'peaceful minimal calm',
      'image':
          'https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '🌙',
      'label': 'Moody',
      'query': 'dark dramatic moody',
      'image':
          'https://images.pexels.com/photos/1939485/pexels-photo-1939485.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '🔥',
      'label': 'Energetic',
      'query': 'vibrant colorful bold',
      'image':
          'https://images.pexels.com/photos/1843717/pexels-photo-1843717.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '🌿',
      'label': 'Fresh',
      'query': 'nature green forest',
      'image':
          'https://images.pexels.com/photos/1072179/pexels-photo-1072179.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '✨',
      'label': 'Dreamy',
      'query': 'pastel dreamy soft aesthetic',
      'image':
          'https://images.pexels.com/photos/1146242/pexels-photo-1146242.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '😍',
      'label': 'Romantic',
      'query': 'aesthetic pink soft romantic',
      'image':
          'https://images.pexels.com/photos/931177/pexels-photo-931177.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'emoji': '🌧',
      'label': 'Melancholic',
      'query': 'rain dark blue melancholic',
      'image':
          'https://images.pexels.com/photos/1529360/pexels-photo-1529360.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf8c8c8), Color(0xFFe8c8f0), Color(0xFFd0c8f8)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ── TOP: logo + tagline ──────────────────────────
                    Column(
                      children: [
                        const SizedBox(height: 52),
                        // Logo + Velora side by side
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.5),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.12),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFF5a2060),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Velora',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 36,
                                color: const Color(0xFF2a1030),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'every wallpaper tells a mood.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: Colors.black38,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),

                    // ── PROPORTIONAL GAP ────────────────────────────
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    Column(
                      children: [
                        // Mood question
                        Text(
                          "what's your mood",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 26,
                            color: const Color(0xFF2a1030),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          "today?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 26,
                            color: const Color(
                              0xFF2a1030,
                            ).withValues(alpha: 0.45),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'pick one to personalise your feed',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Mood grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                                childAspectRatio: 0.82,
                              ),
                          itemCount: moods.length,
                          itemBuilder: (_, i) {
                            final mood = moods[i];
                            final isSelected = selectedMood == mood['label'];
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedMood = mood['label']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2a1030)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        mood['image'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.black.withValues(
                                          alpha: isSelected ? 0.18 : 0.42,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 6,
                                        left: 0,
                                        right: 0,
                                        child: Column(
                                          children: [
                                            Text(
                                              mood['emoji'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              mood['label'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 9,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Enter Velora button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final query = selectedMood != null
                                  ? moods.firstWhere(
                                      (m) => m['label'] == selectedMood,
                                    )['query']
                                  : 'wallpaper';
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomePage(moodQuery: query),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2a1030),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              selectedMood != null
                                  ? 'Enter Velora'
                                  : 'Explore All',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Skip
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          ),
                          child: Text(
                            'skip for now',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
