import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  void fetchUserPredictions() async {
    emit(HistoryLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final snapshot = await FirebaseFirestore.instance
          .collection('disease_detections')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .get();

      final predictions = snapshot.docs.map((doc) => doc.data()).toList();
      emit(HistoryLoaded(predictions));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
