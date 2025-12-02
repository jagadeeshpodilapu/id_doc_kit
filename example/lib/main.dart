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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
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
  bool _gstinValid = false;
  bool _aadhaarValid = false;
  bool _voterIdValid = false;
  bool _passportValid = false;
  bool _drivingLicenseValid = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ID Document Kit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header Section
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 48,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Document Validation Examples',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore different ways to validate Indian ID documents',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer.withOpacity(
                            0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section 1: Quick Integration
              _buildSectionCard(
                context,
                title: 'Quick Integration',
                subtitle: 'IdTextField Widget',
                icon: Icons.flash_on,
                iconColor: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IdTextField(
                      type: IdDocumentType.pan,
                      decoration: InputDecoration(
                        labelText: 'PAN Number',
                        hintText: 'ABCDE1234F',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      onValidationChanged: (isValid) {
                        setState(() => _panValid = isValid);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      isValid: _panValid,
                      message: _panValid ? 'PAN is valid' : 'Enter a valid PAN',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section 2: Custom Field with Validator
              _buildSectionCard(
                context,
                title: 'Custom Field',
                subtitle: 'TextFormField + Validator',
                icon: Icons.tune,
                iconColor: Colors.purple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'GSTIN Number',
                        hintText: '27AAAAA0000A1Z5',
                        prefixIcon: const Icon(Icons.business),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: idFormFieldValidator(
                        IdDocumentType.gstin,
                        requiredMessage: 'GSTIN is required',
                      ),
                      onChanged: (value) {
                        final result = IdValidator.instance.validate(
                          type: IdDocumentType.gstin,
                          value: value,
                        );
                        setState(() => _gstinValid = result.isValid);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section 3: Advanced Custom UI
              _buildSectionCard(
                context,
                title: 'Advanced Custom UI',
                subtitle: 'IdField Builder Pattern',
                icon: Icons.code,
                iconColor: Colors.teal,
                child: IdField(
                  type: IdDocumentType.aadhaar,
                  requiredMessage: 'Aadhaar is required',
                  builder: (context, controller, result) {
                    final isValid = result?.isValid ?? false;
                    final errorText = (result != null && !result.isValid)
                        ? result.errorMessage
                        : null;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() => _aadhaarValid = isValid);
                      }
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Aadhaar Number',
                            hintText: '1234 5678 9012',
                            prefixIcon: const Icon(Icons.fingerprint),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: colorScheme.surface,
                            suffixIcon: isValid
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade600,
                                  )
                                : null,
                            errorText: errorText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildValidationStatus(
                          context,
                          isValid: isValid,
                          message: isValid
                              ? 'Aadhaar is valid'
                              : 'Enter a valid Aadhaar',
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Section 4: Other Documents
              _buildSectionCard(
                context,
                title: 'Other Documents',
                subtitle: 'Quick Examples',
                icon: Icons.description,
                iconColor: Colors.indigo,
                child: Column(
                  children: [
                    IdTextField(
                      type: IdDocumentType.voterId,
                      decoration: InputDecoration(
                        labelText: 'Voter ID',
                        prefixIcon: const Icon(Icons.how_to_vote),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      onValidationChanged: (isValid) {
                        setState(() => _voterIdValid = isValid);
                      },
                    ),
                    const SizedBox(height: 12),
                    IdTextField(
                      type: IdDocumentType.passport,
                      decoration: InputDecoration(
                        labelText: 'Passport Number',
                        prefixIcon: const Icon(Icons.airplane_ticket),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      onValidationChanged: (isValid) {
                        setState(() => _passportValid = isValid);
                      },
                    ),
                    const SizedBox(height: 12),
                    IdTextField(
                      type: IdDocumentType.drivingLicense,
                      decoration: InputDecoration(
                        labelText: 'Driving License',
                        prefixIcon: const Icon(Icons.drive_eta),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      onValidationChanged: (isValid) {
                        setState(() => _drivingLicenseValid = isValid);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('All inputs are valid!'),
                            ],
                          ),
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Validate All Documents',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildValidationStatus(
    BuildContext context, {
    required bool isValid,
    required String message,
  }) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.error_outline,
          size: 16,
          color: isValid ? Colors.green.shade600 : Colors.orange.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          message,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isValid ? Colors.green.shade600 : Colors.orange.shade600,
          ),
        ),
      ],
    );
  }
}
