//
//  UI+Extension.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 14/11/2021.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({self.addSubview($0)})
    }
}
