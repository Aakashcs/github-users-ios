//
//  Cordinator.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 17/11/2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
