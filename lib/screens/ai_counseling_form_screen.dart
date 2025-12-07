import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../widgets/full_screen_loader.dart';
import 'ai_counseling_result_screen.dart';

class AICounselingFormScreen extends StatefulWidget {
  final String? initialCategory;

  const AICounselingFormScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<AICounselingFormScreen> createState() => _AICounselingFormScreenState();
}

class _AICounselingFormScreenState extends State<AICounselingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _examController = TextEditingController();
  final _marksController = TextEditingController();
  final _boardController = TextEditingController();
  final _playingTimeController = TextEditingController();
  final _mobileTimeController = TextEditingController();
  final _activityController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _additionalInfoController.text = 'Category: ${widget.initialCategory}\n\n';
    }
  }

  @override
  void dispose() {
    _examController.dispose();
    _marksController.dispose();
    _boardController.dispose();
    _playingTimeController.dispose();
    _mobileTimeController.dispose();
    _activityController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Build the prompt with all form data
    final prompt = _buildPrompt();

    try {
      final result = await ApiService.getAIResponse(prompt);

      if (result['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to result screen
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AICounselingResultScreen(
                aiResponse: result['completion'] ?? 'No response received',
                onGetNewAdvice: () {
                  Navigator.of(context).pop();
                  _submitForm();
                },
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to get AI response';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _buildPrompt() {
    final buffer = StringBuffer();
    
    buffer.writeln('I am a parent seeking counseling advice for my child\'s academic and personal development. Please provide personalized guidance based on the following information:\n');
    
    if (_examController.text.isNotEmpty) {
      buffer.writeln('Exam/Test: ${_examController.text}');
    }
    
    if (_marksController.text.isNotEmpty) {
      buffer.writeln('Marks/Score: ${_marksController.text}');
    }
    
    if (_boardController.text.isNotEmpty) {
      buffer.writeln('Education Board: ${_boardController.text}');
    }
    
    if (_playingTimeController.text.isNotEmpty) {
      buffer.writeln('Playing/Outdoor Time: ${_playingTimeController.text}');
    }
    
    if (_mobileTimeController.text.isNotEmpty) {
      buffer.writeln('Mobile/Screen Usage Time: ${_mobileTimeController.text}');
    }
    
    if (_activityController.text.isNotEmpty) {
      buffer.writeln('Student Activities: ${_activityController.text}');
    }
    
    if (_additionalInfoController.text.isNotEmpty) {
      buffer.writeln('\nAdditional Information:\n${_additionalInfoController.text}');
    }
    
    buffer.writeln('\nPlease provide comprehensive counseling advice including:');
    buffer.writeln('1. Academic improvement strategies');
    buffer.writeln('2. Time management recommendations');
    buffer.writeln('3. Healthy screen time guidelines');
    buffer.writeln('4. Activity planning suggestions');
    buffer.writeln('5. Overall development tips');
    
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'AI Counseling',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple[400]!,
                      Colors.purple[600]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Get AI-Powered Counseling',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details below to receive personalized advice for your child\'s development',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildTextField(
                controller: _examController,
                label: 'Exam/Test Name',
                hint: 'e.g., Mathematics Mid-term, Science Final',
                icon: Icons.quiz,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _marksController,
                      label: 'Marks/Score',
                      hint: 'e.g., 85/100',
                      icon: Icons.grade,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _boardController,
                      label: 'Education Board',
                      hint: 'e.g., CBSE, ICSE',
                      icon: Icons.school,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _playingTimeController,
                      label: 'Playing Time (Daily)',
                      hint: 'e.g., 2 hours',
                      icon: Icons.sports_soccer,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _mobileTimeController,
                      label: 'Mobile Usage Time (Daily)',
                      hint: 'e.g., 3 hours',
                      icon: Icons.phone_android,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _activityController,
                label: 'Student Activities',
                hint: 'Describe daily activities, hobbies, extracurricular activities',
                icon: Icons.directions_run,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _additionalInfoController,
                label: 'Additional Information',
                hint: 'Any other details you want to share (optional)',
                icon: Icons.note,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                isOptional: true,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 8,
                  shadowColor: Colors.purple.withValues(alpha: 0.4),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Get AI Counseling Advice',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // Error Message
              if (_errorMessage != null) _buildErrorCard(),
            ],
          ),
        ),
      ),
          // Full Screen Loader
          if (_isLoading)
            const AnimatedFullScreenLoader(
              message: 'Getting AI Counseling Advice...',
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label + (isOptional ? ' (Optional)' : ''),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.purple[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.purple[600]!,
            width: 2,
          ),
        ),
      ),
      validator: isOptional
          ? null
          : (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

