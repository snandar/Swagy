//
//  operandStackTracer.swift
//  SwagCore
//
//  Created by Nandar on 30/6/22.
//
import Foundation

public class OperandStackTracer
{
    
    public var records = [OperationStackProtoc]() //records operand Stack
    
    init() {}
    
    //create a record
    public func record(instrID : Int64, bp : Int64, sp : Int64, status : Int64, address : Int64, value : Int64){
        var record = OperationStackProtoc()
        record.instructionID = instrID
        record.basePointer = bp
        record.stackPointer = sp
        record.status = status
        record.address = address
        record.value = value
        records.append(record)
    }
    
    //write to file
    public func dumpOST() {
        var operations = OperationStacksProtoc()
        operations.osp = records
        
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent("operand_stack")
        
        // prints the file path
        print("Saved to file path: \(fileUrl.path)")
        
        //data to write in file.
        do {
            let binaryData = try operations.serializedData()
            try binaryData.write(to: fileUrl)
        } catch let error as NSError {
            print(error)
        }
        
        records.removeAll()
    }
    
    public func decodeOST() {
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
