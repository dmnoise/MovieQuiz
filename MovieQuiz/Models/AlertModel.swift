//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 10.01.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let closure: ()-> ()
}
