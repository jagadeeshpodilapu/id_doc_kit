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
      title: 'id_doc_kit Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  final _formKey = GlobalKey<FormState>();
  bool _panValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('id_doc_kit Examples'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ------------------------------------------------------------
              // ✅ 1) QUICK WIDGET: IdTextField (PAN)
              // ------------------------------------------------------------
              const Text(
                '1️⃣ IdTextField (Quick Integration)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              IdTextField(
                type: IdDocumentType.pan,
                decoration: const InputDecoration(
                  labelText: 'PAN Number',
                  border: OutlineInputBorder(),
                ),
                onValidationChanged: (isValid) {
                  setState(() => _panValid = isValid);
                },
              ),

              const SizedBox(height: 4),
              Text(
                _panValid ? 'PAN is valid ✅' : 'Enter a valid PAN',
                style: TextStyle(
                  fontSize: 12,
                  color: _panValid ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------------------
              // ✅ 2) LOGIC-ONLY: Custom TextFormField + validator
              // ------------------------------------------------------------
              const Text(
                '2️⃣ Custom TextFormField + idFormFieldValidator',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'GSTIN (Custom Field)',
                  border: OutlineInputBorder(),
                ),
                validator: idFormFieldValidator(
                  IdDocumentType.gstin,
                  requiredMessage: 'GSTIN is required',
                ),
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------------------
              // ✅ 3) ADVANCED CUSTOM UI: IdField (Builder)
              // ------------------------------------------------------------
              const Text(
                '3️⃣ IdField (Fully Custom UI)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              IdField(
                type: IdDocumentType.aadhaar,
                requiredMessage: 'Aadhaar is required',
                builder: (context, controller, result) {
                  final isValid = result?.isValid ?? false;
                  final errorText = (result != null && !result.isValid)
                      ? result.errorMessage
                      : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Aadhaar (Custom UI)',
                          border: const OutlineInputBorder(),
                          suffixIcon: isValid
                              ? const Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: Colors.green,
                                )
                              : null,
                          errorText: errorText,
                        ),
                      ),
                      if (isValid)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Valid Aadhaar ✅',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              // ------------------------------------------------------------
              // ✅ SUBMIT BUTTON
              // ------------------------------------------------------------
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All inputs are valid ✅')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
