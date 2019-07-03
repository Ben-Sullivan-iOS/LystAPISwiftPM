import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LystAPIServiceTests.allTests),
    ]
}
#endif
