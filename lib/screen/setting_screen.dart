import 'package:flutter/material.dart';

import 'SubScreen/setting_profile_screen.dart';

class SettingScreen extends StatelessWidget {
  final String userName;
  final String phone;
  final String email;

  const SettingScreen({
    super.key,
    required this.userName,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 14),
                            const SizedBox(width: 4),
                            Text(phone),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ProfileScreen(
                                      initialName: userName,
                                      initialEmail: '',
                                      initialPhone: phone,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            "See More >",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, size: 30),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Shortcuts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickTile(
                  icon: Icons.shopping_cart_outlined,
                  label: "Your Orders",
                ),
                _QuickTile(
                  icon: Icons.support_agent_outlined,
                  label: "Help & Support",
                ),
                _QuickTile(icon: Icons.wallet, label: "Wallet"),
              ],
            ),

            const SizedBox(height: 20),

            // Information Section
            const Text(
              "Information",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.75,
                children: const [
                  _InfoTile(
                    icon: Icons.shopping_cart_outlined,
                    label: "Your Orders",
                  ),
                  _InfoTile(icon: Icons.redeem_sharp, label: "Rewards"),
                  _InfoTile(icon: Icons.keyboard_return, label: "Refunds"),
                  _InfoTile(icon: Icons.person_3_rounded, label: "Profile"),
                  _InfoTile(icon: Icons.card_giftcard, label: "Refer & earn"),
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: "Saved Address",
                  ),
                  _InfoTile(icon: Icons.wallet, label: "Wallet"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Other Information
            const Text(
              "Other Information",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  _OtherItem(icon: Icons.share, label: "Share the app"),
                  _OtherItem(icon: Icons.info_outline, label: "About us"),
                  _OtherItem(icon: Icons.star_border, label: "Rate us"),
                  _OtherItem(icon: Icons.notifications, label: "Notification"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Logout
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // handle logout
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey[300],
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: Icon(icon, color: Colors.black, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OtherItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OtherItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        // handle navigation
      },
    );
  }
}
