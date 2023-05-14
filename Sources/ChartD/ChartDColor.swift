import Foundation

/// Represents a color for a given ChartD dataset.
struct ChartDColor {
    /// The stroke type of the dataset
    enum `Type`: String {
        case dotted = "."
        case dashed = "-"
    }
    /// A standard 8-character RGBA code (i.e. E6AABB05, 1C70C211, etc.)
    /// This string is broken up as follows:
    ///
    ///       +-------------+
    ///       | Green Value |
    ///       +-------------+  +--------------+
    ///                    ||  | Alpha Values |
    ///                    ||  +--------------+
    ///                    ||  ||
    ///                    ||  ||
    ///                    EEBB01AA
    ///                      ||  ||
    ///                      ||  ||
    ///           +-----------+  ||
    ///           | Red Value |  ||
    ///           +-----------+  +------------+
    ///                          | Blue Value |
    ///                          +------------+
    let hex: String
    /// An optional type that can be specified to get a dotted or dashed visual design in the chart.
    let type: Type?

    init(hex: String, type: Type? = nil) {
        self.hex = hex
        self.type = type
    }

    /// The encoded string that can be sent to ChartD.
    /// - warning: This will return nil if the hex value is not exactly 8 characters.
    func encoded() -> String? {
        guard hex.count == 8 else {
            return nil
        }

        var output = hex

        if let type { output.append(type.rawValue) }

        return output
    }
}
