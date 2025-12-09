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

  // Controllers for fields we want to inspect directly
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _gstinController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _dlController = TextEditingController();
  final TextEditingController _voterController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Map to hold latest friendly message per document type
  final Map<IdDocumentType, String> _messages = {};

  // Map to hold latest validity boolean per doc type (optional)
  final Map<IdDocumentType, bool> _validity = {};

  @override
  void initState() {
    super.initState();

    // Initialize listeners to compute friendly messages in real-time
    _panController.addListener(
      () => _computeMessage(IdDocumentType.pan, _panController.text),
    );
    _gstinController.addListener(
      () => _computeMessage(IdDocumentType.gstin, _gstinController.text),
    );
    _aadhaarController.addListener(
      () => _computeMessage(IdDocumentType.aadhaar, _aadhaarController.text),
    );
    _dlController.addListener(
      () => _computeMessage(IdDocumentType.drivingLicense, _dlController.text),
    );
    _voterController.addListener(
      () => _computeMessage(IdDocumentType.voterId, _voterController.text),
    );
    _passportController.addListener(
      () => _computeMessage(IdDocumentType.passport, _passportController.text),
    );
    _pinController.addListener(
      () => _computeMessage(IdDocumentType.pinCode, _pinController.text),
    );
    _phoneController.addListener(
      () => _computeMessage(IdDocumentType.phone, _phoneController.text),
    );
    _emailController.addListener(
      () => _computeMessage(IdDocumentType.email, _emailController.text),
    );
  }

  @override
  void dispose() {
    _panController.dispose();
    _gstinController.dispose();
    _aadhaarController.dispose();
    _dlController.dispose();
    _voterController.dispose();
    _passportController.dispose();
    _pinController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _computeMessage(IdDocumentType type, String value) {
    // Avoid heavy work for empty values
    if (value.trim().isEmpty) {
      setState(() {
        _messages[type] = '';
        _validity[type] = false;
      });
      return;
    }

    final result = IdValidator.instance.validate(type: type, value: value);
    setState(() {
      _messages[type] = result.friendlyMessage;
      _validity[type] = result.isValid;
    });
  }

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
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
                          color: colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section 1: Quick Integration (PAN) - Using TextFormField + friendlyMessage
              _buildSectionCard(
                context,
                title: 'Quick Integration',
                subtitle: 'TextFormField + UI messages',
                icon: Icons.flash_on,
                iconColor: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _panController,
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
                      validator: (value) {
                        final v = value ?? '';
                        final r = IdValidator.instance.validate(
                          type: IdDocumentType.pan,
                          value: v,
                        );
                        return r.isValid ? null : r.friendlyMessage;
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      type: IdDocumentType.pan,
                      message: _messages[IdDocumentType.pan] ?? '',
                      isValid: _validity[IdDocumentType.pan] ?? false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Custom Field with Validator (GSTIN) - show friendly messages
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
                      controller: _gstinController,
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
                      validator: (value) {
                        final v = value ?? '';
                        final r = IdValidator.instance.validate(
                          type: IdDocumentType.gstin,
                          value: v,
                        );
                        return r.isValid ? null : r.friendlyMessage;
                      },
                      onChanged: (v) {},
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      type: IdDocumentType.gstin,
                      message: _messages[IdDocumentType.gstin] ?? '',
                      isValid: _validity[IdDocumentType.gstin] ?? false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section 3: Advanced Custom UI (Aadhaar)
              _buildSectionCard(
                context,
                title: 'Advanced Custom UI',
                subtitle: 'IdField Builder Pattern',
                icon: Icons.code,
                iconColor: Colors.teal,
                child: IdField(
                  type: IdDocumentType.aadhaar,
                  requiredMessage: 'Aadhaar is required',
                  controller:
                      _aadhaarController, // if your IdField supports controller
                  builder: (context, controller, result) {
                    final isValid = result?.isValid ?? false;
                    final errorText = (result != null && !result.isValid)
                        ? result
                              .friendlyMessage // use friendly message here
                        : null;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {}
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
                          type: IdDocumentType.aadhaar,
                          message: _messages[IdDocumentType.aadhaar] ?? '',
                          isValid: _validity[IdDocumentType.aadhaar] ?? false,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Section 4: Other Documents (using IdTextField and onChanged to compute messages)
              _buildSectionCard(
                context,
                title: 'Other Documents',
                subtitle: 'Quick Examples',
                icon: Icons.description,
                iconColor: Colors.indigo,
                child: Column(
                  children: [
                    // Voter ID
                    IdTextField(
                      type: IdDocumentType.voterId,
                      controller:
                          _voterController, // if IdTextField supports controller
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
                        // validation boolean -> compute full result for message
                        final res = IdValidator.instance.validate(
                          type: IdDocumentType.voterId,
                          value: _voterController.text,
                        );
                        setState(() {
                          _messages[IdDocumentType.voterId] =
                              res.friendlyMessage;
                          _validity[IdDocumentType.voterId] = res.isValid;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Passport
                    IdTextField(
                      type: IdDocumentType.passport,
                      controller: _passportController,
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
                        final res = IdValidator.instance.validate(
                          type: IdDocumentType.passport,
                          value: _passportController.text,
                        );
                        setState(() {
                          _messages[IdDocumentType.passport] =
                              res.friendlyMessage;
                          _validity[IdDocumentType.passport] = res.isValid;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Driving License (manual input)
                    TextFormField(
                      controller: _dlController,
                      decoration: InputDecoration(
                        labelText: 'Driving License',
                        prefixIcon: const Icon(Icons.drive_eta),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        final r = IdValidator.instance.validate(
                          type: IdDocumentType.drivingLicense,
                          value: v,
                        );
                        return r.isValid ? null : r.friendlyMessage;
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      type: IdDocumentType.drivingLicense,
                      message: _messages[IdDocumentType.drivingLicense] ?? '',
                      isValid:
                          _validity[IdDocumentType.drivingLicense] ?? false,
                    ),
                    const SizedBox(height: 12),

                    // PIN Code
                    TextFormField(
                      controller: _pinController,
                      decoration: InputDecoration(
                        labelText: 'Pin Code',
                        prefixIcon: const Icon(Icons.pin_drop_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        final r = IdValidator.instance.validate(
                          type: IdDocumentType.pinCode,
                          value: v,
                        );
                        return r.isValid ? null : r.friendlyMessage;
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      type: IdDocumentType.pinCode,
                      message: _messages[IdDocumentType.pinCode] ?? '',
                      isValid: _validity[IdDocumentType.pinCode] ?? false,
                    ),
                    const SizedBox(height: 12),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.mobile_friendly),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        final r = IdValidator.instance.validate(
                          type: IdDocumentType.phone,
                          value: v,
                        );
                        return r.isValid ? null : r.friendlyMessage;
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      type: IdDocumentType.phone,
                      message: _messages[IdDocumentType.phone] ?? '',
                      isValid: _validity[IdDocumentType.phone] ?? false,
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        final r = IdValidator.instance.validate(
                          type: IdDocumentType.email,
                          value: v,
                        );
                        return r.isValid ? null : r.friendlyMessage;
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildValidationStatus(
                      context,
                      type: IdDocumentType.email,
                      message: _messages[IdDocumentType.email] ?? '',
                      isValid: _validity[IdDocumentType.email] ?? false,
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
                    // compute final messages (in case controllers changed but listeners didn't fire)
                    _computeAllMessages();

                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text('All inputs are valid!')),
                            ],
                          ),
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } else {
                      // Show first invalid message
                      final firstInvalid = _messages.entries.firstWhere(
                        (e) =>
                            (_validity[e.key] ?? false) == false &&
                            (e.value.isNotEmpty),
                        orElse: () =>
                            MapEntry(IdDocumentType.pan, 'Please check inputs'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(firstInvalid.value)),
                            ],
                          ),
                          backgroundColor: Colors.orange.shade700,
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

  void _computeAllMessages() {
    _computeMessage(IdDocumentType.pan, _panController.text);
    _computeMessage(IdDocumentType.gstin, _gstinController.text);
    _computeMessage(IdDocumentType.aadhaar, _aadhaarController.text);
    _computeMessage(IdDocumentType.drivingLicense, _dlController.text);
    _computeMessage(IdDocumentType.voterId, _voterController.text);
    _computeMessage(IdDocumentType.passport, _passportController.text);
    _computeMessage(IdDocumentType.pinCode, _pinController.text);
    _computeMessage(IdDocumentType.phone, _phoneController.text);
    _computeMessage(IdDocumentType.email, _emailController.text);
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
                    color: iconColor.withValues(alpha: 0.1),
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
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
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
    required IdDocumentType type,
    required String message,
    required bool isValid,
  }) {
    final color = isValid ? Colors.green.shade600 : Colors.red.shade600;
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.error_outline,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            message.isEmpty
                ? (isValid ? 'Looks good' : 'Not validated yet')
                : message,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
