//
//  SwikkaTests.swift
//  SwikkaTests
//
//  Created by Ryuichi Saito on 9/21/15.
//  Copyright © 2015 Ryuichi Saito, LLC. All rights reserved.
//

import XCTest
@testable import Swikka

class SwikkaTests: XCTestCase {
    
    struct TestMessage {
        let name: String
        let expect: XCTestExpectation?
    }
    
    struct SimpleActor: SWKKActor {
        var name: String {
            return "simple actor"
        }
        
        func receive(message: Any) {
            switch message {
            case let testMessage as TestMessage:
                if testMessage.name == "test name" {
                    testMessage.expect?.fulfill()
                }
            default: break
            }
        }
    }
    
    struct SimpleMainThreadActor: SWKKMainThreadActor {
        var name: String {
            return "simple main-thread actor"
        }
        
        func receive(message: Any) {
            switch message {
            case let testMessage as TestMessage:
                if testMessage.name == "test main-thread" {
                    testMessage.expect?.fulfill()
                }
            default: break
            }
        }
    }
    
    func testMessageExecuted() {
        let simpleActor = SimpleActor()
        
        XCTAssertEqual(simpleActor.name, "simple actor", "simple actor name")
        print(simpleActor.dispatchQueue.description)
        XCTAssertTrue(simpleActor.dispatchQueue.description.containsString("com.ryuichisaito.swikka.simple actor"), "should be in its own dispatch queue")
        
        simpleActor ! TestMessage(name: "test name", expect: expectationWithDescription("this should be executed"))
        waitForExpectationsWithTimeout(3) { (error) -> Void in
            if let error = error {
                print(error)
            }
        }
    }
    
    func testMessageExecutedOnMainThread() {
        let mainThreadActor = SimpleMainThreadActor()
        
        XCTAssertEqual(mainThreadActor.name, "simple main-thread actor", "main thread actor name")
        XCTAssertTrue(mainThreadActor.dispatchQueue.description.containsString("com.apple.main-thread"), "should be on the main thread queue")
        
        mainThreadActor ! TestMessage(name: "test main-thread", expect: expectationWithDescription("this should be executed"))
        waitForExpectationsWithTimeout(3) { (error) -> Void in
            if let error = error {
                print(error)
            }
        }
    }
    
    struct TestMiddleManMessage {
        let name: String
        let expect: XCTestExpectation?
    }
    
    struct MiddleManActor: SWKKActor {
        var name: String {
            return "simple actor"
        }
        
        func receive(message: Any) {
            switch message {
            case let testMessage as TestMessage:
                if testMessage.name == "start" {
                    self ! TestMiddleManMessage(name: "middle man", expect: testMessage.expect)
                }
                if testMessage.name == "final" {
                    testMessage.expect?.fulfill()
                }
            case let middleManMessage as TestMiddleManMessage:
                if middleManMessage.name == "middle man" {
                    self ! TestMessage(name: "final", expect: middleManMessage.expect)
                }
            default: break
            }
        }
    }
    
    func testMessagePassing() {
        let middleManActor = MiddleManActor()
        
        middleManActor ! TestMessage(name: "final", expect: expectationWithDescription("directly calling final should be executed"))
        middleManActor ! TestMessage(name: "start", expect: expectationWithDescription("starting will make it eventually be executed"))
        middleManActor ! TestMiddleManMessage(name: "middle man", expect: expectationWithDescription("middle man will be executed"))
        waitForExpectationsWithTimeout(3) { (error) -> Void in
            if let error = error {
                print(error)
            }
        }
    }
    
}
