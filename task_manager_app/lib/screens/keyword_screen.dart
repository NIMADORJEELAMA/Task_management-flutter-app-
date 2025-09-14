import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/keyword.dart';

// Riverpod: Selected keyword state
final selectedKeywordProvider = StateProvider<Keyword?>((ref) => null);

// Sample keyword list (replace with API data later)
final keywordsProvider = Provider<List<Keyword>>((ref) => [
      Keyword(id: '1', name: 'Design'),
      Keyword(id: '2', name: 'Development'),
      Keyword(id: '3', name: 'Marketing'),
    ]);

class KeywordScreen extends ConsumerWidget {
  const KeywordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywords = ref.watch(keywordsProvider);
    final selectedKeyword = ref.watch(selectedKeywordProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Keywords'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButton<Keyword>(
                isExpanded: true,
                value: selectedKeyword,
                hint: const Text('Select a Keyword'),
                underline: const SizedBox(),
                items: keywords
                    .map((k) => DropdownMenuItem<Keyword>(
                          value: k,
                          child: Text(k.name),
                        ))
                    .toList(),
                onChanged: (val) {
                  ref.read(selectedKeywordProvider.notifier).state = val;
                },
              ),
            ),

            const SizedBox(height: 24),

            // Display keyword cards
            Expanded(
              child: ListView.builder(
                itemCount: keywords.length,
                itemBuilder: (context, index) {
                  final keyword = keywords[index];
                  final isSelected = keyword == selectedKeyword;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      keyword.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
