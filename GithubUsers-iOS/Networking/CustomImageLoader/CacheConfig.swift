//
//  CacheConfig.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 13/11/2021.
//

import Foundation

struct CacheConfig {
    let countLimit: Int
    let memoryLimit: Int

    static let defaultConfig = CacheConfig(countLimit: 200, memoryLimit: 1024 * 1024 * 50) // 50 MB
}
