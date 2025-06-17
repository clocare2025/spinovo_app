import 'package:flutter/material.dart';
import 'package:spinovo_app/screen/auth/details_screen.dart';

class AddressTypeSelector extends StatefulWidget {
  final List<String> addressTypeList;
  final String initialType;
  final Function(String, bool) onTypeSelected;
  final StateSetter setModalState;

  const AddressTypeSelector({
    super.key,
    required this.addressTypeList,
    required this.initialType,
    required this.onTypeSelected,
    required this.setModalState,
  });

  @override
  State<AddressTypeSelector> createState() => _AddressTypeSelectorState();
}

class _AddressTypeSelectorState extends State<AddressTypeSelector> {
  late String _saveAs;
  final TextEditingController _customTextController = TextEditingController();
  bool _isCustomFieldVisible = false;

  @override
  void initState() {
    super.initState();
    _saveAs = widget.initialType;
    _isCustomFieldVisible = _saveAs == 'Other';
  }

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.addressTypeList.map((type) {
            final isSelected = _saveAs == type || (type == 'Other' && _isCustomFieldVisible);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: HouseholdTypeBox(
                  text: type,
                  isSelected: isSelected,
                  onTap: () {
                    widget.setModalState(() {
                      if (type == 'Other') {
                        _isCustomFieldVisible = true;
                        _saveAs = type;
                        widget.onTypeSelected(_customTextController.text.isNotEmpty ? _customTextController.text : 'Other', true);
                      } else {
                        _isCustomFieldVisible = false;
                        _saveAs = type;
                        _customTextController.clear();
                        widget.onTypeSelected(type, false);
                      }
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
        if (_isCustomFieldVisible)
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: TextField(
              controller: _customTextController,
              decoration: const InputDecoration(
                labelText: 'Enter custom address type',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.setModalState(() {
                  widget.onTypeSelected(value.isNotEmpty ? value : 'Other', true);
                });
              },
            ),
          ),
      ],
    );
  }
}