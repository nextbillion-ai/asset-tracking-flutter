import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'edit_asset_screen.dart';

class AssetDetailScreen extends StatefulWidget {
  const AssetDetailScreen({super.key});

  @override
  AssetDetailScreenState createState() => AssetDetailScreenState();
}

class AssetDetailScreenState extends State<AssetDetailScreen> {
  AssetDetailInfo? _assetDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAssetDetail();
  }

  Future<void> _loadAssetDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final AssetResult<AssetDetailInfo> result =
          await AssetTracking().getAssetDetail();
      if (result.success) {
        setState(() {
          _assetDetail = result.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result.msg ?? 'Failed to load asset details';
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _errorMessage = 'Error loading asset details: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToEdit() {
    if (_assetDetail != null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => EditAssetScreen(
            assetDetail: _assetDetail!,
            onAssetUpdated: _loadAssetDetail,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Asset Details'),
          actions: <Widget>[
            if (_assetDetail != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _navigateToEdit,
                tooltip: 'Edit Asset',
              ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadAssetDetail,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAssetDetail,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _assetDetail == null
                    ? const Center(
                        child: Text('No asset details available'),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildDetailCard(
                              'Basic Information',
                              <Widget>[
                                _buildDetailRow(
                                    'ID', _assetDetail!.id ?? 'N/A'),
                                _buildDetailRow('Device ID',
                                    _assetDetail!.deviceId ?? 'N/A'),
                                _buildDetailRow(
                                    'Name', _assetDetail!.name ?? 'N/A'),
                                _buildDetailRow('Description',
                                    _assetDetail!.description ?? 'N/A'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildDetailCard(
                              'Timestamps',
                              <Widget>[
                                _buildDetailRow(
                                  'Created At',
                                  _assetDetail!.createdAt != null
                                      ? DateTime.fromMillisecondsSinceEpoch(
                                              (_assetDetail!.createdAt! * 1000)
                                                  .toInt())
                                          .toString()
                                      : 'N/A',
                                ),
                                _buildDetailRow(
                                  'Updated At',
                                  _assetDetail!.updatedAt != null
                                      ? DateTime.fromMillisecondsSinceEpoch(
                                              (_assetDetail!.updatedAt! * 1000)
                                                  .toInt())
                                          .toString()
                                      : 'N/A',
                                ),
                              ],
                            ),
                            if (_assetDetail!.attributes != null &&
                                _assetDetail!
                                    .attributes!.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 16),
                              _buildDetailCard(
                                'Attributes',
                                _assetDetail!.attributes!.entries
                                    .map((MapEntry<String, dynamic> entry) =>
                                        _buildDetailRow(
                                            entry.key, entry.value.toString()))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
      );

  Widget _buildDetailCard(String title, List<Widget> children) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );

  Widget _buildDetailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 100,
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
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
}
