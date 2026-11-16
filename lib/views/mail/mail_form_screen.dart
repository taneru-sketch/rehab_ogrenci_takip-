import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class MailFormScreen extends StatefulWidget {
  final String? studentName; // Belirli öğrenci için otomatik konu
  const MailFormScreen({super.key, this.studentName});

  @override
  State<MailFormScreen> createState() => _MailFormScreenState();
}

class _MailFormScreenState extends State<MailFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _toController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;
  String? _resultMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    if (widget.studentName != null) {
      _subjectController.text = '${widget.studentName} - Ogrenci Bilgisi';
    }
  }

  Future<void> _sendMail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _resultMessage = null;
    });

    try {
      // Firebase Cloud Functions'taki "sendMail" fonksiyonunu çağır
      final callable = FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('sendMail');

      final result = await callable.call({
        'to': _toController.text.trim(),
        'subject': _subjectController.text.trim(),
        'message': _messageController.text.trim(),
      });

      if (result.data['success'] == true) {
        setState(() {
          _isSuccess = true;
          _resultMessage = 'Mail basariyla gonderildi!';
        });
        _toController.clear();
        _subjectController.clear();
        _messageController.clear();
      } else {
        setState(() {
          _isSuccess = false;
          _resultMessage = 'Mail gonderilemedi: ${result.data['error']}';
        });
      }
    } on FirebaseFunctionsException catch (e) {
      setState(() {
        _isSuccess = false;
        _resultMessage = 'Hata: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _resultMessage = 'Beklenmeyen hata: $e';
      });
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mail Gonder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bilgilendirme
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade800, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Bu form uzerinden veli, okul veya RAM kurumuna mail gonderebilirsiniz. '
                        'Mail Firebase Cloud Functions ve Gmail uzerinden iletilir.',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade900, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              // Alıcı E-posta
              TextFormField(
                controller: _toController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Alici E-posta Adresi',
                  hintText: 'veli@ornek.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'E-posta adresi gerekli';
                  if (!val.contains('@')) return 'Gecerli bir e-posta giriniz';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Konu
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Konu',
                  prefixIcon: const Icon(Icons.subject_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Konu bos birakilamaz';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Mesaj
              TextFormField(
                controller: _messageController,
                maxLines: 7,
                decoration: InputDecoration(
                  labelText: 'Mesaj',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.message_outlined),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Mesaj bos birakilamaz';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Hızlı Şablonlar
              const Text(
                'Hizli Sablonlar:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildTemplateChip('Veli Bilgilendirme', 
                    'Sayin veli, cocugunuzun bugunki seans degerlendirmesini bilgilerinize sunariz.'),
                  _buildTemplateChip('RAM Bilgi Talebi',
                    'Sayin yetkili, ogrencimizin RAM raporu ile ilgili guncel bilgi talep etmekteyiz.'),
                  _buildTemplateChip('Okul Koordinasyon',
                    'Sayin ogretmen, ogrencimizin merkez ve okul arasindaki egitim koordinasyonu hakkinda gorusmek istiyoruz.'),
                ],
              ),
              const SizedBox(height: 20),

              // Sonuç Mesajı
              if (_resultMessage != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isSuccess ? Colors.green.shade300 : Colors.red.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                        color: _isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _resultMessage!,
                          style: TextStyle(
                            color: _isSuccess ? Colors.green.shade900 : Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Gönder Butonu
              ElevatedButton.icon(
                onPressed: _isSending ? null : _sendMail,
                icon: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _isSending ? 'Gonderiliyor...' : 'Mail Gonder',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateChip(String label, String templateText) {
    return ActionChip(
      avatar: const Icon(Icons.edit_note_rounded, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () => _messageController.text = templateText,
      backgroundColor: Colors.grey.shade100,
    );
  }
}
