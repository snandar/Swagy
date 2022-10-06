import XCTest
import SwagCore

final class SwagCoreTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    let fixtures = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Fixtures")
    
    func instantiate(_ path: URL) throws -> VM {
        let data = try XCTUnwrap(NSData(contentsOf: path))
        var buffer = [Byte].init(repeating: 0, count: data.length)
        data.getBytes(&buffer, length: data.length)
        var reader = Reader(data: buffer)
        let module = try reader.readModule()
//        var dumper = Dumper(module: module)
//        dumper.dump()
        let vm = VM(module: module)
        return vm
    }
    
    func testInstructions() throws {
        try testNumberic()
        try testParametric()
    }
    
    func testNumberic() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("00_Instructions")
            .appendingPathComponent("NumericInstructions.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testParametric() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("00_Instructions")
            .appendingPathComponent("ParametricInstructions.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testHelloworld() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("01_HelloWorld")
            .appendingPathComponent("HelloWorld.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testFibonacci() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("02_Fibonacci")
            .appendingPathComponent("Fibonacci.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    // assert function is defined internally
    func testFactorial() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("03_Factorial")
            .appendingPathComponent("Factorial.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        print("🎉🎉🎉🎉🎉🎉")
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    // assert function is provided by VM
    func testFactorial2() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("03_Factorial")
            .appendingPathComponent("Factorial2.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testMemory() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("04_Memory")
            .appendingPathComponent("Memory.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    // This is to test indirect call
    func testCalc() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("05_Calc")
            .appendingPathComponent("Calc.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    // This is to test trace
    func testTraceInt() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("06_Trace_Int")
            .appendingPathComponent("trace1_int.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testTraceStr() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("06_Trace_Int")
            .appendingPathComponent("trace2_str.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testTraceArray() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("06_Trace_Int")
            .appendingPathComponent("trace3_array.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testTraceStackBuffer() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("06_Trace_Int")
            .appendingPathComponent("trace4.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testMalloc1() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("Malloc")
            .appendingPathComponent("example1.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    
    func testMalloc2() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("Malloc")
            .appendingPathComponent("example2.wasm")
        var instance = try instantiate(casePath)
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    
    
    func testMalloc3() throws {
        let start = Date()
        
        let casePath = fixtures.appendingPathComponent("Malloc")
            .appendingPathComponent("example3.wasm")
        var instance = try instantiate(casePath)
        let hookDict: [FuncIdx: String] = [
            8: "malloc",
            9: "free"
        ]
        instance.hookDict = hookDict
        instance.loop()
        
        let end = Date()
        let consumedTime = end.timeIntervalSince(start)
        print("consumed time: \(consumedTime)")
    }
    
    func testLegal() throws {
        
        let casePath = fixtures.appendingPathComponent("09_tracetest")
            .appendingPathComponent("legal.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
    
    }
    
    func testoutofbounds() throws {
        
        let casePath = fixtures.appendingPathComponent("09_tracetest")
            .appendingPathComponent("outofbounds.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
    
    }
    
    func testuseafterfree() throws {
        
        let casePath = fixtures.appendingPathComponent("09_tracetest")
            .appendingPathComponent("useafterfree.wasm")
        let instance = try instantiate(casePath)
        instance.loop()
    
    }
    

    static var allTests = [
        ("testInstructions", testInstructions),
        ("testHelloworld", testHelloworld),
        ("testFibonacci", testFibonacci),
        ("testFactorial", testFactorial),
        ("testFactorial2", testFactorial2),
        ("testMemory", testMemory)
    ]
}
