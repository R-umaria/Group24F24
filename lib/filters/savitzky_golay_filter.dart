import 'package:scidart/numdart.dart';
import 'package:savgol/savgol.dart';

class SavitzkyGolayFilter {
  final int windowSize;
  final int polynomialOrder;

  SavitzkyGolayFilter({required this.windowSize, required this.polynomialOrder});

  /// Applies the Savitzky-Golay filter to smooth the input data
  List<double> apply(List<double> data) {
    if (data.length < windowSize) return data;

    // Convert List<double> to scidart Array
    Array inputData = Array(data);

    // Apply the Savitzky-Golay filter using scidart's method
    Array smoothedData = savitzkyGolay(
      inputData,
      windowSize: windowSize,
      polynomialOrder: polynomialOrder,
    );

    return smoothedData.toList();
  }
}
