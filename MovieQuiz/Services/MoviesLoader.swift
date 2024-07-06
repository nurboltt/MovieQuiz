//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Nurbol on 03.07.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    private enum MovieError: LocalizedError {
        case networkError(Error)
        case decodingError(Error)
        case customError(String)
        
        fileprivate var errorDescription: String? {
            switch self {
            case .networkError(let error):
                return error.localizedDescription
            case .decodingError(let error):
                return "Failed to decode response: \(error.localizedDescription)"
            case .customError(let message):
                return message
            }
        }
    }
    
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if let errorMessage = mostPopularMovies.errorMessage, !errorMessage.isEmpty {
                        handler(.failure(MovieError.customError(errorMessage)))
                    } else {
                        handler(.success(mostPopularMovies))
                    }
                } catch {
                    handler(.failure(MovieError.decodingError(error)))
                }
            case .failure(let error):
                handler(.failure(MovieError.networkError(error)))
            }
        }
    }
}
