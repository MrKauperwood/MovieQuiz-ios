//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Aleksei Bondarenko on 8.4.2024.
//

@testable import MovieQuiz
import XCTest

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1, 2, 3, 4, 5]

        // When
        let value = array[safe: 2]

        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }

    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 2, 3, 4, 5]

        // When
        let value = array[safe: 20]

        // Then
        XCTAssertNil(value)
    }
}
