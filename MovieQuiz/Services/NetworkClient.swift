//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Nurbol on 03.07.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    fileprivate enum NetworkError: String, Error {
        case codeError = "Невозможно загрузить данные"
    }
    
    func fetch(url: URL,  handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}

extension NetworkClient.NetworkError: LocalizedError {
    fileprivate var errorDescription: String? {
        return self.rawValue
    }
}
