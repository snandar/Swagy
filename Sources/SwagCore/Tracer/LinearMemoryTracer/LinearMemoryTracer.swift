//
//  operandStackTracer.swift
//  SwagCore
//
//  Created by yin2 on 30/6/22.
//
import Foundation

public class LinearMemoryTracer
{
    
    public var records = [LinearMemoryProtoc]() //records Linear Memory Changes
    
    init() {}
    
    //create a record
    public func record(instrID: Int64, addr: Int64, status: Int64, value: Int64){
        
        var record = LinearMemoryProtoc()
        record.instrID = instrID
        record.address = addr
        record.status = status
        record.value = value

        records.append(record)
    }
    
    
    //write to file
    public func dumpLMP() {
        var linearmemories = LinearMemoryProtocs()
        linearmemories.lmps = records
        
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent("linear_memory")
        
        // prints the file path
        print("Saved to file path: \(fileUrl.path)")
        
        //data to write in file.
        do {
            let binaryData = try linearmemories.serializedData()
            try binaryData.write(to: fileUrl)
        } catch let error as NSError {
            print(error)
        }
        
        records.removeAll()
    }
    
    //read from file
    public func decodeLMT() {
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent("linear_memory")
        do {
            let data = try Foundation.Data(contentsOf: fileUrl)
            let decodedInfo = try LinearMemoryProtocs(serializedData: data)
            print(decodedInfo.lmps)
        } catch {
            print(error)
        }
        
    }
}
