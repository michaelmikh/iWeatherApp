//
//  Endpoint.swift
//  iWeatherApp
//
//  Created by Michael on 16.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIEndpoint {
    var urlComponent: URLComponents {
        var component = URLComponents(string: baseURL)
        component?.path = path
        component?.queryItems = queryItems
        
        return component!
    }
    
    var request: URLRequest {
        return URLRequest(url: urlComponent.url!)
    }
}
