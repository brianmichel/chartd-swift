import XCTest
@testable import ChartD

final class ChartDURLBuilderTests: XCTestCase {
    func testProducesEmptyURLIfMinimumRequiredDataNotPresent() {
        let url = ChartDURLBuilder().url()

        XCTAssertNil(url, "URL should be nil if no data has been presented")
    }

    func testProducesURLIfMinimumRequirementsArePresent() throws {
        let url = try ChartDURLBuilder()
            .height(100)
            .width(300)
            .datasets([.init(data: "r0293jr0293jr")])
            .url()

        XCTAssertNotNil(url, "URL should be non-nil when all of the minimally required data is present.")
    }

    func testThrowsWhenAddingTooManyDataSets() throws {
        XCTAssertThrowsError(try ChartDURLBuilder()
            .datasets([
                .init(data: "r0293jr0293jr"),
                .init(data: "r0293jr0293jr"),
                .init(data: "r0293jr0293jr"),
                .init(data: "r0293jr0293jr"),
                .init(data: "r0293jr0293jr"),
                .init(data: "r0293jr0293jr")
            ]),
        "This test should fail since we are adding too many datasets.")
    }

    func testAddingAllPropertiesYieldsUsableURL() throws {
        let url = try ChartDURLBuilder()
            .width(300)
            .height(300)
            .datasets([
                .init(data: "98851"),
                .init(data: "98852"),
                .init(data: "98853"),
            ])
            .yMinimum(0.0)
            .yMaximum(1.0)
            .xMinimum(Date().timeIntervalSince1970)
            .xMaximum(Date().timeIntervalSince1970 + 25_000)
            .timezone("America/New_York")
            .title("A Test Chart")
            .step(true)
            .highlightLastPoint(true)
            .onlyLeftYAxis(true)
            .onlyRightYAxis(true)
            .url()

        XCTAssertNotNil(url, "URL should still be non-nil after specifying all available properties.")
    }

    func testExpectedURLMatchesOutputOfSimilarParameters() throws {
        let url = try ChartDURLBuilder()
            .width(300)
            .height(300)
            .datasets([
                .init(data: "98851"),
                .init(data: "98852"),
                .init(data: "98853"),
            ])
            .yMinimum(0.0)
            .yMaximum(1.0)
            .timezone("America/New_York")
            .title("A Test Chart")
            .step(true)
            .highlightLastPoint(true)
            .onlyLeftYAxis(true)
            .onlyRightYAxis(true)
            .url()

        let expected = try XCTUnwrap(URL(string: "https://chartd.co/a.svg?h=300&w=300&d0=98851&d1=98852&d2=98853&ymin=0.0&ymax=1.0&tz=America/New_York&t=A%20Test%20Chart&step=true&hl=true&ol=true&or=true"))

        XCTAssertEqual(url, expected, "The output url should equal the expected value which is a valid chart.")
    }
}
