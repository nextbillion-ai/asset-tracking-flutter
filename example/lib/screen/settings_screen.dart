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
      await Future.wait<void>(<Future<void>>[
        _loadUserId(),
        _loadDataTrackingConfig(),
        _loadLocationConfig(),
        _loadDefaultConfig(),
        _loadNotificationConfigs(),
      ]);
    } on Exception catch (e) {
      showToast('Error loading configurations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDataTrackingConfig() async {
    try {
      final AssetResult<DataTrackingConfig> result =
          await AssetTracking().getDataTrackingConfig();
      if (result.success) {
        setState(() {
          _dataTrackingConfig = result.data;
        });
      }
    } on Exception {
      // Ignore the error and use the default configuration
    }
  }

  Future<void> _loadLocationConfig() async {
    try {
      final AssetResult<LocationConfig> result =
          await AssetTracking().getLocationConfig();
      if (result.success) {
        setState(() {
          _locationConfig = result.data;
        });
      }
    } on Exception {
      // Ignore the error and use the default configuration
    }
  }

  Future<void> _loadUserId() async {
    try {
      final AssetResult<String> result = await AssetTracking().getUserId();
      if (result.success) {
        setState(() {
          _currentUserId = result.data;
        });
      }
    } on Exception {
      // Ignore the error and use empty user ID
    }
  }

  Future<void> _loadDefaultConfig() async {
    try {
      final AssetResult<DefaultConfig> result =
          await AssetTracking().getDefaultConfig();
      if (result.success) {
        setState(() {
          _defaultConfig = result.data;
        });
      }
    } on Exception {
      // Ignore the error and use the default configuration
    }
  }

  Future<void> _loadNotificationConfigs() async {
    try {
      if (Platform.isAndroid) {
        final AssetResult<AndroidNotificationConfig> result =
            await AssetTracking().getAndroidNotificationConfig();
        if (result.success) {
          setState(() {
            _androidNotificationConfig = result.data;
          });
        }
      } else {
        final AssetResult<IOSNotificationConfig> result =
            await AssetTracking().getIOSNotificationConfig();
        if (result.success) {
          setState(() {
            _iosNotificationConfig = result.data;
          });
        }
      }
    } on Exception {
      // Ignore the error and use the default configuration
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: <Widget>[
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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

  Widget _buildDataTrackingConfigCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Data Tracking Configuration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showDataTrackingConfigDialog,
                    tooltip: 'Edit Data Tracking Config',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_dataTrackingConfig != null) ...<Widget>[
                _buildConfigItem('Base URL', _dataTrackingConfig!.baseUrl),
                _buildConfigItem('Data Storage Size',
                    _dataTrackingConfig!.dataStorageSize.toString()),
                _buildConfigItem('Data Uploading Batch Size',
                    _dataTrackingConfig!.dataUploadingBatchSize.toString()),
                _buildConfigItem('Data Uploading Batch Window',
                    _dataTrackingConfig!.dataUploadingBatchWindow.toString()),
                _buildConfigItem(
                    'Clear Local Data When Collision',
                    _dataTrackingConfig!.shouldClearLocalDataWhenCollision
                        .toString()),
              ] else
                const Text('No configuration available',
                    style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );

  Widget _buildLocationConfigCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Location Configuration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showLocationConfigDialog,
                    tooltip: 'Edit Location Config',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_locationConfig != null) ...<Widget>[
                _buildConfigItem('Tracking Mode',
                    _locationConfig!.trackingMode?.toString() ?? 'N/A'),
                _buildConfigItem('Interval (Android)',
                    _locationConfig!.intervalForAndroid?.toString() ?? 'N/A'),
                _buildConfigItem('Smallest Displacement',
                    _locationConfig!.smallestDisplacement?.toString() ?? 'N/A'),
                _buildConfigItem('Desired Accuracy',
                    _locationConfig!.desiredAccuracy?.toString() ?? 'N/A'),
                _buildConfigItem(
                    'Max Wait Time (Android)',
                    _locationConfig!.maxWaitTimeForAndroid?.toString() ??
                        'N/A'),
                _buildConfigItem(
                    'Fastest Interval (Android)',
                    _locationConfig!.fastestIntervalForAndroid?.toString() ??
                        'N/A'),
                _buildConfigItem(
                    'Enable Stationary Check',
                    _locationConfig!.enableStationaryCheck?.toString() ??
                        'N/A'),
              ] else
                const Text('No configuration available',
                    style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );

  Widget _buildDefaultConfigCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Default Configuration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showDefaultConfigDialog,
                    tooltip: 'Edit Default Config',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_defaultConfig != null) ...<Widget>[
                _buildConfigItem('Enhance Service',
                    _defaultConfig!.enhanceService.toString()),
                _buildConfigItem('Repeat Interval',
                    _defaultConfig!.repeatInterval.toString()),
                _buildConfigItem(
                    'Worker Enabled', _defaultConfig!.workerEnabled.toString()),
                _buildConfigItem('Crash Restart Enabled',
                    _defaultConfig!.crashRestartEnabled.toString()),
                _buildConfigItem('Work On Main Thread',
                    _defaultConfig!.workOnMainThread.toString()),
              ] else
                const Text('No configuration available',
                    style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );

  Widget _buildNotificationConfigCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${Platform.isAndroid ? 'Android' : 'iOS'} Notification Configuration',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showNotificationConfigDialog,
                    tooltip: 'Edit Notification Config',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (Platform.isAndroid) ...<Widget>[
                if (_androidNotificationConfig != null) ...<Widget>[
                  _buildConfigItem('Service ID',
                      _androidNotificationConfig!.serviceId.toString()),
                  _buildConfigItem(
                      'Channel ID', _androidNotificationConfig!.channelId),
                  _buildConfigItem(
                      'Channel Name', _androidNotificationConfig!.channelName),
                  _buildConfigItem('Title', _androidNotificationConfig!.title),
                  _buildConfigItem(
                      'Content', _androidNotificationConfig!.content),
                  _buildConfigItem(
                      'Small Icon', _androidNotificationConfig!.smallIcon),
                  _buildConfigItem(
                      'Large Icon', _androidNotificationConfig!.largeIcon),
                  _buildConfigItem(
                      'Show Low Battery Notification',
                      _androidNotificationConfig!.showLowBatteryNotification
                          .toString()),
                ] else
                  const Text('No configuration available',
                      style: TextStyle(color: Colors.grey)),
              ] else ...<Widget>[
                if (_iosNotificationConfig != null) ...<Widget>[
                  _buildConfigItem(
                      'Show Asset Enable Notification',
                      _iosNotificationConfig!.showAssetEnableNotification
                          .toString()),
                  _buildConfigItem(
                      'Show Asset Disable Notification',
                      _iosNotificationConfig!.showAssetDisableNotification
                          .toString()),
                ] else
                  const Text('No configuration available',
                      style: TextStyle(color: Colors.grey)),
              ],
            ],
          ),
        ),
      );

  Widget _buildUserIdCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'User ID Configuration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showUserIdDialog,
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

  Widget _buildConfigItem(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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

  void _showUserIdDialog() {
    final TextEditingController userIdController =
        TextEditingController(text: _currentUserId ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit User ID'),
        content: TextField(
          controller: userIdController,
          decoration: const InputDecoration(
            labelText: 'User ID',
            hintText: 'Enter user ID',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final BuildContext dialogContext = context;
              try {
                final String userId = userIdController.text.trim();
                if (userId.isNotEmpty) {
                  await AssetTracking().setupUserId(userId: userId);
                  await _loadUserId();
                  if (mounted && dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  showToast('User ID updated successfully');
                } else {
                  showToast('User ID cannot be empty');
                }
              } on Exception catch (e) {
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
    final TextEditingController baseUrlController =
        TextEditingController(text: _dataTrackingConfig?.baseUrl ?? '');
    final TextEditingController storageSizeController = TextEditingController(
        text: _dataTrackingConfig?.dataStorageSize.toString() ?? '5000');
    final TextEditingController batchSizeController = TextEditingController(
        text: _dataTrackingConfig?.dataUploadingBatchSize.toString() ?? '30');
    final TextEditingController batchWindowController = TextEditingController(
        text: _dataTrackingConfig?.dataUploadingBatchWindow.toString() ?? '20');
    bool clearLocalData =
        _dataTrackingConfig?.shouldClearLocalDataWhenCollision ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Data Tracking Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: baseUrlController,
                decoration: const InputDecoration(labelText: 'Base URL'),
              ),
              TextField(
                controller: storageSizeController,
                decoration:
                    const InputDecoration(labelText: 'Data Storage Size'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: batchSizeController,
                decoration: const InputDecoration(
                    labelText: 'Data Uploading Batch Size'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: batchWindowController,
                decoration: const InputDecoration(
                    labelText: 'Data Uploading Batch Window'),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Clear Local Data When Collision'),
                value: clearLocalData,
                onChanged: (bool? value) =>
                    setState(() => clearLocalData = value!),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final BuildContext dialogContext = context;
              try {
                final DataTrackingConfig config = DataTrackingConfig(
                  baseUrl: baseUrlController.text,
                  dataStorageSize:
                      int.tryParse(storageSizeController.text) ?? 5000,
                  dataUploadingBatchSize:
                      int.tryParse(batchSizeController.text) ?? 30,
                  dataUploadingBatchWindow:
                      int.tryParse(batchWindowController.text) ?? 20,
                  shouldClearLocalDataWhenCollision: clearLocalData,
                );
                await AssetTracking().setDataTrackingConfig(config: config);
                await _loadDataTrackingConfig();
                if (mounted && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                showToast('Data tracking config updated successfully');
              } on Exception catch (e) {
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
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Configuration'),
        content: const Text(
            'Location configuration is managed through the main tracking controls.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDefaultConfigDialog() {
    final TextEditingController enhanceServiceController =
        TextEditingController(
            text: _defaultConfig?.enhanceService.toString() ?? 'true');
    final TextEditingController repeatIntervalController =
        TextEditingController(
            text: _defaultConfig?.repeatInterval.toString() ?? '1000');
    final TextEditingController workerEnabledController = TextEditingController(
        text: _defaultConfig?.workerEnabled.toString() ?? 'true');
    final TextEditingController crashRestartEnabledController =
        TextEditingController(
            text: _defaultConfig?.crashRestartEnabled.toString() ?? 'true');
    final TextEditingController workOnMainThreadController =
        TextEditingController(
            text: _defaultConfig?.workOnMainThread.toString() ?? 'false');

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Default Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CheckboxListTile(
                title: const Text('Enhance Service'),
                value: _defaultConfig?.enhanceService ?? true,
                onChanged: (bool? value) =>
                    enhanceServiceController.text = value.toString(),
              ),
              TextField(
                controller: repeatIntervalController,
                decoration: const InputDecoration(labelText: 'Repeat Interval'),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Worker Enabled'),
                value: _defaultConfig?.workerEnabled ?? true,
                onChanged: (bool? value) =>
                    workerEnabledController.text = value.toString(),
              ),
              CheckboxListTile(
                title: const Text('Crash Restart Enabled'),
                value: _defaultConfig?.crashRestartEnabled ?? true,
                onChanged: (bool? value) =>
                    crashRestartEnabledController.text = value.toString(),
              ),
              CheckboxListTile(
                title: const Text('Work On Main Thread'),
                value: _defaultConfig?.workOnMainThread ?? false,
                onChanged: (bool? value) =>
                    workOnMainThreadController.text = value.toString(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final BuildContext dialogContext = context;
              try {
                final DefaultConfig config = DefaultConfig(
                  enhanceService:
                      enhanceServiceController.text.toLowerCase() == 'true',
                  repeatInterval:
                      int.tryParse(repeatIntervalController.text) ?? 1000,
                  workerEnabled:
                      workerEnabledController.text.toLowerCase() == 'true',
                  crashRestartEnabled:
                      crashRestartEnabledController.text.toLowerCase() ==
                          'true',
                  workOnMainThread:
                      workOnMainThreadController.text.toLowerCase() == 'true',
                );
                await AssetTracking().setDefaultConfig(config: config);
                await _loadDefaultConfig();
                if (mounted && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                showToast('Default config updated successfully');
              } on Exception catch (e) {
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
    final TextEditingController serviceIdController = TextEditingController(
        text: _androidNotificationConfig?.serviceId.toString() ?? '1');
    final TextEditingController channelIdController = TextEditingController(
        text: _androidNotificationConfig?.channelId ?? '');
    final TextEditingController channelNameController = TextEditingController(
        text: _androidNotificationConfig?.channelName ?? '');
    final TextEditingController titleController =
        TextEditingController(text: _androidNotificationConfig?.title ?? '');
    final TextEditingController contentController =
        TextEditingController(text: _androidNotificationConfig?.content ?? '');
    final TextEditingController smallIconController = TextEditingController(
        text: _androidNotificationConfig?.smallIcon ?? '');
    final TextEditingController largeIconController = TextEditingController(
        text: _androidNotificationConfig?.largeIcon ?? '');
    bool showLowBatteryNotification =
        _androidNotificationConfig?.showLowBatteryNotification ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Android Notification Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
                onChanged: (bool? value) =>
                    setState(() => showLowBatteryNotification = value!),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final BuildContext dialogContext = context;
              try {
                final AndroidNotificationConfig config =
                    AndroidNotificationConfig(
                  serviceId: int.tryParse(serviceIdController.text) ?? 1,
                  channelId: channelIdController.text,
                  channelName: channelNameController.text,
                  title: titleController.text,
                  content: contentController.text,
                  smallIcon: smallIconController.text,
                  largeIcon: largeIconController.text,
                  showLowBatteryNotification: showLowBatteryNotification,
                );
                await AssetTracking()
                    .setAndroidNotificationConfig(config: config);
                await _loadNotificationConfigs();
                if (mounted && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                showToast('Android notification config updated successfully');
              } on Exception catch (e) {
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
    bool showAssetEnableNotification =
        _iosNotificationConfig?.showAssetEnableNotification ?? true;
    bool showAssetDisableNotification =
        _iosNotificationConfig?.showAssetDisableNotification ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit iOS Notification Config'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckboxListTile(
              title: const Text('Show Asset Enable Notification'),
              value: showAssetEnableNotification,
              onChanged: (bool? value) =>
                  setState(() => showAssetEnableNotification = value!),
            ),
            CheckboxListTile(
              title: const Text('Show Asset Disable Notification'),
              value: showAssetDisableNotification,
              onChanged: (bool? value) =>
                  setState(() => showAssetDisableNotification = value!),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final BuildContext dialogContext = context;
              try {
                final IOSNotificationConfig config = IOSNotificationConfig()
                  ..showAssetEnableNotification = showAssetEnableNotification
                  ..showAssetDisableNotification = showAssetDisableNotification;
                await AssetTracking().setIOSNotificationConfig(config: config);
                await _loadNotificationConfigs();
                if (mounted && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                showToast('iOS notification config updated successfully');
              } on Exception catch (e) {
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
