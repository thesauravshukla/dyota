import 'dart:async';

/// A class to manage and track various loading states in the product card.
class ProductLoadingState {
  bool mainLoading = true;
  bool nameLoading = false;
  bool descriptionLoading = false;
  bool dynamicFieldsLoading = false;
  bool carouselLoading = false;
  bool moreColoursLoading = false;
  bool recentlyViewedLoading = false;
  bool usersAlsoViewedLoading = false;

  /// The last time an update was made to any loading state
  DateTime? _lastUpdateTime;

  /// The minimum time between updates to debounce rapid changes
  static const _debounceMillis = 100;

  /// Updates the loading state values with the provided parameters.
  /// Only updates values that are explicitly provided.
  void updateWith({
    bool? mainLoading,
    bool? nameLoading,
    bool? descriptionLoading,
    bool? dynamicFieldsLoading,
    bool? carouselLoading,
    bool? moreColoursLoading,
    bool? recentlyViewedLoading,
    bool? usersAlsoViewedLoading,
  }) {
    if (mainLoading != null) this.mainLoading = mainLoading;
    if (nameLoading != null) this.nameLoading = nameLoading;
    if (descriptionLoading != null)
      this.descriptionLoading = descriptionLoading;
    if (dynamicFieldsLoading != null)
      this.dynamicFieldsLoading = dynamicFieldsLoading;
    if (carouselLoading != null) this.carouselLoading = carouselLoading;
    if (moreColoursLoading != null)
      this.moreColoursLoading = moreColoursLoading;
    if (recentlyViewedLoading != null)
      this.recentlyViewedLoading = recentlyViewedLoading;
    if (usersAlsoViewedLoading != null)
      this.usersAlsoViewedLoading = usersAlsoViewedLoading;

    _lastUpdateTime = DateTime.now();
  }

  /// Returns true if any component is in a loading state.
  bool get anyComponentLoading =>
      mainLoading ||
      nameLoading ||
      descriptionLoading ||
      dynamicFieldsLoading ||
      carouselLoading ||
      moreColoursLoading ||
      recentlyViewedLoading ||
      usersAlsoViewedLoading;

  /// Determines if an update should be debounced (skipped) based on the time
  /// since the last update.
  bool shouldDebounceUpdate() {
    if (_lastUpdateTime == null) return false;

    final now = DateTime.now();
    final timeSinceLastUpdate = now.difference(_lastUpdateTime!).inMilliseconds;
    return timeSinceLastUpdate < _debounceMillis;
  }
}
