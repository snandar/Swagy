//
//  InstrRecord.swift
//  SwagCore
//
//  Created by Nandar on 8/6/22.
//

import Foundation

public class InstrRecorder
{
    
    public var records = [InstructionProtoc]() //records instruction
    
    init() {}
    
    //create a record
    public func record(instr: Instruction, id: Int64, funcIndex: Int64, pc: Int64){
        var record = InstructionProtoc()
        record.id = id
        record.instruction = instr.description
        record.opcode = Int32(instr.opcode.rawValue)
        record.funcIndex = funcIndex
        record.pc = pc
        records.append(record)
    }
    
    //write to file
    public func dumpInstr() {
        var instrs = InstructionsProtoc()
        instrs.instructions = records
        
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent("instr")
        
        // prints the file path
        print("Saved to file path: \(fileUrl.path)")
        
        //data to write in file.
        do {
            let binaryData = try instrs.serializedData()
            try binaryData.write(to: fileUrl)
        } catch let error as NSError {
            print(error)
        }
        
        records.removeAll()
    }
    
    
    
    

//    public func seralizeInstrData(){
//        for element in records {
//            //print(element.instruction)
//            do {
//                var binaryData = try element.serializedData()
//                //binaryrecords.append(binaryData)
//
//            } catch {
//                print(error)
//            }
//        }
//        records.removeAll()
//    }

//    public func deseralizeInstrData(){
//    //    var decodedInfo = try InstructionProtoc(serializedData: binaryData)
//    }
}
