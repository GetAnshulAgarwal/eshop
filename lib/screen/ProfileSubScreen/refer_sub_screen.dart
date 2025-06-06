import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/Referals/referal_services.dart';

class ReferFriendsScreen extends StatefulWidget {
  @override
  _ReferFriendsScreenState createState() => _ReferFriendsScreenState();
}

class _ReferFriendsScreenState extends State<ReferFriendsScreen> {
  late String _referralCode;
  bool _rulesExpanded = false;
  bool _faqsExpanded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReferralCode();
  }

  Future<void> _loadReferralCode() async {
    try {
      final code = await ReferralService.getReferralCode();
      setState(() {
        _referralCode = code;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to local generation if service fails
      _generateReferralCode();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _generateReferralCode() {
    // Generate a random 3-digit number
    final random = Random();
    final randomNum = random.nextInt(900) + 100; // 100-999

    // Create a referral code with format "GOWREF" + random number
    _referralCode = 'GOWREF$randomNum';
  }

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Referral code copied to clipboard')),
    );
  }

  void _inviteFromContacts() {
    // In a real app, this would open contact picker
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opening contacts...')));
  }

  void _referNow() {
    // In a real app, this would open share dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing referral code: $_referralCode')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Refer Friends',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Main content area with scroll
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Referral Card
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFAA33),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Invite you Friends\nto use\nGrocery on Wheels',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            height: 1.3,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: _copyReferralCode,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xBB800000),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  _referralCode,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.copy,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Positioned Person with Megaphone Image
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/refers.png',
                                      height: 120,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            // Rules Section
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text(
                                    'Rules',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: Icon(
                                    _rulesExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  onExpansionChanged: (expanded) {
                                    setState(() {
                                      _rulesExpanded = expanded;
                                    });
                                  },
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        0,
                                        16,
                                        16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RuleItem(
                                            number: '1',
                                            text:
                                                'Share your unique code with friends.',
                                          ),
                                          RuleItem(
                                            number: '2',
                                            text:
                                                'When they sign up using your code, they get ₹100 off on their first order.',
                                          ),
                                          RuleItem(
                                            number: '3',
                                            text:
                                                'You\'ll receive ₹100 in your wallet once they complete their first order.',
                                          ),
                                          RuleItem(
                                            number: '4',
                                            text:
                                                'There\'s no limit on how many friends you can refer!',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            // FAQs Section
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text(
                                    'FAQs',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: Icon(
                                    _faqsExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  onExpansionChanged: (expanded) {
                                    setState(() {
                                      _faqsExpanded = expanded;
                                    });
                                  },
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        0,
                                        16,
                                        16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FaqItem(
                                            question:
                                                'How do I refer a friend?',
                                            answer:
                                                'Simply share your unique referral code with them. They can enter this code when signing up for a new account.',
                                          ),
                                          FaqItem(
                                            question:
                                                'When will I receive my reward?',
                                            answer:
                                                'You\'ll receive your reward within 24 hours after your friend completes their first order.',
                                          ),
                                          FaqItem(
                                            question:
                                                'Is there a limit to how many people I can refer?',
                                            answer:
                                                'No, there\'s no limit! The more you refer, the more rewards you earn.',
                                          ),
                                          FaqItem(
                                            question:
                                                'How long is my referral code valid?',
                                            answer:
                                                'Your referral code never expires, so you can keep sharing it as long as you like.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Add extra space at the bottom for safety
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Fixed buttons at the bottom
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Contact Button
                        ElevatedButton(
                          onPressed: _inviteFromContacts,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text(
                            'Invite from contact',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Refer Now Button
                        ElevatedButton(
                          onPressed: _referNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xBB890800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            minimumSize: Size(double.infinity, 20),
                          ),
                          child: Text(
                            'Refer Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

// RuleItem and FaqItem classes remain the same as before

class RuleItem extends StatelessWidget {
  final String number;
  final String text;

  const RuleItem({Key? key, required this.number, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFFFFAA33).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Color(0xBB800000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({Key? key, required this.question, required this.answer})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
