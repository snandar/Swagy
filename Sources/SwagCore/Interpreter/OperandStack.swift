//
//  OperandStack.swift
//  wasm.swift
//
//  Created by Jianing Wang on 2020/12/25.
//

import Foundation

public struct OperandStack {
    private var slots = [UInt64]()
    public var recorder: StackRecorder?
}

public protocol StackRecorder {
    func stackRecord(stackPointer: Int, status: Int, address: Int, value: Int)
}

extension OperandStack {
    
    
    mutating func pushU64(_ val: UInt64) {
        slots.append(val)
        let afterSize = size()
        recorder?.stackRecord(stackPointer: afterSize, status: 1, address: afterSize, value: Int(val))
    }
    mutating func popU64() -> UInt64 {
        let beforeSize = size()
        let popedValue = slots.removeLast()
        let afterSize = size()
        recorder?.stackRecord(stackPointer: afterSize, status: 1, address: beforeSize, value: Int(popedValue))
        return popedValue
    }
    
    mutating func pushS64(_ val: Int64) {
        pushU64(UInt64(bitPattern: val))
    }
    mutating func popS64() -> Int64 {
        Int64(truncatingIfNeeded: popU64())
    }
    
    mutating func pushU32(_ val: UInt32) {
        pushU64(UInt64(val))
    }
    mutating func popU32() -> UInt32 {
        UInt32(popU64())
    }
    
    mutating func pushS32(_ val: Int32) {
        pushU32(UInt32(bitPattern: val))
    }
    mutating func popS32() -> Int32 {
        Int32(truncatingIfNeeded: popU32())
    }
    
    mutating func pushF32(_ val: Float32) {
        pushU32(val.bitPattern)
    }
    mutating func popF32() -> Float32 {
        Float32(bitPattern: popU32())
    }
    
    mutating func pushF64(_ val: Float64) {
        pushU64(val.bitPattern)
    }
    mutating func popF64() -> Float64 {
        Float64(bitPattern: popU64())
    }
    
    mutating func pushBool(_ val: Bool) {
        pushU64(val ? 1 : 0)
    }
    mutating func popBool() -> Bool {
        popU64() != 0
    }
    
    func size() -> Int {
        return slots.count
    }
    
    func getOperand(at index: UInt32) -> UInt64 {
        let val = slots[Int(index)]
        recorder?.stackRecord(stackPointer: size(), status: 0, address: Int(index), value: Int(val))
        return val
    }
    
    func getTopOperands(_ n: Int) -> [UInt64] {
        let vals = Array(slots.suffix(n))
        return vals
    }
    
    mutating func setOperand(at index: UInt32, with val: UInt64) {
        slots[Int(index)] = val
        recorder?.stackRecord(stackPointer: size(), status: 1, address: Int(index), value: Int(val))
    }
    
    mutating func pushU64s(_ vals: [UInt64]) {
        slots.append(contentsOf: vals)
        let afterSize = size()
        for item in vals.enumerated() {
            let sp = afterSize - vals.count + item.offset + 1
            recorder?.stackRecord(stackPointer: sp, status: 1, address: sp, value: Int(item.element))
        }
    }
    
    @discardableResult mutating func popU64s(_ n: Int) -> [UInt64] {
        let vals = Array(slots.suffix(n))
        let beforeSize = size()
        slots.removeLast(n)
        for item in vals.reversed().enumerated() {
            let sp = beforeSize - item.offset - 1
            let addr = sp + 1
            recorder?.stackRecord(stackPointer: sp, status: 1, address: addr, value: Int(item.element))
        }
        return vals
    }
}
