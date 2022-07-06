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
    
    func testOperandStackDecode() throws {
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent("operand_stack")
        do {
            let data = try Foundation.Data(contentsOf: fileUrl)
            let decodedInfo = try OperationStacksProtoc(serializedData: data)
            print(decodedInfo.osp)
        } catch {
            print(error)
        }
    }
}
