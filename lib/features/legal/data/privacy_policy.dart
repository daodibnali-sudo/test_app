import 'package:chelnok_boxing_timer/features/legal/models/legal_section.dart';

final privacyPolicySections = [
  const LegalSection(
    heading: 'Information We Collect',
    body:
        'Chelnok collects minimal personal information. We collect:\n\n'
        '• Device Information: Your device model, OS version, and unique device identifiers for app functionality\n'
        '• Usage Data: Workout sessions, timers used, and app settings (stored locally on your device)\n'
        '• Ad Data: Google Mobile Ads may collect information for personalized advertising\n\n'
        'We do NOT collect email, location, contacts, or other sensitive personal data.',
  ),
  const LegalSection(
    heading: 'How We Use Your Information',
    body:
        'Your information is used to:\n\n'
        '• Provide and maintain the Chelnok app\n'
        '• Display personalized advertisements\n'
        '• Improve app functionality and user experience\n'
        '• Comply with legal obligations\n\n'
        'All workout data is stored locally on your device. We do not upload your personal training sessions to external servers.',
  ),
  const LegalSection(
    heading: 'Data Storage & Security',
    body:
        'Your data is stored locally on your device using SharedPreferences. We implement reasonable security measures to protect your data. However, no method of transmission over the internet is 100% secure.\n\n'
        'By using Chelnok, you acknowledge that you understand the inherent risks of data transmission and use.',
  ),
  const LegalSection(
    heading: 'Third-Party Services',
    body:
        'Chelnok uses the following third-party services:\n\n'
        '• Google Mobile Ads: For displaying advertisements. Google may collect data for ad targeting and measurement.\n'
        '• Flutter Text-to-Speech: Uses device system TTS for audio announcements.\n'
        '• URL Launcher: Opens links in external browser\n\n'
        'These services are subject to their respective privacy policies. We recommend reviewing Google\'s privacy policy at https://policies.google.com/privacy.',
  ),
  const LegalSection(
    heading: 'Children\'s Privacy',
    body:
        'Chelnok is designed for athletes 13+. We do not knowingly collect data from children under 13. If we become aware that a child under 13 has used the app, we will take steps to delete such data.\n\n'
        'Parents: If your child has provided information to us, please contact us immediately.',
  ),
  const LegalSection(
    heading: 'Permissions',
    body:
        'Chelnok requests the following permissions:\n\n'
        '• VIBRATE: For haptic feedback during workouts\n'
        '• POST_NOTIFICATIONS: For workout notifications (Android 13+)\n'
        '• WAKE_LOCK: To keep the screen awake during active timer sessions\n\n'
        'You can manage these permissions in your device settings.',
  ),
  const LegalSection(
    heading: 'Changes to This Privacy Policy',
    body:
        'We may update this Privacy Policy from time to time. We will notify you of any changes by updating the "Last Updated" date at the bottom of this policy.',
  ),
  const LegalSection(
    heading: 'Contact Us',
    body:
        'If you have questions about this Privacy Policy or our privacy practices, please contact us at:\n\n'
        'Email: daodibnali@gmail.com\n'
        'Website: https://sites.google.com/view/chelnok-studios/\n\n'
        'Last Updated: July 2026',
  ),
];
