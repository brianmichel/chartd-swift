@testable import ChartD
import XCTest

final class Base62EncodingTests: XCTestCase {
    func testBasicEncoding() {
        let data0 = [1.0, 0.99, 0.9869, 0.95, 0.88]
        let expected = "98851"
        let output = data0.base62encode(with: 0.0, maximum: 1.0)

        XCTAssertEqual(output, expected, "The base62 encoding should correctly map to the right characters in the base62 encoding space.")
    }

    func testEncodingFallsBackWhenMinimumAndMaximumAreTheSame() {
        let data0 = [1.0, 0.99, 0.9869, 0.95, 0.88]
        let expected = "AAAAA"
        let output = data0.base62encode(with: 1.0, maximum: 1.0)

        XCTAssertEqual(output, expected, "The base62 encoding should correctly map to the right characters in the base62 encoding space.")
    }
}
