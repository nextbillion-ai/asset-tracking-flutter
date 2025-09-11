import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';

class EditAssetScreen extends StatefulWidget {
  const EditAssetScreen({
    required this.assetDetail,
    super.key,
    this.onAssetUpdated,
  });
  final AssetDetailInfo assetDetail;
  final VoidCallback? onAssetUpdated;

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  final TextEditingController _customIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<MapEntry<String, String>> _attributes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _customIdController.text = widget.assetDetail.id ?? '';
    _nameController.text = widget.assetDetail.name ?? '';
    _descriptionController.text = widget.assetDetail.description ?? '';

    if (widget.assetDetail.attributes != null) {
      widget.assetDetail.attributes!.forEach((key, value) {
        _attributes.add(MapEntry(key, value.toString()));
      });
    }
  }

  @override
  void dispose() {
    _customIdController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _convertAttributesToMap() {
    final Map<String, dynamic> result = {};
    for (final entry in _attributes) {
      if (entry.key.isNotEmpty) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  void _addAttribute() {
    setState(() {
      _attributes.add(const MapEntry('', ''));
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      _attributes.removeAt(index);
    });
  }

  void _updateAttribute(int index, String key, String value) {
    setState(() {
      _attributes[index] = MapEntry(key, value);
    });
  }

  Future<void> _updateAsset() async {
    if (_customIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom ID is required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final AssetProfile profile = AssetProfile(
        customId: _customIdController.text.trim(),
        name: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : '',
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : '',
        attributes: _convertAttributesToMap(),
      );

      final AssetResult result =
          await AssetTracking().updateAsset(assetProfile: profile);

      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asset updated successfully')),
          );
          widget.onAssetUpdated?.call();
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update asset: ${result.msg}')),
          );
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating asset: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Asset'),
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              TextButton(
                onPressed: _updateAsset,
                child: const Text('Save'),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom ID Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Custom ID *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customIdController,
                        decoration: const InputDecoration(
                          labelText: 'Custom ID',
                          border: OutlineInputBorder(),
                          hintText: 'Enter custom ID',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name (optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          hintText: 'Enter asset name',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description (optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          hintText: 'Enter asset description',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Attributes Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Attributes (optional)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addAttribute,
                            tooltip: 'Add Attribute',
                          ),
                        ],
                      ),
                      if (_attributes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'No attributes added',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ..._attributes.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final MapEntry<String, String> attribute = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Key',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) => _updateAttribute(
                                      index, value, attribute.value),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Value',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) => _updateAttribute(
                                      index, attribute.key, value),
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeAttribute(index),
                                tooltip: 'Remove Attribute',
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
