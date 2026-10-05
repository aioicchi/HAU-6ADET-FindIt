import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/core/utils/validators.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/campus.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/shared/shared.dart';

import 'widgets/photo_upload_box.dart';

/// Report a new item, or edit an existing one when [editing] is given.
class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key, this.editing, this.onSubmitted});

  final Item? editing;
  final VoidCallback? onSubmitted;

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.editing?.name);
  late final _description = TextEditingController(text: widget.editing?.description);
  // Location: a campus place from the picker (or "Other…" with free text), plus an optional spot.
  late String? _place = _initialPlace;
  late final _otherPlace = TextEditingController(text: _place == otherLocation ? widget.editing?.location : null);
  late final _spot = TextEditingController(text: widget.editing?.spot);
  late final _contact = TextEditingController(text: widget.editing?.contact ?? store.user?.email);
  late final _claimAt = TextEditingController(text: widget.editing?.claimAt);
  late final _verifyQuestion = TextEditingController(text: widget.editing?.verifyQuestion);
  late ItemStatus? _status = widget.editing?.status;
  late String? _category = widget.editing?.category;
  late DateTime _date = widget.editing?.date ?? DateTime.now();
  late bool _hasPhoto = widget.editing?.hasPhoto ?? false;
  late Uint8List? _photo = widget.editing?.photo;
  late String? _photoAsset = widget.editing?.photoAsset;

  bool get _isEdit => widget.editing != null;

  /// Editing a report whose location isn't on the campus list shows it under "Other…".
  String? get _initialPlace {
    final location = widget.editing?.location;
    if (location == null) return null;
    return campusLocations.contains(location) ? location : otherLocation;
  }

  String get _locationValue => _place == otherLocation ? _otherPlace.text.trim() : _place!;

  String? get _spotValue {
    final s = _spot.text.trim();
    return s.isEmpty ? null : s;
  }

  ImageProvider? get _preview {
    final bytes = _photo;
    if (bytes != null) return MemoryImage(bytes);
    final asset = _photoAsset;
    if (asset != null) return AssetImage(asset);
    return null;
  }

  @override
  void dispose() {
    for (final c in [_name, _description, _otherPlace, _spot, _contact, _claimAt, _verifyQuestion]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
    if (d != null) setState(() => _date = d);
  }

  Future<void> _choosePhoto() async {
    final hasAny = _preview != null || _hasPhoto;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, 'gallery'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(context, 'camera'),
          ),
          if (hasAny)
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove photo'),
              onTap: () => Navigator.pop(context, 'remove'),
            ),
        ]),
      ),
    );
    if (choice == null) return;

    if (choice == 'remove') {
      setState(() {
        _photo = null;
        _photoAsset = null;
        _hasPhoto = false;
      });
      return;
    }

    try {
      final file = await ImagePicker().pickImage(
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1280,
        imageQuality: 80,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _photo = bytes;
        _photoAsset = null;
        _hasPhoto = true;
      });
    } catch (_) {
      if (mounted) showSnack(context, 'Could not open the photo picker.');
    }
  }

  /// The picked category first, then any extra tags the item already had.
  List<String> _tags(List<String> existing) =>
      [_category!, ...existing.where((t) => !Item.categories.contains(t))];

  /// Only found items have a claim location and a verification question.
  String? _foundOnly(TextEditingController c) {
    final v = c.text.trim();
    return _status == ItemStatus.found && v.isNotEmpty ? v : null;
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    final editing = widget.editing;

    if (editing != null) {
      editing
        ..tags = _tags(editing.tags)
        ..claimAt = _foundOnly(_claimAt)
        ..verifyQuestion = _foundOnly(_verifyQuestion)
        ..name = _name.text.trim()
        ..description = _description.text.trim()
        ..location = _locationValue
        ..spot = _spotValue
        ..contact = _contact.text.trim()
        ..status = _status!
        ..date = _date
        ..hasPhoto = _hasPhoto
        ..photo = _photo
        ..photoAsset = _photoAsset;
      store.changed();
      Navigator.pop(context);
      showSnack(context, 'Report updated.');
      return;
    }

    store.addItem(Item(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      description: _description.text.trim(),
      status: _status!,
      location: _locationValue,
      spot: _spotValue,
      date: _date,
      contact: _contact.text.trim(),
      ownerId: store.user!.id,
      tags: _tags(const []),
      claimAt: _foundOnly(_claimAt),
      verifyQuestion: _foundOnly(_verifyQuestion),
      hasPhoto: _hasPhoto,
      photo: _photo,
    ));
    _resetForm();
    showSnack(context, 'Item reported successfully.');
    widget.onSubmitted?.call();
  }

  void _resetForm() {
    _form.currentState!.reset();
    _name.clear();
    _description.clear();
    _otherPlace.clear();
    _spot.clear();
    _claimAt.clear();
    _verifyQuestion.clear();
    setState(() {
      _status = null;
      _category = null;
      _place = null;
      _hasPhoto = false;
      _photo = null;
      _photoAsset = null;
      _date = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Report' : 'Report Item'),
          automaticallyImplyLeading: _isEdit,
        ),
        body: Form(
          key: _form,
          child: ListView(padding: const EdgeInsets.all(14), children: [
            Text('INFORMATION ENTRY', style: AppTextStyles.label),
            const SizedBox(height: 4),
            Text('Fill out the details below to register the item in the university database.', style: AppTextStyles.caption),
            const Divider(height: 24),
            const FieldLabel('Item name'),
            TextFormField(controller: _name, decoration: const InputDecoration(hintText: 'Enter short title...'), validator: Validators.required),
            const FieldLabel('Category'),
            DropdownButtonFormField<String>(
              initialValue: _category,
              hint: const Text('Select Category', style: TextStyle(fontSize: 13)),
              items: [
                for (final c in Item.categories)
                  DropdownMenuItem(value: c, child: Text(Item.categoryLabel(c))),
              ],
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Select a category' : null,
            ),
            const FieldLabel('Description'),
            TextFormField(controller: _description, maxLines: 4, decoration: const InputDecoration(hintText: 'Detail color, material, distinguishing marks...')),
            const FieldLabel('Status'),
            DropdownButtonFormField<ItemStatus>(
              initialValue: _status,
              hint: const Text('Select Status', style: TextStyle(fontSize: 13)),
              items: const [
                DropdownMenuItem(value: ItemStatus.lost, child: Text('Lost')),
                DropdownMenuItem(value: ItemStatus.found, child: Text('Found')),
              ],
              onChanged: (v) => setState(() => _status = v),
              validator: (v) => v == null ? 'Select a status' : null,
            ),
            FieldLabel(switch (_status) {
              ItemStatus.found => 'Where did you find it?',
              ItemStatus.lost => 'Where did you lose it?',
              null => 'Location',
            }),
            DropdownButtonFormField<String>(
              initialValue: _place,
              isExpanded: true,
              hint: const Text('Select building or area', style: TextStyle(fontSize: 13)),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.place_outlined, size: 18)),
              items: [
                for (final p in [...campusLocations, otherLocation])
                  DropdownMenuItem(value: p, child: Text(p, overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) => setState(() => _place = v),
              validator: (v) => v == null ? 'Select where it was' : null,
            ),
            if (_place == otherLocation) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _otherPlace,
                decoration: const InputDecoration(hintText: 'Name the place, e.g. Jeepney terminal'),
                validator: Validators.required,
              ),
            ],
            const SizedBox(height: 8),
            TextFormField(
              controller: _spot,
              decoration: const InputDecoration(
                hintText: 'Room or exact spot (optional), e.g. Room 304',
                prefixIcon: Icon(Icons.meeting_room_outlined, size: 18),
              ),
            ),
            if (_status == ItemStatus.found) ...[
              const FieldLabel('Where can the owner claim it? (optional)'),
              TextFormField(
                controller: _claimAt,
                decoration: const InputDecoration(
                  hintText: 'e.g. Security Office, PGN Hall',
                  prefixIcon: Icon(Icons.storefront_outlined, size: 18),
                ),
              ),
              const FieldLabel('Question for claimers (optional)'),
              TextFormField(
                controller: _verifyQuestion,
                decoration: const InputDecoration(
                  hintText: "e.g. What's written on the bottom?",
                  prefixIcon: Icon(Icons.help_outline, size: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Ask something only the real owner would know. Leave it out of the description.',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ),
            ],
            const FieldLabel('Date'),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today_outlined, size: 18)),
                child: Text(fullDate(_date), style: const TextStyle(fontSize: 13)),
              ),
            ),
            const FieldLabel('Photo attachment'),
            PhotoUploadBox(photo: _preview, attached: _hasPhoto, onTap: _choosePhoto),
            const FieldLabel('Contact info'),
            TextFormField(controller: _contact, decoration: const InputDecoration(hintText: 'Email or Phone Number...'), validator: Validators.required),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('Only visible to administrators and verified claimers.', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send, size: 16),
              label: Text(_isEdit ? 'Save Changes' : 'Submit Report'),
            ),
          ]),
        ),
      );
}
