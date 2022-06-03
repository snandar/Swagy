import XCTest
import SwagCore

final class TraceTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    static var allTests = [
        ("testRecord", testRecord),
        
    ]
    
    func testRecord() throws {
        let record = Record()
        record.createAndWriteFile(stringData: "ASDASDFASDF", fileName: "test")
    }
    
}
