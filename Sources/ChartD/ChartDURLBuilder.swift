import Foundation

struct ChartDDataset {
    /// A base62 encoded string representing the data in this series.
    /// Use the functions found in ``Collection+Base62`` to generate these values.
    let data: String
    /// An optional encoded string representing the stroke color.
    let stroke: String? = nil
    /// An optional encoded string representing the fill color.
    let fill: String? = nil
}

enum ChartDURLBuilderError: Error {
    /// An error indicating more than 5 datasets have been passed to the builder.
    case tooManyDatasets
}

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

/// A class that allows you to contruct a ChartD chart using a builder pattern.
///
/// In order to produce a chart URL, you must include the following values:
/// - height
/// - width
/// - at least one dataset, but no more than 5.
///
/// Example:
/// ```swift
/// let url = try ChartDURLBuilder()
///     .height(200)
///     .width(400)
///     .datasets([
///         .init(data: "98851"), // pass in a pre-encoded string for your data
///         .init(data: [0.1, 0.0, 0.8, 0.9].base62encode(minimum: 0.0, maximum: 1.0)) // or, encode the data on the fly.
///     ])
///     .url()
/// ```
final class ChartDURLBuilder {
    private var width: Int?
    private var height: Int?
    private var datasets = [ChartDDataset]()
    private var ymin: Double?
    private var ymax: Double?
    private var xmin: TimeInterval?
    private var xmax: TimeInterval?
    private var tz: String?
    private var t: String?
    private var step: Bool?
    private var hl: Bool?
    private var ol: Bool?
    private var or: Bool?

    /// Sets the width of the chart.
    /// - parameter width: The desired width of the chart.
    @discardableResult
    func width(_ width: Int) -> Self {
        self.width = width
        return self
    }

    /// Sets the height of the chart.
    /// - parameter height: The desired height of the chart.
    @discardableResult
    func height(_ height: Int) -> Self {
        self.height = height
        return self
    }

    /// Sets datasets to include in the chart.
    /// - parameter datasets: The datasets that should be plotted on the chart.
    /// - throws: Throws a ``ChartDURLBuilderError.tooManyDatasets`` error if more than 5 datasets are passed.
    @discardableResult
    func datasets(_ datasets: [ChartDDataset]) throws -> Self {
        guard datasets.count <= 5 else {
            throw ChartDURLBuilderError.tooManyDatasets
        }
        self.datasets = datasets
        return self
    }

    /// Sets the minimum value of the y axis for the chart.
    /// - parameter yMinimum: The minimum value for the chart on the y axis. This is used to set the scale of the graph and how the points will be drawn. This is used in conjunction with the y maximum to figure out how to plot the points on the chart.
    @discardableResult
    func yMinimum(_ yMinimum: Double) -> Self {
        ymin = yMinimum
        return self
    }

    /// Sets the maximum value of the y axis for the chart.
    /// - parameter yMaximum: The maximum value for the chart on the y axis. This is used in conjunction with the y minimum to figure out how to plot the points on the chart.
    @discardableResult
    func yMaximum(_ yMaximum: Double) -> Self {
        ymax = yMaximum
        return self
    }

    /// Sets the minimum time value for the x axis for the chart.
    /// - parameter xMinimum: The minimum time for the chart. This is used in conjunction with the x maximum to figure out how to space the points on the chart.
    @discardableResult
    func xMinimum(_ xMinimum: TimeInterval) -> Self {
        xmin = xMinimum
        return self
    }

    /// Sets the maximum time value for the x axis for the chart.
    /// - parameter xMaximum: The maximum time for the chart. This is used in conjunction with the x minimum to figure out how to space the points on the chart.
    @discardableResult
    func xMaximum(_ xMaximum: TimeInterval) -> Self {
        xmax = xMaximum
        return self
    }

    /// Sets the timezone to use for the x values on the chart.
    /// - parameter timezone: The [IANA time zone identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) that should be used for the values on the x axis. Valid values for this parameter look like "America/New_York".
    @discardableResult
    func timezone(_ timezone: String) -> Self {
        tz = timezone
        return self
    }

    /// Sets the title for the chart.
    /// - parameter title: A title that should be placed on the top of the chart that can be used to add context and describe the data.
    @discardableResult
    func title(_ title: String) -> Self {
        t = title
        return self
    }

    /// Sets whether or not the chart is stepped.
    /// - parameter step: Whether or not the chart should be drawn as a step chart or a line chart.
    @discardableResult
    func step(_ step: Bool) -> Self {
        self.step = step
        return self
    }

    /// Sets whether or not to highlight the last data point.
    /// - parameter highlightLastPoint: Whether or not to highlight the last data point in the chart with a different color to make it more visible. This can be useful to call out the most recent value.
    @discardableResult
    func highlightLastPoint(_ highlightLastPoint: Bool) -> Self {
        hl = highlightLastPoint
        return self
    }

    /// Sets whether or not to only display the y axis on the left of the chart.
    /// - parameter onlyLeftYAxis: If set, the y axis will only be shown on the left side of the chart.
    /// - note: If either this or ``onlyRightYAxis`` is not set, the chart will have it's y axis shown on both sides. If both this value and ``onlyRightYAxis`` are set to true the chart will show the y axis only the left side.
    @discardableResult
    func onlyLeftYAxis(_ onlyLeftYAxis: Bool) -> Self {
        ol = onlyLeftYAxis
        return self
    }

    /// Sets whether or not to only display the y axis on the right of the chart.
    /// - parameter onlyRightYAxis: If set, the y axis will only be shown on the right side of the chart.
    /// - note: If either this or ``onlyLeftYAxis`` is not set, the chart will have it's y axis shown on both sides. If both this value and ``onlyLeftYAxis`` are set to true the chart will show the y axis only the left side.
    @discardableResult
    func onlyRightYAxis(_ onlyRightYAxis: Bool) -> Self {
        or = onlyRightYAxis
        return self
    }

    /// Attempts to generate the URL based on the parameters that have been set.
    /// - parameter type: The image type of the resulting chart. You can choose either a PNG or an SVG type for any chart configuration.
    /// - returns: A URL if all minimum paramaters have been set, otherwise returns nil.
    func url(type: ChartDImageType = .svg) -> URL? {
        guard let height, let width, datasets.count > 0 && datasets.count <= 5 else {
            return nil
        }

        // Construct all of the parameters that will describe the dataset.
        var dataItems = [URLQueryItem]()
        for (i, dataset) in datasets.enumerated() {
            dataItems.append(.init(name: "d\(i)", value: dataset.data))

            if let fill = dataset.fill {
                dataItems.append(.init(name: "f\(i)", value: fill))
            }

            if let stroke = dataset.stroke {
                dataItems.append(.init(name: "s\(i)", value: stroke))
            }
        }

        var components = URLComponents(string: "https://chartd.co/\(type.fileName)")
        var queryItems: [URLQueryItem] = [
            .init(name: "h", value: String(height)),
            .init(name: "w", value: String(width)),
        ]
        queryItems.append(contentsOf: dataItems)

        // Check and append parameters that have been set.
        if let ymin { queryItems.append(.init(name: "ymin", value: String(ymin))) }
        if let ymax { queryItems.append(.init(name: "ymax", value: String(ymax))) }
        if let xmin { queryItems.append(.init(name: "xmin", value: String(Int(xmin)))) }
        if let xmax { queryItems.append(.init(name: "xmax", value: String(Int(xmax)))) }
        if let tz { queryItems.append(.init(name: "tz", value: String(tz))) }
        if let t { queryItems.append(.init(name: "t", value: String(t))) }
        if let step { queryItems.append(.init(name: "step", value: String(step))) }
        if let hl { queryItems.append(.init(name: "hl", value: String(hl))) }
        if let ol { queryItems.append(.init(name: "ol", value: String(ol))) }
        if let or { queryItems.append(.init(name: "or", value: String(or))) }

        components?.queryItems = queryItems

        return components?.url
    }
}
