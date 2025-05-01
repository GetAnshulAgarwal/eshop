import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;

  const ProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  bool isEditingName = false;
  bool isEditingEmail = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, size: 60),
                  ),

                  SizedBox(height: 20),
                  // NAME ROW
                  _buildRow(
                    label: "NAME",
                    controller: nameController,
                    isEditing: isEditingName,
                    onEditTap: () {
                      setState(() {
                        isEditingName = true;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // EMAIL ROW
                  _buildRow(
                    label: "Email",
                    controller: emailController,
                    isEditing: isEditingEmail,
                    onEditTap: () {
                      setState(() {
                        isEditingEmail = true;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // PHONE ROW (not editable)
                  _buildStaticRow(
                    label: "Phone No.",
                    value: widget.initialPhone,
                  ),

                  const SizedBox(height: 30),

                  // DONE Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isEditingName = false;
                        isEditingEmail = false;
                      });
                      print("Saved name: ${nameController.text}");
                      print("Saved email: ${emailController.text}");
                    },
                    child: const Text(
                      "DONE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditTap,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$label :",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 4,
          child:
              isEditing
                  ? TextField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                  : Text(controller.text, style: const TextStyle(fontSize: 16)),
        ),
        if (!isEditing)
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: onEditTap,
          ),
      ],
    );
  }

  Widget _buildStaticRow({required String label, required String value}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$label :",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(value, style: const TextStyle(color: Colors.blueGrey)),
        ),
      ],
    );
  }
}
