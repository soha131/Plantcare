import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'model/history_cubit.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchUserPredictions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff144937)),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: const Text('History',
    style: TextStyle(color: Color(0xff144937), fontSize: 24)),
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            final predictions = state.predictions;

            if (predictions.isEmpty) {
              return const Center(child: Text("No history found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final prediction = predictions[index];
                final timestamp = prediction['timestamp'] as Timestamp?;
                final formattedDate = timestamp != null
                    ? DateFormat('dd MMM yyyy - hh:mm a').format(timestamp.toDate())
                    : 'Unknown Date';
                final imageUrl = prediction['image_path']; // or image_path if stored locally

                return Card(
                  color: Colors.green[50],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading:  imageUrl != null && imageUrl.toString().isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
                    )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      prediction['disease_class'] ?? 'Unknown Disease',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prediction['recommendation'] ?? 'No recommendation'),
                        const SizedBox(height: 4),
                        Text(formattedDate,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is HistoryError) {
            return Center(child: Text("Error: ${state.error}"));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
