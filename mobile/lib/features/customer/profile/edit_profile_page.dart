import 'package:flutter/material.dart';

class EditProfilePage
    extends StatelessWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Edit Profil"),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [
            TextFormField(
              decoration:
                  const InputDecoration(
                labelText:
                    "Nama Lengkap",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextFormField(
              decoration:
                  const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Simpan",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}