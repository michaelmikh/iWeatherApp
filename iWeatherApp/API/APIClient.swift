//
//  APIClient.swift
//  iWeatherApp
//
//  Created by Michael on 15.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import Foundation

enum Either<T, E: Error> {
    case value(T)
    case error(E)
}

enum APIError: Error {
    case apiError
    case responseError
    case jsonDecodeError
    case undefinedError
}

protocol APIClient {
    var session: URLSession { get }
    func fetch<T: Codable>(with request: URLRequest, completion: @escaping (Either<T, APIError>) -> Void)
}

extension APIClient {
    func fetch<T: Codable>(with request: URLRequest, completion: @escaping (Either<T, APIError>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.error(.apiError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.error(.responseError))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            guard let value = try? decoder.decode(T.self, from: data!) else {
                completion(.error(.jsonDecodeError))
                return
            }

            completion(.value(value))
        }
        
        task.resume()
    }
}
