import 'package:evetick/features/following_organizers/data/following_repository.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_cubit.dart';
import 'package:evetick/features/organizer_profile/data/organizer_profile_repository.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_cubit.dart';
import 'package:evetick/core/services/push_notifications/push_notifications_service.dart';
import 'package:evetick/core/services/push_notifications/push_tokens_repository.dart';
import 'package:evetick/features/notifications/data/notifications_repository.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_cubit.dart';
import 'package:evetick/features/organizer_reviews/data/organizer_reviews_repository.dart';
import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:evetick/features/organizer_reviews/logic/write_organizer_review_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/auth/logic/delete_account_cubit/delete_account_cubit.dart';
import 'package:evetick/features/auth/logic/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:evetick/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_cubit.dart';
import 'package:evetick/features/event_details/data/event_details_repository.dart';
import 'package:evetick/features/event_details/logic/event_details_cubit.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/event_booking_data_source_impl.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/payment/payment_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/favorites/data/favorites_repository.dart';
import 'package:evetick/features/favorites/logic/favorites_cubit.dart';
import 'package:evetick/features/localization/data/locale_repository.dart';
import 'package:evetick/features/localization/logic/locale_cubit.dart';
import 'package:evetick/core/theming/data/theme_repository.dart';
import 'package:evetick/core/theming/logic/theme_cubit.dart';
import 'package:evetick/features/location/logic/cubit/location_cubit.dart';
import 'package:evetick/features/location/data/repos/location_repository.dart';
import 'package:evetick/features/location/data/repos/location_repository_impl.dart';
import 'package:evetick/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:evetick/features/home/data/data_sources/home_data_source_impl.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:evetick/features/home/logic/home_cubit.dart';
import 'package:evetick/features/my_tickets/data/my_tickets_repository.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/profile/data/profile_repository.dart';
import 'package:evetick/features/search/data/search_history_repository.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/profile/logic/profile_cubit.dart';
import 'package:evetick/features/help_support/data/support_repository.dart';
import 'package:evetick/features/help_support/logic/help_cubit.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/terms/data/terms_repository.dart';
import 'package:evetick/features/terms/logic/terms_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepository>()));

  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory<DeleteAccountCubit>(
    () => DeleteAccountCubit(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(),
  );

  getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(getIt<OnboardingRepository>()),
  );
  
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );
  getIt.registerFactory<LocationCubit>(
    () => LocationCubit(locationRepository: getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<TermsRepository>(() => TermsRepository());
  getIt.registerFactory<TermsCubit>(
    () => TermsCubit(getIt<TermsRepository>(), getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ReviewsRepository>(() => ReviewsRepository());
  getIt.registerFactory<ReviewsCubit>(
    () => ReviewsCubit(getIt<ReviewsRepository>()),
  );
  getIt.registerFactory<WriteReviewCubit>(
    () => WriteReviewCubit(getIt<ReviewsRepository>()),
  );

  getIt.registerLazySingleton<OrganizerReviewsRepository>(
    () => OrganizerReviewsRepository(),
  );
  getIt.registerFactory<OrganizerReviewsCubit>(
    () => OrganizerReviewsCubit(getIt<OrganizerReviewsRepository>()),
  );
  getIt.registerFactory<WriteOrganizerReviewCubit>(
    () => WriteOrganizerReviewCubit(
      getIt<ReviewsRepository>(),
      getIt<OrganizerReviewsRepository>(),
    ),
  );

  getIt.registerLazySingleton<PushTokensRepository>(
    () => PushTokensRepository(),
  );
  getIt.registerLazySingleton<PushNotificationsService>(
    () => PushNotificationsService(getIt<PushTokensRepository>()),
  );

  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepository(),
  );
  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(getIt<NotificationsRepository>()),
  );

  getIt.registerLazySingleton<SupportRepository>(() => SupportRepository());
  getIt.registerFactory<HelpCubit>(() => HelpCubit());
  getIt.registerFactory<SendMessageCubit>(
    () => SendMessageCubit(getIt<SupportRepository>()),
  );

  getIt.registerLazySingleton(() => LocaleRepository());

  getIt.registerLazySingleton(() => LocaleCubit(getIt()));

  getIt.registerLazySingleton(() => ThemeRepository());
  getIt.registerLazySingleton(() => ThemeCubit(getIt()));

  getIt.registerLazySingleton<EventDetailsRepository>(
    () => EventDetailsRepository(),
  );
  getIt.registerFactory<EventDetailsCubit>(
    () => EventDetailsCubit(getIt<EventDetailsRepository>(), getIt<HomeRepo>()),
  );

  getIt.registerLazySingleton<EventBookingDataSourceImpl>(() => EventBookingDataSourceImpl());
  getIt.registerLazySingleton<EventBookingRepo>(() => EventBookingRepo(getIt<EventBookingDataSourceImpl>()));
  getIt.registerFactory<SelectChairCubit>(() => SelectChairCubit(getIt<EventBookingRepo>()));
  getIt.registerFactory<SelectTicketsCubit>(() => SelectTicketsCubit(getIt<EventBookingRepo>()));
  getIt.registerFactory<CheckoutCubit>(() => CheckoutCubit(getIt<EventBookingRepo>()));
  getIt.registerFactory<PaymentCubit>(() => PaymentCubit(getIt<EventBookingRepo>()));
  getIt.registerFactory<TicketCubit>(() => TicketCubit(getIt<EventBookingRepo>()));

  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(HomeDataSourceImpl()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));

  getIt.registerLazySingleton<MyTicketsRepository>(() => MyTicketsRepository());
  getIt.registerFactory<MyTicketsCubit>(
    () => MyTicketsCubit(getIt<MyTicketsRepository>()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(getIt<FavoritesRepository>(), getIt<HomeRepo>()),
  );

  getIt.registerLazySingleton<FollowingRepository>(() => FollowingRepository());
  getIt.registerFactory<FollowingOrganizersCubit>(
    () => FollowingOrganizersCubit(getIt<FollowingRepository>()),
  );

  getIt.registerLazySingleton<OrganizerProfileRepository>(
    () => OrganizerProfileRepository(),
  );
  getIt.registerFactory<OrganizerProfileCubit>(
    () => OrganizerProfileCubit(
      getIt<OrganizerProfileRepository>(),
      getIt<FollowingRepository>(),
    ),
  );

  getIt.registerLazySingleton<SearchHistoryRepository>(
    () => SearchHistoryRepository(),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<HomeRepo>(), getIt<SearchHistoryRepository>()),
  );
}
