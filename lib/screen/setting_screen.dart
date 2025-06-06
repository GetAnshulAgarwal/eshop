import 'package:eshop/screen/ProfileSubScreen/refer_sub_screen.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../authentication/user_data.dart';
import 'ProfileSubScreen/Wallet/refund_screen.dart';
import 'ProfileSubScreen/Wallet/wallet_Screen.dart';
import 'ProfileSubScreen/about_us_screen.dart';
import 'ProfileSubScreen/app_notification_screen.dart';
import 'ProfileSubScreen/help_and_support_screen.dart';
import 'ProfileSubScreen/rate_us_screen.dart';
import 'ProfileSubScreen/reward_screen.dart';
import 'ProfileSubScreen/saved_address_screen.dart';
import 'ProfileSubScreen/your_order_screen.dart';
import 'SubScreen/setting_profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userName = 'Guest User';
  String phone = '';
  String email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    final userData = UserData();
    final loadedName = await userData.getName();
    final loadedPhone = await userData.getPhone();
    final loadedEmail = await userData.getEmail();

    setState(() {
      userName = loadedName;
      phone = loadedPhone;
      email = loadedEmail;
      _isLoading = false;
    });
  }

  // Method to share the app
  void _shareApp(BuildContext context) {
    const String appLink =
        'https://play.google.com/store/apps/details?id=com.groceryonwheels.app';
    const String shareMessage =
        'Check out Grocery on Wheels, a convenient way to get groceries delivered! Download now: $appLink';

    Share.share(shareMessage);
  }

  Future<void> _logOut() async {
    final userData = UserData();
    await userData.clearUserData();
    Navigator.pushReplacementNamed(context, '/login');
  }

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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                    Text(
                                      phone.isNotEmpty
                                          ? phone
                                          : 'No phone added',
                                    ),
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
                                              initialEmail: email,
                                              initialPhone: phone,
                                            ),
                                      ),
                                    ).then((_) => _loadUserData());
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
                      children: [
                        _QuickTile(
                          icon: Icons.shopping_cart_outlined,
                          label: "Your Orders",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrdersScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickTile(
                          icon: Icons.support_agent_outlined,
                          label: "Help & Support",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatWithSupport(),
                              ),
                            );
                          },
                        ),
                        _QuickTile(
                          icon: Icons.wallet,
                          label: "Wallet",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalletScreen(),
                              ),
                            );
                          },
                        ),
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
                        children: [
                          _InfoTile(
                            icon: Icons.shopping_cart_outlined,
                            label: "Your Orders",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrdersScreen(),
                                ),
                              );
                            },
                          ),
                          _InfoTile(
                            icon: Icons.redeem_sharp,
                            label: "Rewards",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RewardsScreen(),
                                ),
                              );
                            },
                          ),
                          _InfoTile(
                            icon: Icons.keyboard_return,
                            label: "Refunds",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RefundsScreen(),
                                ),
                              );
                            },
                          ),
                          _InfoTile(
                            icon: Icons.person_3_rounded,
                            label: "Profile",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ProfileScreen(
                                        initialName: userName,
                                        initialEmail: email,
                                        initialPhone: phone,
                                      ),
                                ),
                              ).then((_) => _loadUserData());
                            },
                          ),
                          _InfoTile(
                            icon: Icons.card_giftcard,
                            label: "Refer & earn",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferFriendsScreen(),
                                ),
                              );
                            },
                          ),
                          _InfoTile(
                            icon: Icons.location_on_outlined,
                            label: "Saved Address",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressScreen(),
                                ),
                              );
                            },
                          ),
                          _InfoTile(
                            icon: Icons.wallet,
                            label: "Wallet",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletScreen(),
                                ),
                              );
                            },
                          ),
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
                        children: [
                          // Share the app
                          _OtherItem(
                            icon: Icons.share,
                            label: "Share the app",
                            onTap: () => _shareApp(context),
                          ),

                          // About us
                          _OtherItem(
                            icon: Icons.info_outline,
                            label: "About us",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutUsScreen(),
                                ),
                              );
                            },
                          ),

                          // Rate us
                          _OtherItem(
                            icon: Icons.star_border,
                            label: "Rate us",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RateUsScreen(),
                                ),
                              );
                            },
                          ),

                          // Notification
                          _OtherItem(
                            icon: Icons.notifications,
                            label: "Notification",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },
                          ),
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
                          // Show logout confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                  "Are you sure you want to logout?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      _logOut();
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              );
                            },
                          );
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
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}

class _OtherItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OtherItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
