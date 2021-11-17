//
//  M.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 17/11/2021.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = UsersViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showProfile(of user: User) {
        let vc = ProfileViewController.instantiate()
        vc.coordinator = self
        vc.user = user
        vc.note = CoreDataManager.shared.getNoteForUser(user)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
