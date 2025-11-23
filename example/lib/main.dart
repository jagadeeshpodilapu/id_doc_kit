import 'package:flutter/material.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  runApp(const IdDocKitExampleApp());
}

class IdDocKitExampleApp extends StatelessWidget {
  const IdDocKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ID Doc Kit Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IdFormScreen(),
    );
  }
}

class IdFormScreen extends StatefulWidget {
  const IdFormScreen({super.key});

  @override
  State<IdFormScreen> createState() => _IdFormScreenState();
}

class _IdFormScreenState extends State<IdFormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _aadhaarValid = false;
  bool _panValid = false;
  bool _dlValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ID Doc Kit Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IdTextField(
                type: IdDocumentType.aadhaar,
                label: "Aadhaar",
                onValidationChanged: (isValid) {
                  setState(() => _aadhaarValid = isValid);
                },
              ),
              const SizedBox(height: 16),
              IdTextField(
                type: IdDocumentType.pan,
                label: "PAN",
                onValidationChanged: (isValid) {
                  setState(() => _panValid = isValid);
                },
              ),
              const SizedBox(height: 16),
              IdTextField(
                type: IdDocumentType.drivingLicense,
                label: "Driving License",
                onValidationChanged: (isValid) {
                  setState(() => _dlValid = isValid);
                },
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  final valid = _formKey.currentState!.validate();
                  if (valid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All IDs are valid!")),
                    );
                  }
                },
                child: const Text("Validate"),
              ),

              const SizedBox(height: 16),

              Text(
                "Aadhaar: $_aadhaarValid\nPAN: $_panValid\nDL: $_dlValid",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
