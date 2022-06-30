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
    
    //function to test record via text
    func testRecord() throws {
//        let record = Record()
//        record.createAndWriteFile(stringData: "ASDASDFASDF", fileName: "test")
    }
    
    func testProtoc() throws{
        
        var instructionpro = InstructionProtoc()
        instructionpro.opcode = 0
        instructionpro.id = 0
        instructionpro.instruction = "hi"
        instructionpro.pc = 0
        instructionpro.funcIndex = 0
        
//        print(instructionpro.instruction)
        
        //original --> byte
        let binaryData = try instructionpro.serializedData()
        
        //byte --> original
        let decodedInfo = try InstructionProtoc(serializedData: binaryData)
        print(decodedInfo.instruction)

        
    }
}
