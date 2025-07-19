import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaushik_digital/Providers/home_data_provider.dart';
import 'package:kaushik_digital/utils/preferences/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferTableScreen extends StatefulWidget {
  const ReferTableScreen({super.key});

  @override
  State<ReferTableScreen> createState() => _ReferTableScreenState();
}

class _ReferTableScreenState extends State<ReferTableScreen> {
  String? userId;
  String? referralId;

  @override
  void initState() {
    super.initState();

    _loadUserIdAndFetchReferrals();
  }

  Future<void> _loadUserIdAndFetchReferrals() async {
    final data = await UserPreferences.loadProfile();
    userId = data['userId']?.toString();
    referralId = data['ReferralId']?.toString();
    if (userId != null) {
      Provider.of<HomeDataProvider>(context, listen: false)
          .getReferalList(userId: userId!, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example wallet balance
    const double walletBalance = 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Table',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F), // Red shade
        automaticallyImplyLeading: false, // Hide back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Debit Card Style Wallet Card
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD32F2F), // Red
                    Color(0xFFC62828), // Darker Red
                    Color(0xFFFF7043), // Deep Orange
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -30,
                    left: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // Card content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Colors.white, size: 32),
                            SizedBox(width: 10),
                            Text(
                              "Available Balance",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "₹${walletBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Container(
                            //   width: 32,
                            //   height: 32,
                            //   decoration: const BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Colors.white24,
                            //   ),
                            //   child: const Icon(Icons.credit_card,
                            //       color: Colors.white, size: 18),
                            // ),
                            // const SizedBox(width: 10),
                            Expanded(
                              child: SelectableText(
                                referralId ?? 'KD1736595521953',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy,
                                  color: Colors.white70, size: 20),
                              tooltip: 'Copy Referral ID',
                              onPressed: () {
                                final id = referralId ?? 'KD1736595521953';
                                Clipboard.setData(ClipboardData(text: id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Referral ID copied!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share,
                                  color: Colors.white70, size: 20),
                              tooltip: 'Share Referral ID',
                              onPressed: () async {
                                final id = referralId ?? 'KD1736595521953';
                                await Share.share(
                                    'My referral ID For Kaushik Digital: $id');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Referral List
            Expanded(
              child: Consumer<HomeDataProvider>(
                builder: (context, homeProvider, child) {
                  if (homeProvider.isReferalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (homeProvider.referalList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No referrals found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: homeProvider.referalList.length,
                    itemBuilder: (context, index) {
                      final referal = homeProvider.referalList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Color(0xFFD32F2F), size: 28),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      referal.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFD32F2F),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFCDD2), // Red 100
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      referal.registrationNo,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFD32F2F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      size: 18,
                                      color: Color(0xFFD84315)), // Deep Orange
                                  const SizedBox(width: 6),
                                  Text(
                                    referal.phone,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black54),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.calendar_today,
                                      size: 18, color: Color(0xFFD84315)),
                                  const SizedBox(width: 6),
                                  Text(
                                    referal.createdAt.substring(0, 10),
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
