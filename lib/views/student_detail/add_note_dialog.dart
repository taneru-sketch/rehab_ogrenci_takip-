import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';

class AddNoteDialog extends StatefulWidget {
  final String studentId;

  const AddNoteDialog({super.key, required this.studentId});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _authorController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _quickTags = [
    'Tuvaletini zamaninda haber verdi',
    'Seker/tatli istemedi',
    'Derse tam odaklandi',
    'Stres topuyla sakinlestirildi',
    'Yeni kelime telaffuz etti',
    'Kriz gozlemlendi',
  ];

  void _appendTag(String tag) {
    if (_noteController.text.isEmpty) {
      _noteController.text = tag;
    } else {
      _noteController.text += ', $tag';
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.addObservationNote(
        studentId: widget.studentId,
        authorName: _authorController.text,
        noteText: _noteController.text,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seans notu basariyla ortak havuza eklendi.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _authorController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit_note_rounded, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            'Seans / Gozlem Notu Ekle',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eğitmen Adı / Branşı
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Egitmen Adi ve Bransi',
                  hintText: 'Orn: Merve Hoca (Ozel Egitim)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lutfen adinizi veya bransinizi yaziniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Hızlı Etiketler
              const Text(
                'Hizli Sablonlar (Tiklayarak ekleyin):',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _quickTags
                    .map(
                      (tag) => ActionChip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        onPressed: () => _appendTag(tag),
                        backgroundColor: Colors.blue.shade50,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Not Metni
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Seans Gozlemi ve Notu',
                  hintText:
                      'Ogrencinin bugunku duygu durumu, calisilan hedef veya diger egitmenlerin bilmesi gerekenler...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lutfen bir seans notu giriniz';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Iptal'),
        ),
        ElevatedButton(
          onPressed: _saveNote,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Havuza Kaydet'),
        ),
      ],
    );
  }
}
