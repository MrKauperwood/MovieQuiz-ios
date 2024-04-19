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

        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            // Then
            switch result {
            case let .success(movies):
                // сравниваем данные с тем, что мы предполагали
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure:
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
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
                XCTFail("Unexpected failure")
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }
}
