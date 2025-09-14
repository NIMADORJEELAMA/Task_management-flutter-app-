import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/keyword_provider.dart';
import 'product_list_screen.dart';
import '../models/keyword.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordsAsync = ref.watch(keywordsProvider);
    final selectedKeyword = ref.watch(selectedKeywordProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Task Manager",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Section Title
            Text(
              "Choose a keyword",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Keywords Dropdown
            _buildKeywordDropdown(keywordsAsync, selectedKeyword, ref),
            
            const SizedBox(height: 32),

            // Navigation Button
            _buildNavigationButton(context, selectedKeyword),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordDropdown(
    AsyncValue<List<Keyword>> keywordsAsync,
    Keyword? selectedKeyword,
    WidgetRef ref,
  ) {
    return keywordsAsync.when(
      data: (keywords) {
        // Console log for debugging
        debugPrint('Available keywords: ${keywords.map((k) => k.name).join(', ')}');
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: DropdownButton<Keyword>(
            isExpanded: true,
            value: selectedKeyword,
            hint: Text(
              "Select a keyword",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            underline: const SizedBox.shrink(),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.deepPurple,
            iconSize: 24,
            borderRadius: BorderRadius.circular(12),
            items: keywords
                .map((keyword) => DropdownMenuItem<Keyword>(
                      value: keyword,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          keyword.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (selectedValue) {
              ref.read(selectedKeywordProvider.notifier).state = selectedValue;
            },
          ),
        );
      },
      loading: () => Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          ),
        ),
      ),
      error: (error, stackTrace) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Error loading keywords: $error",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, Keyword? selectedKeyword) {
    final isEnabled = selectedKeyword != null;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.deepPurple : Colors.grey.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isEnabled ? 2 : 0,
          shadowColor: Colors.deepPurple.withOpacity(0.3),
        ),
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Go to Products",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isEnabled) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}