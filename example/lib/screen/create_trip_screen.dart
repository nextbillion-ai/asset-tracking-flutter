import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';
import 'package:uuid/uuid.dart';

class CreateTripScreen extends StatefulWidget {
  final VoidCallback? onTripCreated;

  const CreateTripScreen({
    super.key,
    this.onTripCreated,
  });

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> with ToastMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<MapEntry<String, String>> _attributes = [];
  final List<MapEntry<String, String>> _metaData = [];
  final List<TripStopInput> _stops = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // 默认填充 customId
    _customIdController.text = const Uuid().v4();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _convertToMap(List<MapEntry<String, String>> entries) {
    final Map<String, dynamic> result = {};
    for (final entry in entries) {
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

  void _addMetaData() {
    setState(() {
      _metaData.add(const MapEntry('', ''));
    });
  }

  void _removeMetaData(int index) {
    setState(() {
      _metaData.removeAt(index);
    });
  }

  void _updateMetaData(int index, String key, String value) {
    setState(() {
      _metaData[index] = MapEntry(key, value);
    });
  }

  void _addStop() {
    setState(() {
      _stops.add(TripStopInput());
    });
  }

  void _removeStop(int index) {
    setState(() {
      _stops.removeAt(index);
    });
  }

  void _updateStop(int index, TripStopInput stop) {
    setState(() {
      _stops[index] = stop;
    });
  }

  List<TripStop> _convertStops() {
    return _stops.map((stop) => stop.toTripStop()).toList();
  }

  Future<void> _createTrip() async {
    if (_nameController.text.trim().isEmpty) {
      showToast('Trip name is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final TripProfile profile = TripProfile(
        name: _nameController.text.trim(),
        customId: _customIdController.text.trim().isNotEmpty
            ? _customIdController.text.trim()
            : null,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        attributes: _convertToMap(_attributes).isNotEmpty
            ? _convertToMap(_attributes)
            : null,
        metaData: _convertToMap(_metaData).isNotEmpty
            ? _convertToMap(_metaData)
            : null,
        stops: _convertStops().isNotEmpty ? _convertStops() : null,
      );

      final AssetResult result =
          await AssetTracking().startTrip(profile: profile);

      if (result.success) {
        showToast('Trip created successfully');
        widget.onTripCreated?.call();
        Navigator.of(context).pop();
      } else {
        showToast('Failed to create trip: ${result.msg}');
      }
    } catch (e) {
      showToast('Error creating trip: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _createTrip,
              child: const Text('Create'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Section (Required)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Name *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Trip Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter trip name',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Custom ID Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom ID (optional)',
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

            // Description Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                        hintText: 'Enter trip description',
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
                padding: const EdgeInsets.all(16.0),
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No attributes added',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ..._attributes.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final MapEntry<String, String> attribute = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeAttribute(index),
                              tooltip: 'Remove Attribute',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Meta Data Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Meta Data (optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addMetaData,
                          tooltip: 'Add Meta Data',
                        ),
                      ],
                    ),
                    if (_metaData.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No meta data added',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ..._metaData.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final MapEntry<String, String> metaData = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Key',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) => _updateMetaData(
                                    index, value, metaData.value),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Value',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) =>
                                    _updateMetaData(index, metaData.key, value),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeMetaData(index),
                              tooltip: 'Remove Meta Data',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stops Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Stops (optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addStop,
                          tooltip: 'Add Stop',
                        ),
                      ],
                    ),
                    if (_stops.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No stops added',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ..._stops.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final TripStopInput stop = entry.value;
                      return _buildStopInput(index, stop);
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopInput(int index, TripStopInput stop) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stop ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeStop(index),
                  tooltip: 'Remove Stop',
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                stop.name = value;
                _updateStop(index, stop);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Geofence ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                stop.geofenceId = value;
                _updateStop(index, stop);
              },
            ),
            const SizedBox(height: 8),
            // MetaData for this stop
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meta Data (optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    stop.metaData.add(const MapEntry('', ''));
                    _updateStop(index, stop);
                  },
                  tooltip: 'Add Meta Data',
                ),
              ],
            ),
            if (stop.metaData.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No meta data added',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ...stop.metaData.asMap().entries.map((metaEntry) {
              final int metaIndex = metaEntry.key;
              final MapEntry<String, String> metaData = metaEntry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Key',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          stop.metaData[metaIndex] =
                              MapEntry(value, metaData.value);
                          _updateStop(index, stop);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          stop.metaData[metaIndex] =
                              MapEntry(metaData.key, value);
                          _updateStop(index, stop);
                        },
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {
                        stop.metaData.removeAt(metaIndex);
                        _updateStop(index, stop);
                      },
                      tooltip: 'Remove Meta Data',
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class TripStopInput {
  String name;
  String geofenceId;
  final List<MapEntry<String, String>> metaData;

  TripStopInput({
    this.name = '',
    this.geofenceId = '',
    List<MapEntry<String, String>>? metaData,
  }) : metaData = metaData ?? [];

  TripStop toTripStop() {
    return TripStop(
      name: name,
      geofenceId: geofenceId,
      metaData: metaData.isNotEmpty
          ? Map<String, dynamic>.fromEntries(metaData)
          : null,
    );
  }
}
