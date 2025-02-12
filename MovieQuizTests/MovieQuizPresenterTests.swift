//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 12.02.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Текст вопроса", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Текст вопроса")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
