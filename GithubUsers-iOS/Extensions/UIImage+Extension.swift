//
//  UIImage+Extension.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 17/11/2021.
//

import UIKit

extension UIImageView {
    func loadAnimatedImage(image: UIImage, inverted: Bool) {
        
        alpha = 0.0
        self.image = image
        
        if inverted,
           let filter = CIFilter(name: "CIColorInvert"),
           let ciimage = CIImage(image: image) {
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            let invertedImage = UIImage(ciImage: filter.outputImage!)
            self.image = invertedImage
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent, animations: {
            self.alpha = 1.0
            
        })
    }
    
}
