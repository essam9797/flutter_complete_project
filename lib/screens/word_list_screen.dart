import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_3/models/task_model.dart';

class WordsListScreen extends StatefulWidget {
  const WordsListScreen({super.key});

  static final List<TaskModel> dictionaryWords = [
    TaskModel(
      word: 'Short',
      meaning: 'small in length, height, or duration (time), or not having enough of something',
      translation: 'قصير',
    ),
  ];

  @override
  State<WordsListScreen> createState() => _WordsListScreenState();
}

class _WordsListScreenState extends State<WordsListScreen> {
  List<TaskModel> get wordList => WordsListScreen.dictionaryWords;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = _searchQuery.isEmpty
        ? wordList
        : wordList.where((item) {
            return item.word.toLowerCase().contains(_searchQuery) ||
                item.meaning.toLowerCase().contains(_searchQuery) ||
                item.translation.toLowerCase().contains(_searchQuery);
          }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'My dictionary 📖',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 205, 212),
        elevation: 4.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  setState(() => _searchQuery = value.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search word, meaning, or translation...',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 117, 117, 117),
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.indigo),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.indigo),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color.fromARGB(255, 210, 215, 241),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 14.w,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: Colors.indigo.shade200,
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: Colors.indigo, width: 1.8),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredWords.isEmpty
                ? const Center(child: Text('No matching words found'))
                : ListView.builder(
                    itemCount: filteredWords.length,
                    itemBuilder: (context, index) {
                      final item = filteredWords[index];
                      final realIndex = wordList.indexOf(item);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.indigo.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          item.word,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.meaning),
                            const SizedBox(height: 2),
                            Text(item.translation),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showWordDialog(index: realIndex),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteDialog(realIndex),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'words_list_add_fab',
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => _showWordDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showWordDialog({int? index}) {
    final isEditing = index != null;
    final wordController = TextEditingController(
      text: isEditing ? wordList[index].word : '',
    );
    final meaningController = TextEditingController(
      text: isEditing ? wordList[index].meaning : '',
    );
    final translationController = TextEditingController(
      text: isEditing ? wordList[index].translation : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 245, 248, 250),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(isEditing ? 'Edit Item' : 'Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                decoration: const InputDecoration(labelText: 'Word'),
              ),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(labelText: 'Meaning'),
              ),
              TextField(
                controller: translationController,
                decoration: const InputDecoration(labelText: 'Translation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                final wordText = wordController.text.trim();
                if (wordText.isEmpty) return;

                final isDuplicate = wordList.asMap().entries.any(
                  (entry) =>
                      entry.key != index &&
                      entry.value.word.trim().toLowerCase() ==
                          wordText.toLowerCase(),
                );

                if (isDuplicate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '"$wordText" already exists in your dictionary',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  if (isEditing) {
                    wordList[index].word = wordText;
                    wordList[index].meaning = meaningController.text.trim();
                    wordList[index].translation = translationController.text
                        .trim();
                  } else {
                    wordList.add(
                      TaskModel(
                        word: wordText,
                        meaning: meaningController.text.trim(),
                        translation: translationController.text.trim(),
                      ),
                    );
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 245, 248, 250),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() => wordList.removeAt(index));
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
