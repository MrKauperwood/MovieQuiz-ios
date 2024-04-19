//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Aleksei Bondarenko on 9.4.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app : XCUIApplication!
    let amountOfQuestions = 10
    let sleepTime : UInt32 = 2
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        sleep(sleepTime)
        
        continueAfterFailure = false
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        let firstPosterData = getScreenshotForTheImage(withId: "Poster")
        app.buttons["Yes"].tap()
        
        sleep(sleepTime)
        let secondPosterData = getScreenshotForTheImage(withId: "Poster")
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
    }
    
    func testNoButton() {
        let firstPosterData = getScreenshotForTheImage(withId: "Poster")
        app.buttons["No"].tap()
        
        sleep(sleepTime)
        let secondPosterData = getScreenshotForTheImage(withId: "Poster")
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
    }
    
    func testIndexChangingAfterClickingOnYesButton() {
        app.buttons["Yes"].tap()
        
        sleep(sleepTime)
        checkTextInTheQuestionIndex(currentQuestion: 2)
        
    }
    
    func testIndexChangingAfterClickingOnNoButton() {
        app.buttons["No"].tap()
        
        sleep(sleepTime)
        checkTextInTheQuestionIndex(currentQuestion: 2)
        
    }
    
    func testThatAlertIsPresentAfterQuizFinished() {
        reachTheEndOfTheGame()
        let alert = getAlertById(id: "Game results")

        let alertHeader = alert.label
        let alertButtonText = alert.buttons.firstMatch.label
        
        sleep(sleepTime)
        
        XCTAssertEqual(alertHeader, "Этот раунд окончен!")
        XCTAssertEqual(alertButtonText, "Сыграть ещё раз")
    }
    
    func testRestartGame() {
        reachTheEndOfTheGame()
        let alert = getAlertById(id: "Game results")
        let firstPosterData = getScreenshotForTheImage(withId: "Poster")
        
        alert.buttons.firstMatch.tap()
        sleep(sleepTime)
        
        let secondPosterData = getScreenshotForTheImage(withId: "Poster")
        
        sleep(sleepTime)
        checkTextInTheQuestionIndex(currentQuestion: 1)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func getAlertById(id : String) -> XCUIElement{
        let alert = app.alerts[id]
        XCTAssertTrue(alert.exists)
        return alert
    }
    
    func reachTheEndOfTheGame() {
        for _ in 1...amountOfQuestions {
            if Int.random(in: 0...1) == 0 {
                app.buttons["No"].tap()
            } else {
                app.buttons["Yes"].tap()
            }
            sleep(sleepTime)
        }
        checkTextInTheQuestionIndex(currentQuestion: amountOfQuestions)
    }
    
    func checkTextInTheQuestionIndex(currentQuestion : Int) {
        let indexLabel = app.staticTexts["Index"]
        sleep(sleepTime)
        XCTAssertEqual(indexLabel.label, "\(currentQuestion)/\(amountOfQuestions)")
    }
    
    func getScreenshotForTheImage(withId id: String) -> Data {
        let poster = app.images[id]
        let screenshot = poster.screenshot().pngRepresentation
        return screenshot
    }
}
