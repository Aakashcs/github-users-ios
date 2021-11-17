//
//  CustomImageLoader.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 13/11/2021.
//

import Foundation
import UIKit
import Combine

class CustomImageLoader {
    
    static let shared = CustomImageLoader()
    
    private let cache: ImageCache
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    init(cache: ImageCache = ImageCacheHelper()) {
        self.cache = cache
    }
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
            if let image = cache[url] {
                return Just(image).eraseToAnyPublisher()
            }
        
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { (data, response) -> UIImage? in return UIImage(data: data) }
                .catch { error in return Just(nil) }
                .handleEvents(receiveOutput: {[unowned self] image in
                    guard let image = image else { return }
                    self.cache[url] = image
                })
                .subscribe(on: backgroundQueue)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
}

