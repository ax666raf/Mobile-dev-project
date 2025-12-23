import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

class LanguageSelector extends StatelessWidget {
  final Function(Locale) onLocaleChanged;
  
  const LanguageSelector({
    super.key,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showLanguageDialog(context),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.language,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.selectLanguage,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(
              context,
              flag: '🇬🇧',
              name: l10n.english,
              locale: const Locale('en'),
            ),
            const Divider(),
            _buildLanguageTile(
              context,
              flag: '🇩🇿',
              name: l10n.arabic,
              locale: const Locale('ar'),
            ),
            const Divider(),
            _buildLanguageTile(
              context,
              flag: '🇫🇷',
              name: l10n.french,
              locale: const Locale('fr'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String flag,
    required String name,
    required Locale locale,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 28)),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        onLocaleChanged(locale);
        Navigator.pop(context);
      },
    );
  }
}

class LanguageButton extends StatelessWidget {
  final Function(Locale) onLocaleChanged;
  final Color? iconColor;
  
  const LanguageButton({
    super.key,
    required this.onLocaleChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return PopupMenuButton<Locale>(
      icon: Icon(Icons.language, color: iconColor ?? primaryColor),
      onSelected: onLocaleChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇬🇧', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(l10n.english),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('ar'),
          child: Row(
            children: [
              const Text('🇩🇿', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(l10n.arabic),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('fr'),
          child: Row(
            children: [
              const Text('🇫🇷', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(l10n.french),
            ],
          ),
        ),
      ],
    );
  }
}


