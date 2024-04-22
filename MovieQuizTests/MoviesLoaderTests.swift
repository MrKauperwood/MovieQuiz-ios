//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Aleksei Bondarenko on 9.4.2024.
//

@testable import MovieQuiz
import XCTest

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        // As the movie loading function is asynchronous, we need to wait
        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            // Then
            switch result {
            case let .success(movies):
                // We compare the data to what we expected
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure:
                // We do not expect an error; if one appears, the test should fail
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            // Then
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }
}
