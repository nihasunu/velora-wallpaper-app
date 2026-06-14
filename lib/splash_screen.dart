import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String? selectedMood;

  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  String _displayedWelcome = '';
  final String _fullWelcome = 'Welcome';

  
  late AnimationController _todayController;
  late Animation<double> _todayFade;

  final List<Map<String, dynamic>> moods = [
    {'label': 'Calm', 'query': 'calm peaceful serene minimal'},
    {'label': 'Melancholic', 'query': 'melancholic moody rain fog'},
    {'label': 'Moody', 'query': 'moody dark dramatic aesthetic'},
    {'label': 'Romantic', 'query': 'romantic soft warm sunset'},
    {'label': 'Dreamy', 'query': 'dreamy pastel soft clouds'},
    {'label': 'Vibrant', 'query': 'vibrant colorful bold energy'},
    {'label': 'Minimal', 'query': 'minimal clean white simple'},
    {'label': 'Nostalgic', 'query': 'nostalgic vintage film retro'},
    {'label': 'Ethereal', 'query': 'ethereal mystical light fog'},
  ];

  @override
  void initState() {
    super.initState();

    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    
    _todayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _todayFade = CurvedAnimation(
      parent: _todayController,
      curve: Curves.easeIn,
    );

    _startSequence();
  }

  void _startSequence() async {
    
    await _fadeController.forward();

    for (int i = 1; i <= _fullWelcome.length; i++) {
      await Future.delayed(const Duration(milliseconds: 85));
      if (!mounted) return;
      setState(() => _displayedWelcome = _fullWelcome.substring(0, i));
    }

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    _todayController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _todayController.dispose();
    super.dispose();
  }

  void _onMoodTap(String mood) {
    setState(() {
      selectedMood = selectedMood == mood ? null : mood;
    });
  }

  void _navigate(String? query) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(moodQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedQuery = moods
        .firstWhere(
          (m) => m['label'] == selectedMood,
          orElse: () => {'query': null},
        )['query'] as String?;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),

              
              FadeTransition(
                opacity: _fadeAnim,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Velora',
                      style: GoogleFonts.greatVibes(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

            
              FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  'Every wallpaper tells a mood.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 12,
                    color: const Color.fromARGB(176, 255, 249, 249),
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 60),

  
              SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    _displayedWelcome,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                      fontSize: 74,
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(255, 244, 229, 229),
                      letterSpacing: 1.5,
                      height: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 44),

              
              FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  "What's your mood",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 216, 204, 204),
                    height: 1.3,
                  ),
                ),
              ),

      
              FadeTransition(
                opacity: _todayFade,
                child: Text(
                  "today?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cuprum(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 243, 239, 239),
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  'Pick one to personalize your feed.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color.fromARGB(165, 226, 225, 225),
                  ),
                ),
              ),

              const SizedBox(height: 12),

      
              FadeTransition(
                opacity: _fadeAnim,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 10,
                    children: moods.map((mood) {
                      final label = mood['label'] as String;
                      final isSelected = selectedMood == label;
                      return GestureDetector(
                        onTap: () => _onMoodTap(label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.14)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? const Color.fromARGB(179, 220, 207, 207)
                                  : const Color.fromARGB(255, 236, 217, 217)
                                      .withValues(alpha: 0.18),
                              width: 1.1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            label,
                            style: GoogleFonts.dmSans(
                              fontSize: 12.5,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 58),

              // Explore button
              FadeTransition(
                opacity: _fadeAnim,
                child: GestureDetector(
                  onTap: () => _navigate(selectedQuery),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: selectedMood != null
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.06),
                      border: Border.all(
                        color: selectedMood != null
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.18),
                        width: 1.1,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selectedMood != null
                              ? Colors.black
                              : const Color.fromARGB(238, 218, 213, 213),
                        ),
                        child: Text(
                          selectedMood != null
                              ? 'Explore $selectedMood Wallpapers →'
                              : 'Explore All',
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}