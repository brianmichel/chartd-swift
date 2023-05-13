import Foundation

struct ChartDDataset {
    /// A base62 encoded string representing the data in this series.
    /// Use the functions found in ``Collection+Base62`` to generate these values.
    let data: String
    let stroke: String? = nil
    let fill: String? = nil
}

enum ChardDURLBuilderError: Error {
    case tooManyDatasets
}

enum ChartDImageType {
    case png
    case svg

    var fileName: String {
        switch self {
        case .png:
            return "a.png"
        case .svg:
            return "a.svg"
        }
    }
}

final class ChartDURLBuilder {
    // The width of the chart
    private var width: Int?
    // The height of the chart
    private var height: Int?
    // This gets bound into d0, d1, d2, d3, d4 at build time.
    private var datasets = [ChartDDataset]()
    // The y minimum for the chart.
    private var ymin: Double?
    // The y maximum for the chart.
    private var ymax: Double?
    // A Unix timestamp for the minimum x value of the chart.
    private var xmin: TimeInterval?
    // A Unit timestamp for the maximum x value of the chart.
    private var xmax: TimeInterval?
    // The timeone that should be used when calulating dates on the x axis.
    private var tz: String?
    // The title of the chart.
    private var t: String?
    // Whether or not to have a step chart.
    private var step: Bool?
    // Whether or not to highlight the last point on the chart.
    private var hl: Bool?
    // Whether or not to only show the y axis on the left.
    private var ol: Bool?
    // Whether or not to only show the y axis on the right.
    private var or: Bool?

    @discardableResult
    func width(_ width: Int) -> Self {
        self.width = width
        return self
    }

    @discardableResult
    func height(_ height: Int) -> Self {
        self.height = height
        return self
    }

    @discardableResult
    func datasets(_ datasets: [ChartDDataset]) throws -> Self {
        guard datasets.count <= 5 else {
            throw ChardDURLBuilderError.tooManyDatasets
        }
        self.datasets = datasets
        return self
    }

    @discardableResult
    func yMinimum(_ yMinimum: Double) -> Self {
        ymin = yMinimum
        return self
    }

    @discardableResult
    func yMaximum(_ yMaximum: Double) -> Self {
        ymax = yMaximum
        return self
    }

    @discardableResult
    func xMinimum(_ xMinimum: TimeInterval) -> Self {
        xmin = xMinimum
        return self
    }

    @discardableResult
    func xMaximum(_ xMaximum: TimeInterval) -> Self {
        xmax = xMaximum
        return self
    }

    @discardableResult
    func timezone(_ timezone: String) -> Self {
        tz = timezone
        return self
    }

    @discardableResult
    func title(_ title: String) -> Self {
        t = title
        return self
    }

    @discardableResult
    func step(_ step: Bool) -> Self {
        self.step = step
        return self
    }

    @discardableResult
    func highlightLastPoint(_ highlightLastPoint: Bool) -> Self {
        hl = highlightLastPoint
        return self
    }

    @discardableResult
    func onlyLeftYAxis(_ onlyLeftYAxis: Bool) -> Self {
        ol = onlyLeftYAxis
        return self
    }

    @discardableResult
    func onlyRightYAxis(_ onlyRightYAxis: Bool) -> Self {
        or = onlyRightYAxis
        return self
    }

    func url(type: ChartDImageType = .svg) -> URL? {
        guard let height, let width, datasets.count >= 0 else {
            return nil
        }
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

        if let ymin { queryItems.append(.init(name: "ymin", value: String(ymin))) }
        if let ymax { queryItems.append(.init(name: "ymax", value: String(ymax))) }
        if let xmin { queryItems.append(.init(name: "xmin", value: String(xmin))) }
        if let xmax { queryItems.append(.init(name: "xmax", value: String(xmax))) }
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
