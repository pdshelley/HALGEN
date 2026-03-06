//
//  SwiftAVRGeneratorTests.swift
//  SwiftAVRGeneratorTests
//
//  Created by Paul Shelley on 5/27/23.
//

import XCTest
@testable import SwiftAVRGenerator

final class SwiftAVRGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public protocol UARTPort {
            static var dataRegister: PortDataType { get set }
            static var dataRegisterEmpty: Bool { get }
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("static var dataRegister: PortDataType { get set }"))
        XCTAssertTrue(result.content.contains("static var dataRegisterEmpty: Bool { get }"))
    }

    func testPerformanceExample() throws {
        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum PORTD {
            public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x2A) } set { _volatileRegisterWriteUInt8(0x2A, newValue) } }
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("""
        public static var dataDirection: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x2A)
            }
            set {
                _volatileRegisterWriteUInt8(0x2A, newValue)
            }
        }
        """))
    }

}
