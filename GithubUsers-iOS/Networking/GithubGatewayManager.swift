//
//  APIManger.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//

import Foundation


enum NetworkError: Error {
    case badURL
}

class GithubGatewayManager {
    static let shared = GithubGatewayManager()
    private let operationQueue: OperationQueue
    private let urlSession:URLSession
    
    private init() {
       operationQueue = OperationQueue()
        operationQueue.qualityOfService = .background
        operationQueue.maxConcurrentOperationCount = 1
        urlSession = .init(configuration: .default, delegate: nil, delegateQueue: operationQueue)
    }
    
    func getUsers<T: Codable>(params: [String: Any], completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        if let url = URL.with(string: Endpoints.allUsers.rawValue) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: String(describing: value))
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
            let urlRequest = URLRequest(url: components.url!)
            APICall(urlRequest: urlRequest, completionHandler: completionHandler)
            
        } else {
            completionHandler(.failure(NetworkError.badURL))
        }
    }
    
    
    func getUserProfile<T: Codable>(username: String, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        if let url = URL.with(string: Endpoints.singleUser.rawValue + username) {
            let urlRequest = URLRequest(url: url)
            APICall(urlRequest: urlRequest, completionHandler: completionHandler)
        } else {
            completionHandler(.failure(NetworkError.badURL))
        }
    }
    
    private func APICall<T: Codable>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, Error>) -> Void) {
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(response))
                } catch let error {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
        
    }
}
