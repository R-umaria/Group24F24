class MovingAverageFilter {
  final int windowSize;
  final List<double> _window = [];

  MovingAverageFilter({required this.windowSize});

  /// Applies the Moving Average filter to smooth the input data
  double apply(double newValue) {
    // Add the new value to the window
    _window.add(newValue);

    // Remove the oldest value if the window exceeds the specified size
    if (_window.length > windowSize) {
      _window.removeAt(0);
    }

    // Calculate the average of the window
    double sum = 0.0;
    for (var value in _window) {
      sum += value;
    }
    return sum / _window.length;
  }
}
