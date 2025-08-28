import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';

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

class EditTripScreen extends StatefulWidget {
  final String tripId;
  final VoidCallback? onTripUpdated;

  const EditTripScreen({
    super.key,
    required this.tripId,
    this.onTripUpdated,
  });

  @override
  EditTripScreenState createState() => EditTripScreenState();
}

class EditTripScreenState extends State<EditTripScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  // Attributes key-value pairs
  final List<MapEntry<String, String>> _attributes = [];

  // MetaData key-value pairs
  final List<MapEntry<String, String>> _metaData = [];

  // Stops list
  final List<TripStopInput> _stops = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _convertToMap(List<MapEntry<String, String>> entries) {
    if (entries.isEmpty) return null;
    return Map<String, dynamic>.fromEntries(entries);
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

  List<TripStop>? _convertStops() {
    if (_stops.isEmpty) return null;
    return _stops.map((stopInput) => stopInput.toTripStop()).toList();
  }

  Future<void> _updateTrip() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Only include fields that have been filled
      final Map<String, dynamic> updateData = <String, dynamic>{};

      if (_nameController.text.isNotEmpty) {
        updateData['name'] = _nameController.text;
      }

      if (_descriptionController.text.isNotEmpty) {
        updateData['description'] = _descriptionController.text;
      }

      final Map<String, dynamic>? attributes = _convertToMap(_attributes);
      if (attributes != null) {
        updateData['attributes'] = attributes;
      }

      final Map<String, dynamic>? metaData = _convertToMap(_metaData);
      if (metaData != null) {
        updateData['metaData'] = metaData;
      }

      final List<TripStop>? stops = _convertStops();
      if (stops != null) {
        updateData['stops'] = stops;
      }

      // Create TripUpdateProfile with the filled data
      final TripUpdateProfile profile = TripUpdateProfile(
        name: _nameController.text.isNotEmpty
            ? _nameController.text
            : 'Updated Trip',
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        attributes: attributes,
        metaData: metaData,
        stops: stops,
      );

      final AssetResult result =
          await AssetTracking().updateTrip(profile: profile);

      if (result.success) {
        if (mounted) {
          // Call the callback to refresh the trip data
          widget.onTripUpdated?.call();

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip updated successfully!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update trip: ${result.msg}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating trip: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Trip'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name (optional)',
                  hintText: 'Enter trip name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Enter trip description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
              // MetaData Section
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
                                  onChanged: (value) => _updateMetaData(
                                      index, metaData.key, value),
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateTrip,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Update Trip',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
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
