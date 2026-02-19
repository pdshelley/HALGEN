//
//  Utils.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 19/02/2026.
//
import Foundation

func buildFileHeader(for fileName: String) -> String {
    let fullFormatter = DateFormatter()
    fullFormatter.dateFormat = "MM/dd/yyyy"
    let fullDateString = fullFormatter.string(from: Date())
    
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    let yearString = yearFormatter.string(from: Date())
    
    let fileHeader = """
    //===----------------------------------------------------------------------===//
    //
    // \(fileName).swift
    // CoreAVR
    //
    // Created by Swift AVR Generator on \(fullDateString).
    // Copyright © \(yearString) Paul Shelley. All rights reserved.
    //
    //===----------------------------------------------------------------------===//
    
    
    public typealias \(fileName.lowercased()) = \(fileName)
    
    
    """
    // TODO: The typealias should be generated in a different location.
    return fileHeader
}
