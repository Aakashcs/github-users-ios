//
//  URL+Extension.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//

import Foundation

extension URL {
    private static var baseUrl: String {
        return "https://api.github.com/"
    }
    
    static func with(string: String) -> URL? {
        return URL(string: "\(baseUrl)\(string)")
    }
}
