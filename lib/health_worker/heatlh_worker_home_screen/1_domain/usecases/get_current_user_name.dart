import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/repositories/health_worker_home_repository.dart';

class GetCurrentUserName {
  final HealthWorkerHomeRepository repository;

  GetCurrentUserName(this.repository);

  Future<String> call() async {
    return await repository.getCurrentUserName();
  }
}
