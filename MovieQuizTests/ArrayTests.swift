//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 12.02.2025.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 1]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 1)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 777]
        
        XCTAssertNil(value)
    }
}
