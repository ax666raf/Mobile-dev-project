import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/main.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/backgroundImage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 58.0, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Language selector + Title and Description
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language selector button
                    Align(
                      alignment: Alignment.topRight,
                      child: _buildLanguageButton(context),
                    ),
                    
                    const SizedBox(height: 20),

                    // title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcomeTo,
                          style: TextStyle(color: Colors.white, fontSize: 48),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            Text(
                              l10n.appName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Image.asset('lib/assets/MainFrame.png', width: 48, height: 48),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // description
                    Text(
                      l10n.welcomeDescription,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Bottom section: Button
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: MyButton(
                  text: l10n.getStarted,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLanguageButton(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
          ],
        ),
      ),
      onSelected: (Locale locale) {
        MyApp.setLocale(context, locale);
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return [
          PopupMenuItem(
            value: const Locale('en'),
            child: Row(
              children: [
                const Text('🇬🇧', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Text(l10n.english, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: const Locale('ar'),
            child: Row(
              children: [
                const Text('🇩🇿', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Text(l10n.arabic, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: const Locale('fr'),
            child: Row(
              children: [
                const Text('🇫🇷', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Text(l10n.french, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ];
      },
    );
  }
}
