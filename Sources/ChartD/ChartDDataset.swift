import Foundation

/// A dataset that can be represented by ChartD.
struct ChartDDataset {
    /// A base62 encoded string representing the data in this series.
    /// Use the functions found in ``Collection+Base62`` to generate these values.
    let data: String
    /// An optional encoded string representing the stroke color.
    let stroke: ChartDColor?
    /// An optional encoded string representing the fill color.
    /// - note: color types (dashed, dotted) has no effect to fill on fill.
    let fill: ChartDColor?

    init(data: String, stroke: ChartDColor? = nil, fill: ChartDColor? = nil) {
        self.data = data
        self.stroke = stroke
        self.fill = fill
    }
}
