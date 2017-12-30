//
//  GriffinTests.swift
//  GriffinTests
//
//  Created by 裴韬 on 2017/12/30.
//  Copyright © 2017年 裴韬. All rights reserved.
//

import XCTest
@testable import GriffinSDK

class GriffinTests: XCTestCase {
    
    let memCache = GriffinMemoryCache.init()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        memCache?.setObject("dujian", for: "username")
        memCache?.setObject(18, for: "age")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let name = Utils.any2String(memCache?.object(for: "username"))
        let age = Utils.any2Int(memCache?.object(for: "age"))
        
        XCTAssert(name == "dujian")
        XCTAssert(age == 18)
    }
    
    func testRemoveAllObject() {
        memCache?.removeAllObjects()
        
        let name = memCache?.object(for: "username")
        let age = memCache?.object(for: "age")
        XCTAssert(name == nil)
        XCTAssert(age == nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
