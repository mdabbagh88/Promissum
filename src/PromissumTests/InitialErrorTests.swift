//
//  InitialErrorTests.swift
//  Promissum
//
//  Created by Tom Lokhorst on 2014-12-31.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import Foundation
import XCTest
import Promissum

class InitialErrorTests: XCTestCase {

  func testError() {
    var error: NSError?

    let p = Promise<Int>(error: NSError(domain: PromissumErrorDomain, code: 42, userInfo: nil))

    error = p.error()

    XCTAssert(error?.code == 42, "Error should be set")
  }

  func testErrorVoid() {
    var error: NSError?

    let p = Promise<Int>(error: NSError(domain: PromissumErrorDomain, code: 42, userInfo: nil))

    p.catch { e in
      error = e
    }

    XCTAssert(error?.code == 42, "Error should be set")
  }

  func testErrorMap() {
    var value: Int?

    let p = Promise<Int>(error: NSError(domain: PromissumErrorDomain, code: 42, userInfo: nil))
      .mapError { $0.code + 1 }

    p.then { x in
      value = x
    }

    XCTAssert(value == 43, "Value should be set")
  }

  func testErrorFlatMap() {
    var value: Int?

    let p = Promise<Int>(error: NSError(domain: PromissumErrorDomain, code: 42, userInfo: nil))
      .flatMapError { Promise(value: $0.code + 1) }

    p.then { x in
      value = x
    }

    XCTAssert(value == 43, "Value should be set")
  }

  func testErrorFlatMap2() {
    var error: NSError?

    let p = Promise<Int>(error: NSError(domain: PromissumErrorDomain, code: 42, userInfo: nil))
      .flatMapError { Promise(error: NSError(domain: PromissumErrorDomain, code: $0.code + 1, userInfo: nil)) }

    p.catch { e in
      error = e
    }

    XCTAssert(error?.code == 43, "Error should be set")
  }

  func testFinally() {
    var finally: Bool = false

    let p = Promise<Int>(error: NSError(domain: PromissumErrorDomain, code: 42, userInfo: nil))

    p.finally {
      finally = true
    }

    XCTAssert(finally, "Finally should be set")
  }
}
