import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/event_catalog.dart';
import '../models/event.dart';
import '../theme/eventhub_colors.dart';
import '../utils/eventhub_date_picker.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/select_event_sheet.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key, this.eventToEdit});

  final Event? eventToEdit;

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  final int _currentIndex = 2;
  String? _editingEventId;
  Uint8List? _coverImageBytes;
  bool _coverRemoved = false;
  bool _isSaving = false;

  bool get _isEditing => _editingEventId != null;

  @override
  void initState() {
    super.initState();
    final event = widget.eventToEdit;
    if (event != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadEventIntoForm(event);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await EventHubDatePicker.show(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text =
            '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 75,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _coverImageBytes = bytes;
        _coverRemoved = false;
      });
    } catch (_) {
      if (!mounted) return;
      _showMessage('Não foi possível carregar a imagem.');
    }
  }

  void _removeImage() {
    setState(() {
      _coverImageBytes = null;
      _coverRemoved = true;
    });
  }

  void _selectCategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione uma categoria'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _categoryOption('Música'),
            _categoryOption('Teatro'),
            _categoryOption('Feira'),
            _categoryOption('Exposição'),
            _categoryOption('Workshop'),
            _categoryOption('Cinema'),
            _categoryOption('Outro'),
          ],
        ),
      ),
    );
  }

  Widget _categoryOption(String category) {
    return ListTile(
      title: Text(category),
      onTap: () {
        setState(() {
          _categoryController.text = category;
        });
        Navigator.pop(context);
      },
    );
  }

  DateTime? _parseStartsAt() {
    final dateParts = _dateController.text.split('/');
    final timeParts = _timeController.text.split(':');
    if (dateParts.length != 3 || timeParts.length < 2) return null;

    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);

    if (day == null ||
        month == null ||
        year == null ||
        hour == null ||
        minute == null) {
      return null;
    }

    return DateTime(year, month, day, hour, minute);
  }

  Event? _buildEventFromForm({required String id}) {
    final startsAt = _parseStartsAt();
    if (startsAt == null) return null;

    final category = _categoryController.text.trim();

    return Event(
      id: id,
      title: _nameController.text.trim(),
      date: Event.formatDisplayDate(startsAt),
      location: _locationController.text.trim(),
      category: category,
      description: _descriptionController.text.trim(),
      startsAt: startsAt,
      gradient: Event.gradientForCategory(category),
      coverImageBytes: _coverRemoved ? null : _coverImageBytes,
      createdBy: _isEditing ? EventCatalog.byId(id).createdBy : null,
    );
  }

  Future<void> _saveEvent() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final startsAt = _parseStartsAt();
    if (startsAt == null) {
      _showMessage('Informe data e hora válidas.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_isEditing) {
        final existing = EventCatalog.byId(_editingEventId!);
        final updated = _buildEventFromForm(id: existing.id);
        if (updated == null) return;

        await EventCatalog.updateEvent(
          updated,
          coverBytes: _coverRemoved ? null : _coverImageBytes,
          removeCover: _coverRemoved,
        );
        if (!mounted) return;
        _showMessage('Evento atualizado com sucesso.');
      } else {
        final created = _buildEventFromForm(id: EventCatalog.nextId());
        if (created == null) return;

        await EventCatalog.addEvent(created, coverBytes: _coverImageBytes);
        if (!mounted) return;
        _showMessage('Evento salvo com sucesso.');
      }

      _clearForm();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Não foi possível salvar o evento. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _editEvent() async {
    final selected = await showSelectEventSheet(
      context,
      title: 'Selecione o evento para editar',
    );
    if (selected == null || !mounted) return;
    _loadEventIntoForm(selected);
  }

  Future<void> _deleteEvent() async {
    if (_isSaving) return;

    Future<void> performDelete(Event event) async {
      setState(() => _isSaving = true);
      try {
        await EventCatalog.removeEvent(event.id);
        if (!mounted) return;
        _showMessage('Evento excluído.');
        if (_editingEventId == event.id) {
          _clearForm();
        }
      } catch (_) {
        if (!mounted) return;
        _showMessage('Não foi possível excluir o evento.');
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }

    if (_isEditing) {
      final confirmed = await _confirmDelete(EventCatalog.byId(_editingEventId!));
      if (confirmed != true || !mounted) return;
      await performDelete(EventCatalog.byId(_editingEventId!));
      return;
    }

    final selected = await showSelectEventSheet(
      context,
      title: 'Selecione o evento para excluir',
    );
    if (selected == null || !mounted) return;

    final confirmed = await _confirmDelete(selected);
    if (confirmed != true || !mounted) return;

    await performDelete(selected);
  }

  Future<bool?> _confirmDelete(Event event) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir evento'),
        content: Text('Excluir "${event.title}"? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _loadEventIntoForm(Event event) {
    setState(() {
      _editingEventId = event.id;
      _nameController.text = event.title;
      _categoryController.text = event.category;
      _locationController.text = event.location;
      _descriptionController.text = event.description ?? '';
      _dateController.text =
          '${event.startsAt.day}/${event.startsAt.month}/${event.startsAt.year}';
      _timeController.text =
          '${event.startsAt.hour}:${event.startsAt.minute.toString().padLeft(2, '0')}';
      _coverImageBytes = event.coverImageBytes;
      _coverRemoved = false;
    });
  }

  void _clearForm() {
    setState(() {
      _editingEventId = null;
      _coverImageBytes = null;
      _coverRemoved = false;
      _nameController.clear();
      _categoryController.clear();
      _dateController.clear();
      _timeController.clear();
      _locationController.clear();
      _descriptionController.clear();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    if (_isEditing) _buildEditingBanner(),
                    _buildTextField(
                      'Nome do evento',
                      'Ex: Show de rock',
                      _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome do evento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      'Categoria',
                      'Selecione',
                      _categoryController,
                      _selectCategory,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecione uma categoria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      'Data',
                      'Selecione a data',
                      _dateController,
                      _selectDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecione a data';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      'Hora',
                      'Selecione a hora',
                      _timeController,
                      _selectTime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecione a hora';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Local',
                      'Ex: Centro Cultural',
                      _locationController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o local';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 16),
                    _buildImageSection(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EventHubBottomNav(currentIndex: _currentIndex),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _isEditing ? 'Editar evento' : 'Novo evento',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: EventHubColors.textPrimary,
              ),
            ),
          ),
          if (_isEditing)
            TextButton(
              onPressed: _clearForm,
              child: const Text('Novo'),
            ),
        ],
      ),
    );
  }

  Widget _buildEditingBanner() {
    final event = EventCatalog.byId(_editingEventId!);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EventHubColors.orangeButton.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: EventHubColors.orangeButton.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        'Editando: ${event.title}',
        style: TextStyle(
          color: EventHubColors.orangeButton,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: EventHubColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String hint,
    TextEditingController controller,
    VoidCallback onTap, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: EventHubColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        FormField<String>(
          validator: (_) => validator?.call(controller.text),
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: EventHubColors.inputFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: field.hasError
                            ? Colors.red
                            : EventHubColors.inputBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.text.isEmpty ? hint : controller.text,
                            style: TextStyle(
                              color: controller.text.isEmpty
                                  ? EventHubColors.textMuted
                                  : EventHubColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: EventHubColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descrição',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: EventHubColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: _inputDecoration('Descreva seu evento...'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: EventHubColors.textMuted),
      filled: true,
      fillColor: EventHubColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: EventHubColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: EventHubColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: EventHubColors.orangeButton,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagem',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: EventHubColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: EventHubColors.inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: EventHubColors.inputBorder),
            ),
            child: _buildCoverPreview()
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildCoverImage(),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: _removeImage,
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: EventHubColors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toque para adicionar imagem',
                        style: TextStyle(
                          color: EventHubColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  bool _buildCoverPreview() {
    return !_coverRemoved && _coverImageBytes != null;
  }

  Widget _buildCoverImage() {
    return Image.memory(_coverImageBytes!, fit: BoxFit.cover);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: EventHubColors.orangeButton,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _isEditing ? 'Salvar alterações' : 'Salvar evento',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSaving ? null : _editEvent,
                style: OutlinedButton.styleFrom(
                  foregroundColor: EventHubColors.textPrimary,
                  side: const BorderSide(color: EventHubColors.inputBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Editar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _isSaving ? null : _deleteEvent,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Excluir'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
