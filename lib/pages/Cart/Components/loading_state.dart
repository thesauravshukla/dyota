/// Manages loading states for various components in the application.
/// Provides methods to handle debouncing and skip redundant updates.
class LoadingState {
  bool isItemCardsLoading = false;
  bool isTotalAmountLoading = false;
  bool isInitialDataLoading = true;
  DateTime _lastUpdateTime = DateTime.now();

  /// Returns true if any component is in loading state
  bool get anyComponentLoading =>
      isItemCardsLoading || isTotalAmountLoading || isInitialDataLoading;

  /// Resets all loading state flags to false
  void resetAllLoadingStates() {
    isItemCardsLoading = false;
    isTotalAmountLoading = false;
    isInitialDataLoading = false;
  }

  /// Determines if a loading state update should be skipped because it doesn't change state
  bool shouldSkipRedundantUpdate({
    bool? itemCardsLoading,
    bool? totalAmountLoading,
  }) {
    return (itemCardsLoading != null &&
            itemCardsLoading == isItemCardsLoading) &&
        (totalAmountLoading != null &&
            totalAmountLoading == isTotalAmountLoading);
  }

  /// Prevents too frequent updates by implementing simple debounce
  bool shouldDebounceUpdate() {
    final now = DateTime.now();
    if (now.difference(_lastUpdateTime).inMilliseconds < 300) {
      return true; // Skip frequent updates
    }
    _lastUpdateTime = now;
    return false;
  }
}
