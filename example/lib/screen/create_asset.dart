import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../util/consts.dart';

class CreateAssetScreen extends StatefulWidget {
  const CreateAssetScreen({super.key});

  @override
  State<CreateAssetScreen> createState() => _CreateAssetScreenState();
}

class _CreateAssetScreenState extends State<CreateAssetScreen> with ToastMixin {
  final TextEditingController _customIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bindIdController = TextEditingController();

  final List<MapEntry<String, String>> _attributes = <MapEntry<String, String>>[];

  String _lastUsedAssetId = '';
  bool _isLoading = false;

  final AssetTracking _assetTracking = AssetTracking();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _prefs = await SharedPreferences.getInstance();
    final String createId = _prefs.getString(keyOfBoundId) ?? '';
    _customIdController.text = createId.isEmpty ? _generateUUID() : createId;
    _nameController.text = 'My Car';
    _descriptionController.text = "Nancy's BMW";
    _bindIdController.text = createId;
    _lastUsedAssetId = createId;
  }

  String _generateUUID() {
    const Uuid uuid = Uuid();
    return uuid.v4();
  }

  Map<String, dynamic> _convertAttributesToMap() {
    final Map<String, dynamic> result = <String, dynamic>{};
    for (final MapEntry<String, String> entry in _attributes) {
      if (entry.key.isNotEmpty) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  void _addAttribute() {
    setState(() {
      _attributes.add(const MapEntry<String, String>('', ''));
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      _attributes.removeAt(index);
    });
  }

  void _updateAttribute(int index, String key, String value) {
    setState(() {
      _attributes[index] = MapEntry<String, String>(key, value);
    });
  }

  Future<void> _createAsset() async {
    if (_customIdController.text.trim().isEmpty) {
      showToast('Custom ID is required');
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

      final AssetResult<String> result =
          await _assetTracking.createAsset(profile: profile);

      if (result.success) {
        showToast('Create asset successfully with asset id ${result.data}');
        _bindIdController.text = result.data!;
      } else {
        showToast("Create asset failed: ${result.msg ?? ""}");
      }
    } on Exception catch (e) {
      showToast('Error creating asset: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _bindAsset() async {
    final String assetId = _bindIdController.text;
    if (assetId.trim().isEmpty) {
      showToast('Asset Bind ID is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final AssetResult<String> result =
          await _assetTracking.bindAsset(customId: assetId);
      if (result.success) {
        showToast('Bind asset successfully with asset id ${result.data}');
        await _saveData(result.data!);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        if (result.data == '2001') {
          await _showDialog(() async {
            final AssetResult<String> assetResult =
                await _assetTracking.forceBindAsset(customId: assetId);
            if (assetResult.success) {
              await _saveData(assetId);
              showToast(
                  'Force bind new asset successfully with assetId: $assetId');
              if (mounted) {
                Navigator.pop(context);
              }
            } else {
              showToast("Bind Failed: ${result.msg ?? ""}");
            }
          },
              title: 'Bind Failed',
              msg:
                  '${result.msg}, do you want to clear local data and force bind to new asset id?');
        } else {
          showToast("Bind Failed: ${result.msg ?? ""}");
        }
      }
    } on Exception catch (e) {
      showToast('Error binding asset: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveData(String boundId) async {
    await _prefs.setString(keyOfBoundId, boundId);
    setState(() {
      _lastUsedAssetId = boundId;
    });
  }

  Future<void> _showDialog(VoidCallback okPressedCallback,
          {required String title, required String msg}) async =>
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                okPressedCallback();
                Navigator.of(context).pop();
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Create Asset'),
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
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
                    children: <Widget>[
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
                    children: <Widget>[
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
                    children: <Widget>[
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
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
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
                      ..._attributes
                          .asMap()
                          .entries
                          .map((MapEntry<int, MapEntry<String, String>> entry) {
                        final int index = entry.key;
                        final MapEntry<String, String> attribute = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Key',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (String value) => _updateAttribute(
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
                                  onChanged: (String value) => _updateAttribute(
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
              const SizedBox(height: 16),

              // Create Asset Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createAsset,
                  child: const Text('Create Asset'),
                ),
              ),
              const SizedBox(height: 16),

              // Bind Asset Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Bind Asset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _bindIdController,
                        decoration: const InputDecoration(
                          labelText: 'Asset Bind ID',
                          border: OutlineInputBorder(),
                          hintText: 'Enter asset ID to bind',
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _bindAsset,
                          child: const Text('Bind Asset'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Last Used Asset ID
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Your last used asset ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_lastUsedAssetId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _customIdController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _bindIdController.dispose();
    super.dispose();
  }
}
