import 'package:flutter/material.dart';

class ReferTableScreen extends StatefulWidget {
  const ReferTableScreen({super.key});

  @override
  State<ReferTableScreen> createState() => _ReferTableScreenState();
}

class _ReferTableScreenState extends State<ReferTableScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Example data
    final List<Map<String, String>> referData = [
      {
        'referralId': 'Kaushik0001',
        'name': 'Anuj Kumar',
        'phone': '7678367852',
        'date': '04/05/2025',
      },
      {
        'referralId': 'Kaushik0002',
        'name': 'Priya Singh',
        'phone': '9876543210',
        'date': '10/06/2025',
      },
      {
        'referralId': 'Kaushik0003',
        'name': 'Rahul Sharma',
        'phone': '9123456789',
        'date': '15/06/2025',
      },
      {
        'referralId': 'Kaushik0001',
        'name': 'Anuj Kumar',
        'phone': '7678367852',
        'date': '04/05/2025',
      },
      {
        'referralId': 'Kaushik0002',
        'name': 'Priya Singh',
        'phone': '9876543210',
        'date': '10/06/2025',
      },
      {
        'referralId': 'Kaushik0003',
        'name': 'Rahul Sharma',
        'phone': '9123456789',
        'date': '15/06/2025',
      },
    ];

    // Example wallet balance
    const double walletBalance = 1250.50;

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
              height: 170,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white24,
                                  ),
                                  child: const Icon(Icons.credit_card,
                                      color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Kaushik Digital",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "**** 5678",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
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
              child: ListView.builder(
                itemCount: referData.length,
                itemBuilder: (context, index) {
                  final data = referData[index];
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
                                  data['name'] ?? '',
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
                                  data['referralId'] ?? '',
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
                                data['phone'] ?? '',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Color(0xFFD84315)),
                              const SizedBox(width: 6),
                              Text(
                                data['date'] ?? '',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
