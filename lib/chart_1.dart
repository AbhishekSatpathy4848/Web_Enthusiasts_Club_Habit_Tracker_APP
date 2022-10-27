import 'dart:collection' show LinkedHashMap;
// import '../bar/bar_renderer.dart' show BarRenderer;
// import '../cartesian/axis/axis.dart' show NumericAxis;
// import '../cartesian/cartesian_chart.dart' show OrdinalCartesianChart;
// import '../common/series_renderer.dart' show SeriesRenderer;
// import 'package:layout/layout_config.dart' show LayoutConfig;
import 'package:charts_flutter/flutter.dart';

class BarChart extends OrdinalCartesianChart {
  BarChart(
      {bool? vertical,
      LayoutConfig? layoutConfig,
      NumericAxis? primaryMeasureAxis,
      NumericAxis? secondaryMeasureAxis,
      LinkedHashMap<String, NumericAxis>? disjointMeasureAxes})
      : super(
            vertical: vertical,
            // layoutConfig: layoutConfig,
            primaryMeasureAxis: primaryMeasureAxis,
            secondaryMeasureAxis: secondaryMeasureAxis,
            disjointMeasureAxes: disjointMeasureAxes);

  @override
  SeriesRenderer<String> makeDefaultRenderer() {
    return BarRenderer<String>()..rendererId = SeriesRenderer.defaultRendererId;
  }
}