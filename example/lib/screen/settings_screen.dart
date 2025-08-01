import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with ToastMixin {
  bool _isLoading = false;
  String? _currentUserId;
  DataTrackingConfig? _dataTrackingConfig;
  LocationConfig? _locationConfig;
  DefaultConfig? _defaultConfig;
  AndroidNotificationConfig? _androidNotificationConfig;
  IOSNotificationConfig? _iosNotificationConfig;

  @override
  void initState() {
    super.initState();
    _loadConfigurations();
  }

  Future<void> _loadConfigurations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadUserId(),
        _loadDataTrackingConfig(),
        _loadLocationConfig(),
        _loadDefaultConfig(),
        _loadNotificationConfigs(),
      ]);
    } catch (e) {
      showToast('Error loading configurations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDataTrackingConfig() async {
    try {
      final result = await AssetTracking().getDataTrackingConfig();
      if (result.success) {
        setState(() {
          _dataTrackingConfig = result.data;
        });
      }
    } catch (e) {
      // Ignore the error and use the default configuration
    }
  }

  Future<void> _loadLocationConfig() async {
    try {
      final result = await AssetTracking().getLocationConfig();
      if (result.success) {
        setState(() {
          _locationConfig = result.data;
        });
      }
    } catch (e) {
      // Ignore the error and use the default configuration
    }
  }

  Future<void> _loadUserId() async {
    try {
      final result = await AssetTracking().getUserId();
      if (result.success) {
        setState(() {
          _currentUserId = result.data;
        });
      }
    } catch (e) {
      // Ignore the error and use empty user ID
    }
  }

  Future<void> _loadDefaultConfig() async {
    try {
      final result = await AssetTracking().getDefaultConfig();
      if (result.success) {
        setState(() {
          _defaultConfig = result.data;
        });
      }
    } catch (e) {
      // Ignore the error and use the default configuration
    }
  }

  Future<void> _loadNotificationConfigs() async {
    try {
      if (Platform.isAndroid) {
        final result = await AssetTracking().getAndroidNotificationConfig();
        if (result.success) {
          setState(() {
            _androidNotificationConfig = result.data;
          });
        }
      } else {
        final result = await AssetTracking().getIOSNotificationConfig();
        if (result.success) {
          setState(() {
            _iosNotificationConfig = result.data;
          });
        }
      }
    } catch (e) {
      // Ignore the error and use the default configuration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadConfigurations,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserIdCard(),
                  const SizedBox(height: 16),
                  _buildDataTrackingConfigCard(),
                  const SizedBox(height: 16),
                  _buildLocationConfigCard(),
                  const SizedBox(height: 16),
                  _buildDefaultConfigCard(),
                  const SizedBox(height: 16),
                  _buildNotificationConfigCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildDataTrackingConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data Tracking Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showDataTrackingConfigDialog(),
                  tooltip: 'Edit Data Tracking Config',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_dataTrackingConfig != null) ...[
              _buildConfigItem('Base URL', _dataTrackingConfig!.baseUrl),
              _buildConfigItem('Data Storage Size', _dataTrackingConfig!.dataStorageSize.toString()),
              _buildConfigItem('Data Uploading Batch Size', _dataTrackingConfig!.dataUploadingBatchSize.toString()),
              _buildConfigItem('Data Uploading Batch Window', _dataTrackingConfig!.dataUploadingBatchWindow.toString()),
              _buildConfigItem('Clear Local Data When Collision', _dataTrackingConfig!.shouldClearLocalDataWhenCollision.toString()),
            ] else
              const Text('No configuration available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Location Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showLocationConfigDialog(),
                  tooltip: 'Edit Location Config',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_locationConfig != null) ...[
              _buildConfigItem('Tracking Mode', _locationConfig!.trackingMode?.toString() ?? 'N/A'),
              _buildConfigItem('Interval (Android)', _locationConfig!.intervalForAndroid?.toString() ?? 'N/A'),
              _buildConfigItem('Smallest Displacement', _locationConfig!.smallestDisplacement?.toString() ?? 'N/A'),
              _buildConfigItem('Desired Accuracy', _locationConfig!.desiredAccuracy?.toString() ?? 'N/A'),
              _buildConfigItem('Max Wait Time (Android)', _locationConfig!.maxWaitTimeForAndroid?.toString() ?? 'N/A'),
              _buildConfigItem('Fastest Interval (Android)', _locationConfig!.fastestIntervalForAndroid?.toString() ?? 'N/A'),
              _buildConfigItem('Enable Stationary Check', _locationConfig!.enableStationaryCheck?.toString() ?? 'N/A'),
            ] else
              const Text('No configuration available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Default Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showDefaultConfigDialog(),
                  tooltip: 'Edit Default Config',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_defaultConfig != null) ...[
              _buildConfigItem('Enhance Service', _defaultConfig!.enhanceService.toString()),
              _buildConfigItem('Repeat Interval', _defaultConfig!.repeatInterval.toString()),
              _buildConfigItem('Worker Enabled', _defaultConfig!.workerEnabled.toString()),
              _buildConfigItem('Crash Restart Enabled', _defaultConfig!.crashRestartEnabled.toString()),
              _buildConfigItem('Work On Main Thread', _defaultConfig!.workOnMainThread.toString()),
            ] else
              const Text('No configuration available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${Platform.isAndroid ? 'Android' : 'iOS'} Notification Configuration',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showNotificationConfigDialog(),
                  tooltip: 'Edit Notification Config',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (Platform.isAndroid) ...[
              if (_androidNotificationConfig != null) ...[
                _buildConfigItem('Service ID', _androidNotificationConfig!.serviceId.toString()),
                _buildConfigItem('Channel ID', _androidNotificationConfig!.channelId),
                _buildConfigItem('Channel Name', _androidNotificationConfig!.channelName),
                _buildConfigItem('Title', _androidNotificationConfig!.title),
                _buildConfigItem('Content', _androidNotificationConfig!.content),
                _buildConfigItem('Small Icon', _androidNotificationConfig!.smallIcon),
                _buildConfigItem('Large Icon', _androidNotificationConfig!.largeIcon),
                _buildConfigItem('Show Low Battery Notification', _androidNotificationConfig!.showLowBatteryNotification.toString()),
              ] else
                const Text('No configuration available', style: TextStyle(color: Colors.grey)),
            ] else ...[
              if (_iosNotificationConfig != null) ...[
                _buildConfigItem('Show Asset Enable Notification', _iosNotificationConfig!.showAssetEnableNotification.toString()),
                _buildConfigItem('Show Asset Disable Notification', _iosNotificationConfig!.showAssetDisableNotification.toString()),
              ] else
                const Text('No configuration available', style: TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserIdCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User ID Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showUserIdDialog(),
                  tooltip: 'Edit User ID',
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildConfigItem('User ID', _currentUserId ?? 'Not set'),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showUserIdDialog() {
    final userIdController = TextEditingController(text: _currentUserId ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User ID'),
        content: TextField(
          controller: userIdController,
          decoration: const InputDecoration(
            labelText: 'User ID',
            hintText: 'Enter user ID',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final userId = userIdController.text.trim();
                if (userId.isNotEmpty) {
                  await AssetTracking().setupUserId(userId: userId);
                  await _loadUserId();
                  Navigator.pop(context);
                  showToast('User ID updated successfully');
                } else {
                  showToast('User ID cannot be empty');
                }
              } catch (e) {
                showToast('Error updating user ID: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDataTrackingConfigDialog() {
    final baseUrlController = TextEditingController(text: _dataTrackingConfig?.baseUrl ?? '');
    final storageSizeController = TextEditingController(text: _dataTrackingConfig?.dataStorageSize.toString() ?? '5000');
    final batchSizeController = TextEditingController(text: _dataTrackingConfig?.dataUploadingBatchSize.toString() ?? '30');
    final batchWindowController = TextEditingController(text: _dataTrackingConfig?.dataUploadingBatchWindow.toString() ?? '20');
    bool clearLocalData = _dataTrackingConfig?.shouldClearLocalDataWhenCollision ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data Tracking Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: baseUrlController,
                decoration: const InputDecoration(labelText: 'Base URL'),
              ),
              TextField(
                controller: storageSizeController,
                decoration: const InputDecoration(labelText: 'Data Storage Size'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: batchSizeController,
                decoration: const InputDecoration(labelText: 'Data Uploading Batch Size'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: batchWindowController,
                decoration: const InputDecoration(labelText: 'Data Uploading Batch Window'),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Clear Local Data When Collision'),
                value: clearLocalData,
                onChanged: (value) => setState(() => clearLocalData = value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final config = DataTrackingConfig(
                  baseUrl: baseUrlController.text,
                  dataStorageSize: int.tryParse(storageSizeController.text) ?? 5000,
                  dataUploadingBatchSize: int.tryParse(batchSizeController.text) ?? 30,
                  dataUploadingBatchWindow: int.tryParse(batchWindowController.text) ?? 20,
                  shouldClearLocalDataWhenCollision: clearLocalData,
                );
                await AssetTracking().setDataTrackingConfig(config: config);
                await _loadDataTrackingConfig();
                Navigator.pop(context);
                showToast('Data tracking config updated successfully');
              } catch (e) {
                showToast('Error updating data tracking config: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLocationConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Configuration'),
        content: const Text('Location configuration is managed through the main tracking controls.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDefaultConfigDialog() {
    final enhanceServiceController = TextEditingController(text: _defaultConfig?.enhanceService.toString() ?? 'true');
    final repeatIntervalController = TextEditingController(text: _defaultConfig?.repeatInterval.toString() ?? '1000');
    final workerEnabledController = TextEditingController(text: _defaultConfig?.workerEnabled.toString() ?? 'true');
    final crashRestartEnabledController = TextEditingController(text: _defaultConfig?.crashRestartEnabled.toString() ?? 'true');
    final workOnMainThreadController = TextEditingController(text: _defaultConfig?.workOnMainThread.toString() ?? 'false');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Default Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Enhance Service'),
                value: _defaultConfig?.enhanceService ?? true,
                onChanged: (value) => enhanceServiceController.text = value.toString(),
              ),
              TextField(
                controller: repeatIntervalController,
                decoration: const InputDecoration(labelText: 'Repeat Interval'),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Worker Enabled'),
                value: _defaultConfig?.workerEnabled ?? true,
                onChanged: (value) => workerEnabledController.text = value.toString(),
              ),
              CheckboxListTile(
                title: const Text('Crash Restart Enabled'),
                value: _defaultConfig?.crashRestartEnabled ?? true,
                onChanged: (value) => crashRestartEnabledController.text = value.toString(),
              ),
              CheckboxListTile(
                title: const Text('Work On Main Thread'),
                value: _defaultConfig?.workOnMainThread ?? false,
                onChanged: (value) => workOnMainThreadController.text = value.toString(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final config = DefaultConfig(
                  enhanceService: enhanceServiceController.text.toLowerCase() == 'true',
                  repeatInterval: int.tryParse(repeatIntervalController.text) ?? 1000,
                  workerEnabled: workerEnabledController.text.toLowerCase() == 'true',
                  crashRestartEnabled: crashRestartEnabledController.text.toLowerCase() == 'true',
                  workOnMainThread: workOnMainThreadController.text.toLowerCase() == 'true',
                );
                await AssetTracking().setDefaultConfig(config: config);
                await _loadDefaultConfig();
                Navigator.pop(context);
                showToast('Default config updated successfully');
              } catch (e) {
                showToast('Error updating default config: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showNotificationConfigDialog() {
    if (Platform.isAndroid) {
      _showAndroidNotificationConfigDialog();
    } else {
      _showIOSNotificationConfigDialog();
    }
  }

  void _showAndroidNotificationConfigDialog() {
    final serviceIdController = TextEditingController(text: _androidNotificationConfig?.serviceId.toString() ?? '1');
    final channelIdController = TextEditingController(text: _androidNotificationConfig?.channelId ?? '');
    final channelNameController = TextEditingController(text: _androidNotificationConfig?.channelName ?? '');
    final titleController = TextEditingController(text: _androidNotificationConfig?.title ?? '');
    final contentController = TextEditingController(text: _androidNotificationConfig?.content ?? '');
    final smallIconController = TextEditingController(text: _androidNotificationConfig?.smallIcon ?? '');
    final largeIconController = TextEditingController(text: _androidNotificationConfig?.largeIcon ?? '');
    bool showLowBatteryNotification = _androidNotificationConfig?.showLowBatteryNotification ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Android Notification Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: serviceIdController,
                decoration: const InputDecoration(labelText: 'Service ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: channelIdController,
                decoration: const InputDecoration(labelText: 'Channel ID'),
              ),
              TextField(
                controller: channelNameController,
                decoration: const InputDecoration(labelText: 'Channel Name'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              TextField(
                controller: smallIconController,
                decoration: const InputDecoration(
                  labelText: 'Small Icon',
                  hintText: 'Configure in drawable resources',
                ),
                enabled: false,
                style: const TextStyle(color: Colors.grey),
              ),
              TextField(
                controller: largeIconController,
                decoration: const InputDecoration(
                  labelText: 'Large Icon',
                  hintText: 'Configure in drawable resources',
                ),
                enabled: false,
                style: const TextStyle(color: Colors.grey),
              ),
              CheckboxListTile(
                title: const Text('Show Low Battery Notification'),
                value: showLowBatteryNotification,
                onChanged: (value) => setState(() => showLowBatteryNotification = value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final config = AndroidNotificationConfig(
                  serviceId: int.tryParse(serviceIdController.text) ?? 1,
                  channelId: channelIdController.text,
                  channelName: channelNameController.text,
                  title: titleController.text,
                  content: contentController.text,
                  smallIcon: smallIconController.text,
                  largeIcon: largeIconController.text,
                  showLowBatteryNotification: showLowBatteryNotification,
                );
                await AssetTracking().setAndroidNotificationConfig(config: config);
                await _loadNotificationConfigs();
                Navigator.pop(context);
                showToast('Android notification config updated successfully');
              } catch (e) {
                showToast('Error updating Android notification config: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showIOSNotificationConfigDialog() {
    bool showAssetEnableNotification = _iosNotificationConfig?.showAssetEnableNotification ?? true;
    bool showAssetDisableNotification = _iosNotificationConfig?.showAssetDisableNotification ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit iOS Notification Config'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Show Asset Enable Notification'),
              value: showAssetEnableNotification,
              onChanged: (value) => setState(() => showAssetEnableNotification = value!),
            ),
            CheckboxListTile(
              title: const Text('Show Asset Disable Notification'),
              value: showAssetDisableNotification,
              onChanged: (value) => setState(() => showAssetDisableNotification = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final config = IOSNotificationConfig()
                  ..showAssetEnableNotification = showAssetEnableNotification
                  ..showAssetDisableNotification = showAssetDisableNotification;
                await AssetTracking().setIOSNotificationConfig(config: config);
                await _loadNotificationConfigs();
                Navigator.pop(context);
                showToast('iOS notification config updated successfully');
              } catch (e) {
                showToast('Error updating iOS notification config: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
