import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/legal/data/legal_documents.dart';
import 'package:chelnok_boxing_timer/features/legal/models/legal_section.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({
    super.key,
    required this.title,
    required this.sections,
    this.subtitle,
    this.externalUrl,
    this.showContactButton = false,
  });

  final String title;
  final String? subtitle;
  final List<LegalSection> sections;
  final String? externalUrl;
  final bool showContactButton;

  bool get _hasPublicExternalUrl {
    final url = externalUrl;
    if (url == null || url.contains('ADD_PUBLIC')) return false;

    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'https' || uri.scheme == 'http');
  }

  Future<void> _openExternalUrl() async {
    final url = externalUrl;
    if (!_hasPublicExternalUrl || url == null) return;

    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEmail() async {
    final uri = Uri(scheme: 'mailto', path: legalContactEmail);
    if (!await canLaunchUrl(uri)) return;

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: AppBar(
        backgroundColor: AppColors.blackBg,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heading.copyWith(fontSize: 24),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.cyanLight.withAlpha(200),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.heading.copyWith(fontSize: 30)),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              for (final section in sections) ...[
                if (section.heading != null) ...[
                  Text(
                    section.heading!,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.cyanLight,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  section.body,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.48,
                  ),
                ),
                const SizedBox(height: 22),
              ],
              if (_hasPublicExternalUrl) ...[
                const SizedBox(height: 4),
                AppButton(
                  text: 'OPEN WEB VERSION',
                  leading: const Icon(Icons.open_in_new),
                  backgroundColor: AppColors.blackSurface,
                  borderColor: AppColors.cyanLight,
                  textColor: AppColors.cyanLight,
                  iconColor: AppColors.cyanLight,
                  filled: false,
                  onPressed: _openExternalUrl,
                ),
              ],
              if (showContactButton) ...[
                const SizedBox(height: 4),
                AppButton(
                  text: 'CONTACT US',
                  leading: const Icon(Icons.mail_outline),
                  backgroundColor: AppColors.cyanLight,
                  iconColor: AppColors.blackBg,
                  textStyle: const TextStyle(
                    color: AppColors.blackBg,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  onPressed: _openEmail,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
