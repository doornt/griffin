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
        memCache?.setObject("dujian1", for: "username", cost: 19)
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
        
        XCTAssert(name == "dujian1")
        XCTAssert(age == 18)
    }
    
    func testRemoveAllObject() {
        memCache?.removeAllObjects()
        
        let name = memCache?.object(for: "username")
        let age = memCache?.object(for: "age")
        XCTAssert(name == nil)
        XCTAssert(age == nil)
    }
    
    func testTrimToCount(){
        
        memCache?.trimToCount(1)
        
        let name = memCache?.object(for: "username")
        XCTAssert(name == nil)
        let age = Utils.any2Int(memCache?.object(for: "age"))
        XCTAssert(age == 18)
    }
    
    func testTrimToCost() {
        memCache?.trimToCost(5)
        let name = memCache?.object(for: "username")
        XCTAssert(name == nil)
        let age = Utils.any2Int(memCache?.object(for: "age"))
        XCTAssert(age == 18)
    }
    
    func testTrimToAge() {
        memCache?.setObject(1, for: 1)
        
        sleep(2)
        self.memCache?.setObject(5, for: 5)
        sleep(2)
        self.memCache?.setObject(15, for: 15)
        sleep(2)
        self.memCache?.setObject(20, for: 20)
        
        self.memCache?.trimToAge(5) // 4s 前
        
        
        let name = Utils.any2String(memCache?.object(for: "username"))
        let age = Utils.any2Int(memCache?.object(for: "age"))
        let first = Utils.any2Int(memCache?.object(for: 1))
        XCTAssert(name == "")
        XCTAssert(age == nil)
        XCTAssert(first == nil)
        
        let five = Utils.any2Int(memCache?.object(for: 5))
        let fifteen = Utils.any2Int(memCache?.object(for: 15))
        let twenty = Utils.any2Int(memCache?.object(for: 20))
        XCTAssert(five == nil)
        XCTAssert(fifteen == 15)
        XCTAssert(twenty == 20)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
