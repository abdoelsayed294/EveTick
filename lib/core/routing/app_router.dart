import 'package:evetick/core/di/dependency_injection.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/app_start/logic/cubit/app_start_cubit.dart';
import 'package:evetick/features/app_start/presentation/app_start.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_cubit.dart';
import 'package:evetick/features/auth/ui/screens/login_screen.dart';
import 'package:evetick/features/auth/ui/screens/signup_screen.dart';
import 'package:evetick/features/auth/ui/screens/verification_screen.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_details/logic/event_details_cubit.dart';
import 'package:evetick/features/event_details/ui/screens/event_details_screen.dart';
import 'package:evetick/features/favorites/logic/favorites_cubit.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_cubit.dart';
import 'package:evetick/features/following_organizers/ui/screens/following_organizers_screen.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_cubit.dart';
import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:evetick/features/organizer_reviews/logic/write_organizer_review_cubit.dart';
import 'package:evetick/features/organizer_reviews/ui/screens/write_organizer_review_screen.dart';
import 'package:evetick/features/organizer_profile/ui/screens/organizer_profile_screen.dart';
import 'package:evetick/features/home/logic/home_cubit.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/ui/screens/search_screen.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:evetick/features/event_booking/ui/screens/booking_flow_screen.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_cubit.dart';
import 'package:evetick/features/event_booking/ui/screens/confirmation_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/ticket_screen.dart';
import 'package:evetick/features/location/data/repos/location_repository.dart';
import 'package:evetick/features/location/logic/cubit/location_cubit.dart';
import 'package:evetick/features/location/presentation/screens/map_picker_screen.dart';
import 'package:evetick/main_container.dart';
import 'package:evetick/features/location/presentation/screens/set_location.dart';
import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:evetick/features/onboarding/presentation/ui/onboarding_screen.dart';
import 'package:evetick/features/onboarding/presentation/ui/welcome_screen.dart';
import 'package:evetick/features/profile/logic/profile_cubit.dart';
import 'package:evetick/features/reviews/data/models/reviews_args_model.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/reviews/ui/screens/reviews_screen.dart';
import 'package:evetick/features/reviews/ui/screens/write_review_screen.dart';
import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/logic/help_cubit.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/help_support/ui/screens/help_support_screen.dart';
import 'package:evetick/features/help_support/ui/screens/send_us_screen.dart';
import 'package:evetick/features/terms/data/models/terms_mode.dart';
import 'package:evetick/features/terms/logic/terms_cubit.dart';
import 'package:evetick/features/terms/ui/screens/terms_screen.dart';
import 'package:evetick/features/profile/ui/screens/edit_profile_screen.dart';
import 'package:evetick/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this (arguments as ClassName)
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<OnboardingCubit>(),
            child: const OnboardingScreen(),
          ),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SignupCubit>(),
            child: const SignupScreen(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<ProfileCubit>()..getUserData(),
              ),
              BlocProvider(create: (context) => getIt<LoginCubit>()),
              BlocProvider(create: (context) => getIt<HomeCubit>()..load()),
              BlocProvider(
                create: (context) => getIt<FavoritesCubit>()..load(),
              ),
              BlocProvider(
                create: (context) => getIt<MyTicketsCubit>()..load(),
              ),
            ],
            child: const MainContainer(),
          ),
        );

      case Routes.searchScreen:
        // true = open with the filter panel (home filter button).
        final openFilters = arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<SearchCubit>()..load(openFilters: openFilters),
            child: SearchScreen(openFilters: openFilters),
          ),
        );

      case Routes.eventDetailsScreen:
        // The event id comes from the home screen (Navigator arguments).
        final eventId = arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                getIt<EventDetailsCubit>()..getEventDetails(eventId),
            child: EventDetailsScreen(
              eventId: eventId,
              onBook: () => Navigator.of(context)
                  .pushNamed(Routes.bookingFlowScreen, arguments: eventId),
            ),
          ),
        );

      case Routes.organizerProfileScreen:
        // The organizer's uid comes from the event page / following list.
        final organizerId = arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<OrganizerProfileCubit>()..load(organizerId),
              ),
              // Loaded the first time the Reviews tab is opened.
              BlocProvider(create: (context) => getIt<OrganizerReviewsCubit>()),
            ],
            child: const OrganizerProfileScreen(),
          ),
        );

      case Routes.followingOrganizersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<FollowingOrganizersCubit>()..load(),
            child: const FollowingOrganizersScreen(),
          ),
        );

      case Routes.bookingFlowScreen:
        // The event id comes from the home screen (Navigator arguments).
        final eventId = arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<SelectChairCubit>()..getSeatingConfig(eventId),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<SelectTicketsCubit>()..getTicketTier(eventId),
              ),
              BlocProvider(
                create: (context) => getIt<CheckoutCubit>()..getEvent(eventId),
              ),
            ],
            child: BookingFlowScreen(),
          ),
        );

      case Routes.confirmationScreen:
        return MaterialPageRoute(
          builder: (_) =>
              ConfirmationScreen(args: arguments as ConfirmationArgs),
        );

      case Routes.ticketScreen:
        final orderId = arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<TicketCubit>()..getOrder(orderId),
            child: const TicketScreen(),
          ),
        );

      case Routes.verificationScreen:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case Routes.appStartScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AppStartCubit>(
            create: (context) => AppStartCubit(
              authRepository: getIt<AuthRepository>(),
              onboardingRepository: getIt<OnboardingRepository>(),
              locationRepository: getIt<LocationRepository>(),
            )..checkAppStart(),
            child: const AppStartScreen(),
          ),
        );
      case Routes.setLocationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                LocationCubit(locationRepository: getIt<LocationRepository>()),
            child: SetLocation(),
          ),
        );
      case Routes.welcomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const WelcomeScreen(),
          ),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<ProfileCubit>()..getUserData(),
              ),
              BlocProvider(create: (context) => getIt<LoginCubit>()),
            ],
            child: const ProfileScreen(),
          ),
        );
      case Routes.mapPickerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LocationCubit>(),
            child: MapPickerScreen(),
          ),
        );
      case Routes.editProfileScreen:
        final profileCubit = arguments as ProfileCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: profileCubit,
            child: EditProfileScreen(),
          ),
        );
      case Routes.reviewsScreen:
        final reviewsArgs = arguments as ReviewsArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewsCubit>()
              ..emitReviewsStates(eventId: reviewsArgs.eventId),
            child: ReviewsScreen(args: reviewsArgs),
          ),
        );
      case Routes.writeReviewScreen:
        // The event id comes from the reviews screen (Navigator arguments).
        final reviewEventId = arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<WriteReviewCubit>(),
            child: WriteReviewScreen(eventId: reviewEventId),
          ),
        );
      case Routes.writeOrganizerReviewScreen:
        // The organizer's uid comes from the organizer page (Reviews tab).
        final reviewedOrganizerId = arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<WriteReviewCubit>(
            // Provided as WriteReviewCubit so the shared review widgets
            // (stars, text field, anonymous switch) work unchanged.
            create: (context) => getIt<WriteOrganizerReviewCubit>(),
            child: WriteOrganizerReviewScreen(organizerId: reviewedOrganizerId),
          ),
        );
      case Routes.helpSupportScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<HelpCubit>(),
            child: const HelpSupportScreen(),
          ),
        );
      case Routes.sendUsScreen:
        final category = arguments as HelpCategory?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<SendMessageCubit>()..selectCategory(category),
            child: const SendUsScreen(),
          ),
        );
      case Routes.termsScreen:
        final mode = arguments as TermsMode? ?? TermsMode.profile;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = getIt<TermsCubit>();
              if (mode == TermsMode.profile) cubit.loadAcceptance();
              return cubit;
            },
            child: TermsScreen(mode: mode),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
