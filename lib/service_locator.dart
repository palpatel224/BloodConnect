//Packages
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Datasources
import 'package:bloodconnect/login/0_data/datasources/auth_datasource.dart';
import 'package:bloodconnect/health_worker/worker_info/0_data/datasources/worker_info_firebase_datasource.dart';
import 'package:bloodconnect/donor_finder/donor_info/0_data/datasources/donor_info_firebase_datasource.dart';
import 'donor_finder/request_screen/0_data/datasources/blood_request_firebase_datasource.dart';
import 'package:bloodconnect/core/services/places_service/places_api_service.dart';
import 'package:bloodconnect/health_worker/manage_request/0_data/datasources/blood_request_remote_data_source.dart';
import 'package:bloodconnect/donor_finder/appointments/0_data/datasources/appointment_datasource.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/0_data/datasources/urgent_request_remote_datasource.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/0_data/datasources/health_questionnaire_datasource.dart';

//Repositories
import 'package:bloodconnect/donor_finder/donor_info/0_data/repositories/donor_info_repository_impl.dart';
import 'package:bloodconnect/core/services/places_service/places_service.dart';
import 'package:bloodconnect/health_worker/worker_info/0_data/repositories/worker_info_repository_impl.dart';
import 'package:bloodconnect/health_worker/worker_info/1_domain/repositories/worker_info_repository.dart';
import 'package:bloodconnect/login/0_data/repository/auth_repo_impl.dart';
import 'package:bloodconnect/login/1_domain/repository/login_repo.dart';
import 'donor_finder/donor_info/1_domain/repositories/donor_info_repository.dart';
import 'donor_finder/request_screen/0_data/repositories/blood_request_repository_impl.dart'
    as donor;
import 'donor_finder/request_screen/1_domain/repositories/blood_request_repository.dart'
    as donor;
import 'package:bloodconnect/health_worker/manage_request/0_data/repositories/blood_request_repository_impl.dart'
    as worker;
import 'package:bloodconnect/health_worker/manage_request/1_domain/repositories/blood_request_repository.dart'
    as worker;
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/get_requests_by_status.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/search_requests.dart'
    as worker_usecase;
import 'package:bloodconnect/donor_finder/appointments/0_data/repositories/appointment_repository_impl.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/repositories/appointment_repository.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/0_data/repositories/appointment_repository_impl.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/repositories/appointment_repository.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/usecases/get_appointments_usecase.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/usecases/get_donation_eligibility_usecase.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/2_application/screens/bloc/donor_finder_home_screen_bloc.dart';
import 'donor_finder/find_donor/1_domain/repositories/blood_request_repository.dart';
import 'donor_finder/find_donor/0_data/repositories/blood_request_repository_impl.dart';
import 'donor_finder/find_donor/2_application/screens/bloc/find_request_bloc.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/0_data/repositories/urgent_request_repository_impl.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/repositories/urgent_request_repository.dart';
import 'package:bloodconnect/donor_finder/donor_finder_home_screen/1_domain/usecases/get_urgent_requests_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/0_data/repositories/health_questionnaire_repository_impl.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/repositories/health_questionnaire_repository.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/get_health_questions_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/evaluate_eligibility_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/save_questionnaire_results_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/check_questionnaire_completion_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/bloc/health_questionnaire_bloc.dart';

//BLoC
import 'package:bloodconnect/health_worker/worker_info/2_application/bloc/health_worker_info_bloc.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/screens/bloc/manage_request_screen_bloc.dart';
import 'package:bloodconnect/login/2_application/screens/bloc/login_screen_bloc.dart';
import 'donor_finder/donor_info/2_application/screens/bloc/donor_info_bloc.dart';
import 'donor_finder/request_screen/2_application/screens/bloc/request_screen_bloc.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/bloc/health_worker_home_bloc.dart';
import 'package:bloodconnect/donor_finder/appointments/2_application/screens/bloc/appointments_bloc.dart';

//Use Cases
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/get_appointments.dart';
import 'donor_finder/request_screen/1_domain/usecases/submit_request_usecase.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/create_appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/delete_appointment.dart';
import 'package:bloodconnect/donor_finder/appointments/1_domain/usecases/update_appointment.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/update_request_status.dart';
import 'package:bloodconnect/health_worker/manage_request/1_domain/usecases/delete_request.dart';

// Health Worker Home Feature
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/0_data/datasources/health_worker_home_remote_data_source.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/0_data/repositories/health_worker_home_repository_impl.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/repositories/health_worker_home_repository.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/usecases/get_pending_requests.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/1_domain/usecases/get_current_user_name.dart';

// Health Worker Donor List Feature
import 'package:bloodconnect/health_worker/donor_list/0_data/datasources/donor_datasource.dart';
import 'package:bloodconnect/health_worker/donor_list/0_data/repositories/donor_repository_impl.dart';
import 'package:bloodconnect/health_worker/donor_list/1_domain/repositories/donor_repository.dart';
import 'package:bloodconnect/health_worker/donor_list/1_domain/usecases/get_donors.dart';
import 'package:bloodconnect/health_worker/donor_list/1_domain/usecases/get_donor_by_id.dart';
import 'package:bloodconnect/health_worker/donor_list/2_application/screens/bloc/donor_list_bloc.dart';

import 'package:bloodconnect/core/services/location_service.dart';
import 'donor_finder/find_donor/0_data/repositories/donor_repository_impl.dart'
    as geo_donor;
import 'donor_finder/find_donor/1_domain/repositories/donor_repository.dart'
    as geo_donor;

import 'package:bloodconnect/health_worker/donation_appointments/0_data/datasources/appointment_datasource.dart';
import 'package:bloodconnect/health_worker/donation_appointments/0_data/repositories/appointment_repository_impl.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/repositories/appointment_repository.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/usecases/get_all_appointments_usecase.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_bloc.dart';
import 'package:bloodconnect/health_worker/donation_appointments/1_domain/usecases/search_appointments_by_location_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(),
  );
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => http.Client());

  // Data Sources
  sl.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImpl(googleSignIn: sl<GoogleSignIn>()),
  );
  sl.registerLazySingleton<DonorInfoDataSource>(
    () => FirebaseDonorInfoDataSource(
      firestore: sl(),
      auth: sl(),
    ),
  );
  // Register centralized Places API service
  sl.registerLazySingleton<PlacesApiService>(
    () => PlacesApiService(
      client: sl<http.Client>(),
    ),
  );
  // Register HealthWorker datasource
  sl.registerLazySingleton<WorkerInfoFirebaseDatasource>(
    () => WorkerInfoFirebaseDatasourceImpl(
      firestore: sl(),
      auth: sl(),
    ),
  );
  // Register the implementation directly as well
  sl.registerLazySingleton<WorkerInfoFirebaseDatasourceImpl>(
    () => WorkerInfoFirebaseDatasourceImpl(
      firestore: sl(),
      auth: sl(),
    ),
  );
  // Register BloodRequest data source
  sl.registerLazySingleton<BloodRequestDataSource>(
    () => BloodRequestFirebaseDataSource(firestore: sl()),
  );

  // Register ManageRequest data source
  sl.registerLazySingleton<BloodRequestRemoteDataSource>(
    () => BloodRequestRemoteDataSourceImpl(firestore: sl()),
  );

  // Appointment Feature
  sl.registerLazySingleton<AppointmentDataSource>(
    () => FirebaseAppointmentDataSource(sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sl<AppointmentDataSource>()),
  );

  sl.registerLazySingleton(
    () => CreateAppointment(sl<AppointmentRepository>()),
  );

  sl.registerLazySingleton(
    () => GetAppointmentsByUserId(sl<AppointmentRepository>()),
  );

  sl.registerLazySingleton(
    () => DeleteAppointment(sl<AppointmentRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateAppointment(sl<AppointmentRepository>()),
  );

  sl.registerFactory(
    () => AppointmentsBloc(
      createAppointmentUseCase: sl<CreateAppointment>(),
      getAppointmentsByUserIdUseCase: sl<GetAppointmentsByUserId>(),
      deleteAppointmentUseCase: sl<DeleteAppointment>(),
      updateAppointmentUseCase: sl<UpdateAppointment>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

  // Register Urgent Request data source
  sl.registerLazySingleton<UrgentRequestRemoteDataSource>(
    () => UrgentRequestRemoteDataSourceImpl(firestore: sl()),
  );

  // Register Urgent Request repository
  sl.registerLazySingleton<UrgentRequestRepository>(
    () => UrgentRequestRepositoryImpl(remoteDataSource: sl()),
  );

  // Register Urgent Request use case
  sl.registerLazySingleton(
    () => GetUrgentRequestsUseCase(sl<UrgentRequestRepository>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(firebaseService: sl<AuthFirebaseService>()),
  );
  sl.registerLazySingleton<DonorInfoRepository>(
    () => DonorInfoRepositoryImpl(sl()),
  );

  // Register HealthWorker repository
  sl.registerLazySingleton<WorkerInfoRepository>(
    () => WorkerInfoRepositoryImpl(sl()),
  );
  // Register BloodRequest repository for donor
  sl.registerLazySingleton<donor.BloodRequestRepository>(
    () => donor.BloodRequestRepositoryImpl(sl()),
  );

  // Register BloodRequest repository for health worker
  sl.registerLazySingleton<worker.BloodRequestRepository>(
    () => worker.BloodRequestRepositoryImpl(remoteDataSource: sl()),
  );

  // Register BloodRequest repository for find donor screen
  sl.registerLazySingleton<BloodRequestRepository>(
    () => BloodRequestRepositoryImpl(firestore: sl()),
  );

  // Health Questionnaire Feature
  sl.registerLazySingleton<HealthQuestionnaireDataSource>(
    () => HealthQuestionnaireDataSourceImpl(sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<HealthQuestionnaireRepository>(
    () =>
        HealthQuestionnaireRepositoryImpl(sl<HealthQuestionnaireDataSource>()),
  );

  sl.registerLazySingleton(
    () => GetHealthQuestionsUseCase(sl<HealthQuestionnaireRepository>()),
  );

  sl.registerLazySingleton(
    () => EvaluateEligibilityUseCase(sl<HealthQuestionnaireRepository>()),
  );

  sl.registerLazySingleton(
    () => SaveQuestionnaireResultsUseCase(sl<HealthQuestionnaireRepository>()),
  );

  sl.registerLazySingleton(
    () => CheckQuestionnaireCompletionUseCase(
        sl<HealthQuestionnaireRepository>()),
  );

  sl.registerFactory(
    () => HealthQuestionnaireBloc(
      getHealthQuestionsUseCase: sl<GetHealthQuestionsUseCase>(),
      evaluateEligibilityUseCase: sl<EvaluateEligibilityUseCase>(),
      saveQuestionnaireResultsUseCase: sl<SaveQuestionnaireResultsUseCase>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => SubmitRequestUseCase(sl()),
  );

  // Register ManageRequest use cases
  sl.registerLazySingleton<GetRequestsByStatus>(
    () => GetRequestsByStatus(sl<worker.BloodRequestRepository>()),
  );
  sl.registerLazySingleton<worker_usecase.SearchRequests>(
    () => worker_usecase.SearchRequests(sl<worker.BloodRequestRepository>()),
  );
  sl.registerLazySingleton<UpdateRequestStatus>(
    () => UpdateRequestStatus(sl<worker.BloodRequestRepository>()),
  );
  sl.registerLazySingleton<DeleteRequest>(
    () => DeleteRequest(sl<worker.BloodRequestRepository>()),
  );

  // BLoCs
  sl.registerFactory(
    () => LoginScreenBloc(
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerFactory(
    () => DonorInfoBloc(
      donorInfoRepository: sl<DonorInfoRepository>(),
      auth: sl<FirebaseAuth>(),
      placesService: sl<PlacesApiService>(),
    ),
  );

  // Register HealthWorkerInfo bloc
  sl.registerFactory(
    () => HealthWorkerInfoBloc(
      repository: sl<WorkerInfoRepository>(),
      auth: sl<FirebaseAuth>(),
      placesService: sl<PlacesApiService>(),
    ),
  );
  // Register RequestScreen bloc
  sl.registerFactory(
    () => RequestScreenBloc(
      submitRequestUseCase: sl(),
    ),
  );

  // Register ManageRequestScreen bloc
  sl.registerFactory(
    () => ManageRequestScreenBloc(
      getRequestsByStatus: sl(),
      searchRequests: sl<worker_usecase.SearchRequests>(),
      updateRequestStatus: sl<UpdateRequestStatus>(),
      deleteRequest: sl<DeleteRequest>(),
    ),
  );

  // Register FindRequest bloc
  sl.registerFactory(
    () => FindRequestBloc(
      requestRepository: sl<BloodRequestRepository>(),
    ),
  );

  // Health Worker Home Feature
  sl.registerLazySingleton<HealthWorkerHomeRemoteDataSource>(
    () => HealthWorkerHomeRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  sl.registerLazySingleton<HealthWorkerHomeRepository>(
    () => HealthWorkerHomeRepositoryImpl(
      remoteDataSource: sl<HealthWorkerHomeRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetPendingRequests>(
    () => GetPendingRequests(sl<HealthWorkerHomeRepository>()),
  );

  sl.registerLazySingleton<GetCurrentUserName>(
    () => GetCurrentUserName(sl<HealthWorkerHomeRepository>()),
  );

  sl.registerFactory<HealthWorkerHomeBloc>(
    () => HealthWorkerHomeBloc(
      getPendingRequests: sl<GetPendingRequests>(),
      getCurrentUserName: sl<GetCurrentUserName>(),
    ),
  );

  // Donor Finder Home Feature
  sl.registerLazySingleton<HomeScreenAppointmentRepository>(
    () => HomeScreenAppointmentRepositoryImpl(),
  );

  sl.registerLazySingleton(
    () =>
        GetHomeScreenAppointmentsUseCase(sl<HomeScreenAppointmentRepository>()),
  );

  sl.registerLazySingleton(
    () => GetHomeScreenDonationEligibilityUseCase(
        sl<HomeScreenAppointmentRepository>()),
  );

  sl.registerFactory(
    () => DonorFinderHomeScreenBloc(
      appointmentsUseCase: sl<GetHomeScreenAppointmentsUseCase>(),
      eligibilityUseCase: sl<GetHomeScreenDonationEligibilityUseCase>(),
      urgentRequestsUseCase: sl<GetUrgentRequestsUseCase>(),
    ),
  );

  // Register Donor List Feature
  sl.registerLazySingleton<DonorDataSource>(
    () => FirebaseDonorDataSource(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<DonorRepository>(
    () => DonorRepositoryImpl(sl<DonorDataSource>()),
  );

  sl.registerLazySingleton(
    () => GetDonors(sl<DonorRepository>()),
  );

  sl.registerLazySingleton(
    () => GetDonorById(sl<DonorRepository>()),
  );

  sl.registerFactory(
    () => DonorListBloc(getDonors: sl<GetDonors>()),
  );

  // Register LocationService
  sl.registerLazySingleton<LocationService>(
    () => LocationService(placesService: sl<PlacesApiService>()),
  );

  // Register Donor Repository for geoqueries
  sl.registerLazySingleton<geo_donor.DonorRepository>(
    () => geo_donor.DonorRepositoryImpl(firestore: sl()),
  );

  // Health Worker Appointment Feature
  sl.registerLazySingleton<HealthWorkerAppointmentDataSource>(
    () => FirebaseHealthWorkerAppointmentDataSource(sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<HealthWorkerAppointmentRepository>(
    () => HealthWorkerAppointmentRepositoryImpl(
      sl<HealthWorkerAppointmentDataSource>(),
      locationService: sl<LocationService>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetAllAppointmentsUseCase(sl<HealthWorkerAppointmentRepository>()),
  );

  sl.registerLazySingleton(
    () => SearchAppointmentsByLocationUseCase(
        sl<HealthWorkerAppointmentRepository>()),
  );

  sl.registerFactory(
    () => AppointmentListBloc(
      getAllAppointmentsUseCase: sl<GetAllAppointmentsUseCase>(),
      searchAppointmentsByLocationUseCase:
          sl<SearchAppointmentsByLocationUseCase>(),
    ),
  );
}
