import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'sign_in_screen.dart';

class AccountCreatedScreen extends StatelessWidget {
  final String userName;

  const AccountCreatedScreen({
    super.key,
    this.userName = "Alex Chen",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Success Emblem
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "Account Created!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Welcome to MediCab, $userName.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your physical cabinet has been paired and encrypted. Default schedules and adherence notifications are initialized.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Provisioning Details Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceContainer),
                ),
                child: Column(
                  children: [
                    _buildFeatureRow(
                      Icons.inventory_2,
                      "Smart Cabinet Paired",
                      "Unit MC-IOT-98214 is online and synced.",
                    ),
                    const Divider(height: 20, color: AppColors.surfaceContainer),
                    _buildFeatureRow(
                      Icons.lock_clock,
                      "256-bit HIPAA Storage",
                      "Prescription logs encrypted end-to-end.",
                    ),
                    const Divider(height: 20, color: AppColors.surfaceContainer),
                    _buildFeatureRow(
                      Icons.alarm,
                      "Dose Reminders Active",
                      "Visual LED rings and chimes calibrated.",
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Proceed CTA Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Proceed to Sign In"),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

