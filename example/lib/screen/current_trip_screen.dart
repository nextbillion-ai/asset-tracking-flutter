import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'edit_trip_screen.dart';

class CurrentTripInfoScreen extends StatefulWidget {
  const CurrentTripInfoScreen({required this.tripId, super.key});
  final String tripId;

  @override
  TripInfoScreenState createState() => TripInfoScreenState();
}

class TripInfoScreenState extends State<CurrentTripInfoScreen> {
  Future<TripInfo>? _tripInfoFuture;

  @override
  void initState() {
    super.initState();
    _loadTripInfo();
  }

  void _loadTripInfo() {
    setState(() {
      _tripInfoFuture = _fetchTripInfo();
    });
  }

  Future<TripInfo> _fetchTripInfo() async {
    final AssetResult result =
        await AssetTracking().getTrip(tripId: widget.tripId);
    if (result.success) {
      return result.data;
    } else {
      throw Exception(result.msg);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Trip Information'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context),
            ),
          ],
        ),
        body: FutureBuilder<TripInfo>(
          future: _tripInfoFuture,
          builder: (BuildContext context, AsyncSnapshot<TripInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadTripInfo,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No Trip Info Found'),
                  ],
                ),
              );
            }

            final TripInfo tripInfo = snapshot.data!;

            return RefreshIndicator(
              onRefresh: () async => _loadTripInfo(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoCard(tripInfo),
                    const SizedBox(height: 16),
                    _buildTimeInfoCard(tripInfo),
                    const SizedBox(height: 16),
                    if (tripInfo.metaData != null ||
                        tripInfo.attributes != null)
                      _buildMetadataCard(tripInfo),
                    if (tripInfo.metaData != null ||
                        tripInfo.attributes != null)
                      const SizedBox(height: 16),
                    if (tripInfo.stops != null && tripInfo.stops!.isNotEmpty)
                      _buildStopsCard(tripInfo),
                    if (tripInfo.stops != null && tripInfo.stops!.isNotEmpty)
                      const SizedBox(height: 16),
                    if (tripInfo.route != null && tripInfo.route!.isNotEmpty)
                      _buildRouteCard(tripInfo),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Widget _buildBasicInfoCard(TripInfo tripInfo) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Trip ID', tripInfo.id),
              _buildInfoRow('Asset ID', tripInfo.assetId),
              _buildInfoRow('State', tripInfo.state,
                  valueColor: _getStateColor(tripInfo.state)),
              _buildInfoRow('Name', tripInfo.name),
              if (tripInfo.description != null &&
                  tripInfo.description!.isNotEmpty)
                _buildInfoRow('Description', tripInfo.description!),
            ],
          ),
        ),
      );

  Widget _buildTimeInfoCard(TripInfo tripInfo) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                children: [
                  Icon(Icons.schedule, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Time Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Started At', _formatDateTime(tripInfo.startedAt)),
              if (tripInfo.endedAt != null)
                _buildInfoRow('Ended At', _formatDateTime(tripInfo.endedAt)),
              _buildInfoRow('Created At', _formatDateTime(tripInfo.createdAt)),
              if (tripInfo.updatedAt != null)
                _buildInfoRow(
                    'Updated At', _formatDateTime(tripInfo.updatedAt)),
            ],
          ),
        ),
      );

  Widget _buildMetadataCard(TripInfo tripInfo) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.data_usage, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Metadata',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (tripInfo.metaData != null &&
                  tripInfo.metaData!.isNotEmpty) ...[
                const Text(
                  'Meta Data:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...tripInfo.metaData!.entries.map((entry) => _buildInfoRow(
                    entry.key, entry.value.toString(),
                    indent: true)),
                const SizedBox(height: 16),
              ],
              if (tripInfo.attributes != null &&
                  tripInfo.attributes!.isNotEmpty) ...[
                const Text(
                  'Attributes:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...tripInfo.attributes!.entries.map((entry) => _buildInfoRow(
                    entry.key, entry.value.toString(),
                    indent: true)),
              ],
            ],
          ),
        ),
      );

  Widget _buildStopsCard(TripInfo tripInfo) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Stops (${tripInfo.stops!.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...tripInfo.stops!.asMap().entries.map((entry) {
                final index = entry.key;
                final stop = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              stop.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Geofence ID', stop.geofenceId,
                          indent: true),
                      if (stop.metaData != null &&
                          stop.metaData!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Stop Metadata:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ...stop.metaData!.entries.map((metaEntry) =>
                            _buildInfoRow(
                                metaEntry.key, metaEntry.value.toString(),
                                indent: true)),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      );

  Widget _buildRouteCard(TripInfo tripInfo) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Icon(Icons.route, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                    'Route (${tripInfo.route!.length} points)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: tripInfo.route!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final TrackLocation location = tripInfo.route![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Point ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow('Location',
                              '${location.location?.lat.toStringAsFixed(6)}, ${location.location?.lon.toStringAsFixed(6)}',
                              indent: true),
                          if (location.speed != null)
                            _buildInfoRow('Speed',
                                '${location.speed!.toStringAsFixed(1)} km/h',
                                indent: true),
                          if (location.accuracy != null)
                            _buildInfoRow('Accuracy',
                                '${location.accuracy!.toStringAsFixed(1)}m',
                                indent: true),
                          if (location.altitude != null)
                            _buildInfoRow('Altitude',
                                '${location.altitude!.toStringAsFixed(1)}m',
                                indent: true),
                          if (location.bearing != null)
                            _buildInfoRow('Bearing',
                                '${location.bearing!.toStringAsFixed(1)}°',
                                indent: true),
                          _buildInfoRow('Battery', '${location.batteryLevel}%',
                              indent: true),
                          _buildInfoRow(
                              'Time', _formatDateTime(location.timestamp),
                              indent: true),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildInfoRow(String label, String value,
          {bool indent = false, Color? valueColor}) =>
      Padding(
        padding: EdgeInsets.only(
          left: indent ? 16.0 : 0.0,
          bottom: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: indent ? 120 : 100,
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      );

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A';
    }
    return dateTime.toLocal().toString().split('.')[0];
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'paused':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showEditDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EditTripScreen(
          tripId: widget.tripId,
          onTripUpdated: _loadTripInfo,
        ),
      ),
    );
  }
}

class TripStopInput {
  TripStopInput({
    this.name = '',
    this.geofenceId = '',
    List<MapEntry<String, String>>? metaData,
  }) : metaData = metaData ?? [];
  String name;
  String geofenceId;
  final List<MapEntry<String, String>> metaData;

  TripStop toTripStop() => TripStop(
        name: name,
        geofenceId: geofenceId,
        metaData: metaData.isNotEmpty
            ? Map<String, dynamic>.fromEntries(metaData)
            : null,
      );
}
