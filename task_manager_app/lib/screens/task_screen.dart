 

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../services/api_service.dart';
import '../models/keyword.dart';
import '../models/product.dart';
import '../widgets/task_input_dialog.dart';
import 'keyword_product_page.dart';
import 'product_details_page.dart'; // <-- Add this line

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  List<Product> _products = [];
  bool _showKeywordDropdown = false; // ✅ Track dropdown visibility
  List<Keyword> _keywords = [];
  String? _selectedKeywordId;
  bool _loadingKeywords = false;
  String? _keywordError;

  @override
  void initState() {
    super.initState();
    _fetchKeywords();
  }

  Future<void> _fetchKeywords() async {
    setState(() {
      _loadingKeywords = true;
    });
    try {
      final keywords = await ApiService.getKeywords();
      final uniqueKeywords = {for (var k in keywords) k.id: k};
      setState(() {
        _keywords = uniqueKeywords.values.toList();
        _loadingKeywords = false;
        if (_keywords.isNotEmpty) {
          _selectedKeywordId = _keywords.first.id;
          _fetchProducts(_selectedKeywordId!);
        }
      });
    } catch (e) {
      setState(() {
        _keywordError = e.toString();
        _loadingKeywords = false;
      });
    }
  }

  Future<void> _fetchProducts(String keywordId) async {
    final products = await ApiService.getProducts(keywordId);
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Task"),
                    onPressed: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (_) => const TaskInputDialog(),
                      );
                      if (result != null) {
                        ref.read(taskProvider.notifier).addTask(
                              result["title"],
                              "", // keywordId for later
                            );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_drop_down),
                    label: const Text("Select Keyword"),
                    onPressed: () {
                      setState(() {
                        _showKeywordDropdown = !_showKeywordDropdown;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ✅ Inline Keyword Dropdown
            if (_showKeywordDropdown)
              _loadingKeywords
                  ? const CircularProgressIndicator()
                  : _keywordError != null
                      ? Text(_keywordError!,
                          style: const TextStyle(color: Colors.red))
                      : DropdownButtonFormField<String>(
                          value: _selectedKeywordId,
                          decoration: const InputDecoration(
                            labelText: "Keyword",
                            border: OutlineInputBorder(),
                          ),
                          items: _keywords
                              .map((k) => DropdownMenuItem(
                                    value: k.id,
                                    child: Text(k.keyword),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedKeywordId = value;
                              });
                              _fetchProducts(value);
                            }
                          },
                        ),

            const SizedBox(height: 20),

            // ✅ Tasks & Products Section
            Expanded(
              child: tasks.isEmpty && _products.isEmpty
                  ? const Center(child: Text("No tasks or products yet."))
                  : ListView(
                      children: [
                        if (tasks.isNotEmpty) ...[
                          const Text(
                            "Tasks",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...tasks.map(
                            (task) => ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (_) {
                                  ref
                                      .read(taskProvider.notifier)
                                      .toggleComplete(task.id);
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result =
                                          await showDialog<Map<String, dynamic>>(
                                        context: context,
                                        builder: (_) => TaskInputDialog(
                                            initialTitle: task.title),
                                      );
                                      if (result != null) {
                                        ref
                                            .read(taskProvider.notifier)
                                            .editTask(task.id, result["title"],
                                                task.keywordId);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      ref
                                          .read(taskProvider.notifier)
                                          .deleteTask(task.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                        if (_products.isNotEmpty) ...[
                          const Text(
                            "Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ..._products.map(
                            (product) => Card(
                              child: ListTile(
                                leading: product.productImageUrls.isNotEmpty
                                    ? Image.network(
                                        product.productImageUrls.first,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image_not_supported),
                                title: Text(product.productName),
                                subtitle: Text(
                                    "${product.brandName} • ${product.currentProductPrice}"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                        productId: product.productId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


class KeywordDropdownModal extends StatefulWidget {
  final void Function(String keywordId, List<Product> products)?
      onKeywordSelected;
  const KeywordDropdownModal({super.key, this.onKeywordSelected});

  @override
  State<KeywordDropdownModal> createState() => _KeywordDropdownModalState();
}

class _KeywordDropdownModalState extends State<KeywordDropdownModal> {
  List<Keyword> _keywords = [];
  String? _selectedKeywordId;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchKeywords();
  }
Future<void> _fetchKeywords() async {
  try {
    final keywords = await ApiService.getKeywords();

    // Remove duplicates by id
    final uniqueKeywords = <String, Keyword>{};
    for (var k in keywords) {
      uniqueKeywords[k.id] = k;
    }

    setState(() {
      _keywords = uniqueKeywords.values.toList();
      _loading = false;
      if (_keywords.isNotEmpty) {
        _selectedKeywordId = _keywords.first.id;
        _fetchProducts(_selectedKeywordId!);
      }
    });
  } catch (e) {
    setState(() {
      _error = e.toString();
      _loading = false;
    });
  }
}

 

  Future<void> _fetchProducts(String keywordId) async {
    final products = await ApiService.getProducts(keywordId);
    widget.onKeywordSelected?.call(keywordId, products);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Keyword",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red))
      else if (_keywords.isNotEmpty)
DropdownButtonFormField<String>(
  value: _selectedKeywordId,
  decoration: const InputDecoration(labelText: "Keyword"),
  items: _keywords.map((k) {
    print("🔑 keyword: ${k.keyword}, id for API: ${k.id}");
    return DropdownMenuItem(
      value: k.id, // ✅ use `id` here
      child: Text(k.keyword),
    );
  }).toList(),
  onChanged: (value) {
    if (value != null) {
      setState(() {
        _selectedKeywordId = value;
      });
      _fetchProducts(value); // ✅ sends "1"
    }
  },
),


        const Spacer(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         if (_selectedKeywordId != null) {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) =>
        //                   KeywordProductPage(keywordId: _selectedKeywordId!),
        //             ),
        //           );
        //         }
        //       },
        //       child: const Text('View Products'),
        //     ),
        //     TextButton(
        //       onPressed: () => Navigator.of(context).pop(),
        //       child: const Text("Close"),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
