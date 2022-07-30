class DetailedSearchData {
  // TODO: hogy legyenek a szöveges paraméterek kulcs-érték párjai tárolva?
  const DetailedSearchData({required this.nearbyOnly});

  // TODO: ide biztos ez kell és nem maga a hely egy Geolocation objektumban?
  final bool nearbyOnly;
}