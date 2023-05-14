import Foundation

private let base62 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

extension Collection where Element == Double {
    /// Base62 encodes a collection of doubles.
    /// - parameter minimum: The minimum value that should be used when calculating where values are in the encoded set.
    /// - parameter maximum: The maximum value that should be used when calculating where values are in the encoded set.
    /// - returns: A new string to represent the passed data in base62 encoding.
    func base62encode(minimum: Element, maximum: Element) -> String {
        let range = maximum - minimum
        var output = [Character](repeating: base62.first!, count: count)
        if range == 0 {
            for i in 0..<count {
                output[i] = base62.first!
            }
            return String(output)
        }
        let size = Double(base62.count - 1)
        for (i, y) in enumerated() {
            let index = Int(size * (y - minimum) / range)
            if index >= 0 && index < base62.count {
                output[i] = base62[base62.index(base62.startIndex, offsetBy: index)]
            } else {
                output[i] = base62.first!
            }
        }
        return String(output)
    }
}
