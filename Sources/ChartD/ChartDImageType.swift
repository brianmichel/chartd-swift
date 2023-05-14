import Foundation

/// The image type of the resulting chart.
enum ChartDImageType {
    /// When used, a png of the chart will be built.
    case png
    /// When used, an svg of the chart will be built.
    case svg

    /// The file name as a string for the chart.
    var fileName: String {
        switch self {
        case .png:
            return "a.png"
        case .svg:
            return "a.svg"
        }
    }
}
