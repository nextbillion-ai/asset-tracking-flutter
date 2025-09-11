import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/screen/time_format.dart';

import '../util/toast_mixin.dart';

class TripSummaryScreen extends StatefulWidget {
  const TripSummaryScreen({required this.tripId, super.key});
  final String tripId;

  @override
  TripSummaryScreenState createState() => TripSummaryScreenState();
}

class TripSummaryScreenState extends State<TripSummaryScreen> with ToastMixin {
  TripSummary? tripSummary;
  String errorMessage = 'Fetching data...';

  @override
  void initState() {
    super.initState();
    AssetTracking()
        .getSummary(tripId: widget.tripId)
        .then((AssetResult<TripSummary> value) {
      setState(() {
        if (value.success) {
          tripSummary = value.data;
        } else {
          showToast(value.msg ?? '');
          errorMessage = value.msg ?? '';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Trip Summary'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: tripSummary == null
              ? Center(
                  child: Text(errorMessage),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildBasicInfoCard(),
                    const SizedBox(height: 16),
                    _buildTimeInfoCard(),
                    const SizedBox(height: 16),
                    _buildLocationRouteCard(),
                    const SizedBox(height: 16),
                    _buildMetaDataCard(),
                    const SizedBox(height: 16),
                    _buildAssetInfoCard(),
                  ],
                ),
        ),
      );

  /// Build basic information card
  Widget _buildBasicInfoCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '📋 Basic Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildInfoItem('Trip ID', tripSummary!.id),
              _buildInfoItem('Asset ID', tripSummary!.assetId),
              _buildInfoItem('Status', tripSummary!.state),
              _buildInfoItem('Name', tripSummary!.name),
              if (tripSummary!.description != null)
                _buildInfoItem('Description', tripSummary!.description!),
            ],
          ),
        ),
      );

  /// Build time information card
  Widget _buildTimeInfoCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '🕐 Time Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildInfoItem('Started At', timeFormat(tripSummary!.startedAt)),
              if (tripSummary!.endedAt != null)
                _buildInfoItem('Ended At', timeFormat(tripSummary!.endedAt)),
              if (tripSummary!.createdAt != null)
                _buildInfoItem(
                    'Created At', timeFormat(tripSummary!.createdAt)),
              if (tripSummary!.updatedAt != null)
                _buildInfoItem(
                    'Updated At', timeFormat(tripSummary!.updatedAt)),
              if (tripSummary!.duration != null)
                _buildInfoItem('Duration',
                    '${(tripSummary!.duration! / 1000 / 60).toStringAsFixed(1)} minutes'),
            ],
          ),
        ),
      );

  /// Build location and route information card
  Widget _buildLocationRouteCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '📍 Location & Route Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              if (tripSummary!.distance != null)
                _buildInfoItem('Total Distance',
                    '${(tripSummary!.distance! / 1000).toStringAsFixed(2)} km'),
              if (tripSummary!.geometry != null) ...[
                _buildInfoItem('Geometry Data',
                    '${tripSummary!.geometry!.length} coordinate points'),
                const SizedBox(height: 8),
                _buildExpandableSection(
                    'View Geometry Data', tripSummary!.geometry!.join(', ')),
              ],
              if (tripSummary!.stops != null &&
                  tripSummary!.stops!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '📍 Trip Stops (${tripSummary!.stops!.length})',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...tripSummary!.stops!.asMap().entries.map(
                    (MapEntry<int, TripStop> entry) =>
                        _buildStopInfo(entry.key + 1, entry.value)),
              ],
              if (tripSummary!.route != null &&
                  tripSummary!.route!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '🛣️ Route Records (${tripSummary!.route!.length})',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                _buildExpandableSection('View Route Details',
                    'Total ${tripSummary!.route!.length} location points\n${_getRouteStatsText()}'),
              ],
            ],
          ),
        ),
      );

  /// Build metadata card
  Widget _buildMetaDataCard() {
    if (tripSummary!.attributes == null && tripSummary!.metaData == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '🏷️ Metadata Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (tripSummary!.attributes != null) ...[
              const Text(
                'Attributes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildKeyValueList(tripSummary!.attributes!),
              const SizedBox(height: 12),
            ],
            if (tripSummary!.metaData != null) ...[
              const Text(
                'MetaData',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildKeyValueList(tripSummary!.metaData!),
            ],
          ],
        ),
      ),
    );
  }

  /// Build asset information card
  Widget _buildAssetInfoCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '🚗 Asset Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildInfoItem('Asset ID', tripSummary!.asset.id),
              _buildInfoItem('Device ID', tripSummary!.asset.deviceId),
              _buildInfoItem('Status', tripSummary!.asset.state),
              _buildInfoItem('Name', tripSummary!.asset.name),
              _buildInfoItem('Description', tripSummary!.asset.description),
              _buildInfoItem(
                  'Created At',
                  timeFormat(DateTime.fromMillisecondsSinceEpoch(
                      (tripSummary!.asset.createdAt * 1000).toInt()))),
            ],
          ),
        ),
      );

  /// Build information item
  Widget _buildInfoItem(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );

  /// Build trip stop information
  Widget _buildStopInfo(int index, TripStop stop) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Stop $index: ${stop.name}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            _buildInfoItem('Geofence ID', stop.geofenceId),
            if (stop.metaData != null && stop.metaData!.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text('MetaData:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              _buildKeyValueList(stop.metaData!),
            ],
          ],
        ),
      );

  /// Build key-value pair list
  Widget _buildKeyValueList(Map<String, dynamic> data) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: data.entries
              .map<Widget>((MapEntry<String, dynamic> entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${entry.key}:',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );

  /// Build expandable section
  Widget _buildExpandableSection(String title, String content) => ExpansionTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  /// Get route statistics text
  String _getRouteStatsText() {
    if (tripSummary!.route == null || tripSummary!.route!.isEmpty) {
      return 'No route data available';
    }

    final List<TrackLocation> route = tripSummary!.route!;
    final double avgSpeed = route
            .where((TrackLocation loc) => loc.speed != null && loc.speed! > 0)
            .map<double>((TrackLocation loc) => loc.speed!.toDouble())
            .fold<double>(0, (double sum, double speed) => sum + speed) /
        route.length;

    final double avgAccuracy = route
            .where((TrackLocation loc) => loc.accuracy != null)
            .map<double>((TrackLocation loc) => loc.accuracy!.toDouble())
            .fold<double>(0, (double sum, double acc) => sum + acc) /
        route.length;

    return 'Average Speed: ${avgSpeed.toStringAsFixed(1)} km/h\n'
        'Average Accuracy: ${avgAccuracy.toStringAsFixed(1)} meters';
  }
}
