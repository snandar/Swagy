//
//  Record.swift
//  SwagCore
//
//  Created by yin2 on 3/6/22.
//

import Foundation

public class Record {
    
    var instrData = ""
    
    public init() {
        
    }
    
    // function to create file and write into the same.
    public func createAndWriteFile(stringData: String, fileName: String){
//        let fileName = "Hello"//to change into func
//        let stringData = "hi"//to change into func
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        // prints the file path
        print("File path \(fileUrl.path)")
        
        //data to write in file.
        do {
            try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print (error)
        }
    }
    
    //function to record instructions
    public func recordInstruction(instrCounter: Int, instr: String, opCode: String, funcIndex: Int, instrIndex: Int) {
        
        instrData += String(instrCounter)
        instrData += instr
        instrData += opCode
        instrData += String(funcIndex)
        instrData += String(instrIndex)
        
    }
    
    //Function to write the instructions out on to a file
    public func writeInstruction() {
        createAndWriteFile(stringData: instrData, fileName: "instruction")
    }
    

}
