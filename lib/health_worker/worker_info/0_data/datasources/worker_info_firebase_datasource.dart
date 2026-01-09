import 'package:bloodconnect/health_worker/worker_info/0_data/models/worker_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


abstract class WorkerInfoFirebaseDatasource {
  Future<void> saveWorkerInfo(WorkerInfoModel donorInfo);
  Future<WorkerInfoModel> getWorkerInfo(String userId);
  Future<void> updateWorkerInfo(WorkerInfoModel donorInfo);
  Future<void> deleteWorkerInfo(String userId);
}

class WorkerInfoFirebaseDatasourceImpl implements WorkerInfoFirebaseDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WorkerInfoFirebaseDatasourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<void> saveWorkerInfo(WorkerInfoModel workerInfo) async {
    await _firestore
        .collection('Health_Worker')
        .doc(workerInfo.id)
        .set(workerInfo.toJson());
  }

  @override
  Future<WorkerInfoModel> getWorkerInfo(String userId) async {
    final docSnapshot = await _firestore.collection('Users').doc(userId).get();

    if (!docSnapshot.exists) {
      throw Exception('User information not found');
    }

    final data = docSnapshot.data() as Map<String, dynamic>;
    return WorkerInfoModel.fromJson(data);
  }

  @override
  Future<void> updateWorkerInfo(WorkerInfoModel workerInfo) async {
    await _firestore
        .collection('Users')
        .doc(workerInfo.id)
        .update(workerInfo.toJson());
  }

  @override
  Future<void> deleteWorkerInfo(String userId) async {
    await _firestore.collection('Users').doc(userId).delete();
  }

  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }
}
