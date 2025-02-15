//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 22.01.2025.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url:url)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
