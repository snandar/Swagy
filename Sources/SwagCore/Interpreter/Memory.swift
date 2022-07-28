//
//  Memory.swift
//  wasm.swift
//
//  Created by Jianing Wang on 2021/1/19.
//

import Foundation

public struct Memory {
    var type: MemType
    var data: [Byte?]
    
    /// mallocDict is used to record all allocated memory address ranges
    /// in linear memory.
    /// (start address, end address)
    var mallocDict: [(Int, Int)] = []
    /// When the vm is trying to malloc or free memory, stop checking
    /// momery read and write. Also, if we don't hook, we don't need
    /// to check memory.
    var isStopCheckingMemory = false
    public var recorder: MemoryRecorder?
    
    init(memoryType: MemType) {
        self.type = memoryType
        self.data = Array<Byte?>.init(repeating: nil, count: Int(memoryType.min) * PAGE_SIZE)
    }
}

public protocol MemoryRecorder {
    func memoryRecord(address: Int64, status: Int64, value: Int64)
}

extension Int64 {
    init?(_ value: Byte?) {
        guard let value = value else { return nil }
        self.init(value)
    }
}


extension Memory {
    
    func size() -> UInt32 {
        return UInt32(self.data.count / PAGE_SIZE)
    }
    
    mutating func grow(_ n: UInt32) -> UInt32 {
        let oldSize = size()
        if n == 0 {
            return oldSize
        }
        var maxPageCount = UInt32(MAX_PAGE_COUNT)
        if let max = type.max,
           max > 0 {
            maxPageCount = max
        }
        let newSize = oldSize + n
        if newSize > maxPageCount {
            return 0xFFFFFFFF // -1
        }
        // TODO: copy?
        var newData = Array<Byte?>.init(repeating: nil, count: Int(newSize) * PAGE_SIZE)
        for (offset, element) in data.enumerated() {
            newData[offset] = element
        }
        self.data = newData
        return oldSize
    }
    
    func checkOffset(offset: UInt64, length: Int) {
        if (self.data.count - length) < Int(offset) {
            fatalError("MemoryOutOfBounds")
        }
    }
    
    func read(offset: UInt64, buf: inout [Byte?]) {
        checkOffset(offset: offset, length: buf.count)
        let startIndex = Int(offset)
        let endIndex = startIndex + buf.count
        let dataSlice = data[startIndex..<endIndex]
        buf = Array(dataSlice)
        
        //Record
        //var count = 0
        for item in dataSlice.enumerated(){
            let data = dataSlice[startIndex + item.offset]
            
            //count += 1
            recorder?.memoryRecord(address: Int64(startIndex), status: 1, value: Int64(data) ?? 0)
        }
        
    }
    
    mutating func write(offset: UInt64, data: [Byte]) {
        // MARK: Instrumentation
        if  !isStopCheckingMemory {
            var isInMallocedRange = false
            for mallocRange in mallocDict {
                if mallocRange.0 <= offset && offset < mallocRange.1 {
                    isInMallocedRange = true
                }
            }
            if isInMallocedRange {
                log("write \(data) to @\(offset) in a legal memory range", .native, .ins)
            } else {
                log("write \(data) to @\(offset) in a illegal memory range", .native, .warning)
            }
        }
        checkOffset(offset: offset, length: data.count)
        let startIndex = Int(offset)
        let endIndex = startIndex + data.count
        let subrange = startIndex..<endIndex
        let array = data
        
        self.data.replaceSubrange(subrange, with: data)
        
        //Record
        
        //convert [byte] into int64
        var value : UInt32 = 0
        let arrayData = NSData(bytes: array, length: 4)
        arrayData.getBytes(&value, length: 4)
        value = UInt32(bigEndian: value)
        
        //record method
        recorder?.memoryRecord(address: Int64(offset), status: 2, value: Int64(value))
        
        
    }
    
}
