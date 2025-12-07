import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AICounselingResultScreen extends StatelessWidget {
  final String aiResponse;
  final VoidCallback? onGetNewAdvice;

  const AICounselingResultScreen({
    super.key,
    required this.aiResponse,
    this.onGetNewAdvice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'AI Counseling Advice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: aiResponse));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Response copied to clipboard'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality can be added here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[400]!,
                  Colors.purple[600]!,
                ],
              ),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Personalized Counseling Advice',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on the information you provided',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[50]!,
                    Colors.purple[50]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.purple[200]!,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: MarkdownBody(
                      data: aiResponse,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: Colors.black87,
                        ),
                      h1: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                      h1Padding: const EdgeInsets.only(top: 24, bottom: 12),
                      h2: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                      h2Padding: const EdgeInsets.only(top: 20, bottom: 10),
                      h3: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[600],
                      ),
                      h3Padding: const EdgeInsets.only(top: 16, bottom: 8),
                      strong: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      em: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      listBullet: TextStyle(
                        color: Colors.purple[600],
                        fontSize: 20,
                      ),
                      listIndent: 24,
                      code: TextStyle(
                        backgroundColor: Colors.grey[200],
                        color: Colors.purple[800],
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      codeblockPadding: const EdgeInsets.all(12),
                      blockquote: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                      blockquoteDecoration: BoxDecoration(
                        color: Colors.purple[50],
                        border: Border(
                          left: BorderSide(
                            color: Colors.purple[400]!,
                            width: 4,
                          ),
                        ),
                      ),
                      blockquotePadding: const EdgeInsets.all(16),
                      horizontalRuleDecoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),
          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[600],
                        side: BorderSide(color: Colors.purple[600]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onGetNewAdvice ?? () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Get New Advice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: Colors.purple.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

