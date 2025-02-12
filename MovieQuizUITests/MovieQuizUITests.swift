//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Dmitriy Noise on 01.02.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    /// Тест кнопки "Да" (меняется ли лейбл с номером вопроса и постер)
    func testYesButton() throws {
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        sleep(2)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    /// Тест кнопки "Нет" (меняется ли лейбл с номером вопроса и постер)
    func testNoButton() throws {
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        sleep(2)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    /// Тест появления алерта при окончании раунда
    func testAlertWithResults() throws {
        sleep(2)
        
        let button = app.buttons["Yes"]
        
        for _ in 1...10 {
            button.tap()
            sleep(1)
        }
        
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    /// Тест скрытия алерта после нажатия на кнопку на нём
    func testAlertDisclosure() throws {
        try testAlertWithResults()
        
        let alert = app.alerts["Game results"]
        let button = alert.buttons.firstMatch
        
        button.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
