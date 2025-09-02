import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/screen/trip_storege.dart';
import 'package:nb_asset_tracking_flutter_example/screen/trip_summary_screen.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  TripHistoryScreenState createState() => TripHistoryScreenState();
}

class TripHistoryScreenState extends State<TripHistoryScreen> {
  List<String>? tripHistory;

  @override
  void initState() {
    super.initState();
    _loadTripHistory();
  }

  Future<void> _loadTripHistory() async {
    final history = await getHistoryList();
    setState(() {
      tripHistory = history;
    });
  }

  Future<void> _deleteTrip(String tripId) async {
    try {
      final result = await AssetTracking().deleteTrip(tripId: tripId);
      if (result.success) {
        // Remove from local storage
        await removeFromHistory(tripId);
        // Reload the list
        await _loadTripHistory();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip deleted successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete trip: ${result.msg}')),
          );
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting trip: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
      ),
      body: tripHistory == null || tripHistory!.isEmpty
          ? const Center(
              child: Text('No ended trip'),
            )
          : ListView.separated(
              itemCount: tripHistory?.length ?? 0,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                final tripId = tripHistory![index];
                return Dismissible(
                  key: Key(tripId),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async => showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Trip'),
                          content: Text(
                              'Are you sure you want to delete trip "$tripId"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                    ),
                  onDismissed: (direction) {
                    _deleteTrip(tripId);
                  },
                  child: ListTile(
                    title: Text(tripId),
                    subtitle: const Text('Tap to view trip summary'),
                    leading: const Icon(Icons.history),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TripSummaryScreen(tripId: tripId),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
}
