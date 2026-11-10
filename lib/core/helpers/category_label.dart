import 'package:evetick/l10n/app_localizations.dart';

extension CategoryLabel on AppLocalizations {
  String categoryLabel(String category) {
    switch (category.trim().toLowerCase()) {
      case 'concert':
      case 'concerts':
        return homeFiltersConcerts;
      case 'cinema':
        return homeFiltersCinema;
      case 'trip':
      case 'trips':
        return homeFiltersTrips;
      case 'sport':
      case 'sports':
        return homeFiltersSports;
      case 'workshop':
      case 'workshops':
        return homeFiltersWorkshops;
      case 'nightlife':
        return homeFiltersNightlife;
      case 'free events':
        return homeFiltersFreeEvents;
      case 'music':
        return favoritesCategoryMusic;
      default:
        return category;
    }
  }
}
