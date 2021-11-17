//
//  BaseUnitTests.swift
//  GithubUsers-iOSTests
//
//  Created by Aakash on 18/11/2021.
//

import XCTest
@testable import GithubUsers_iOS


class BaseUnitTests: XCTestCase {

    // MARK: - Properties
    var usersViewController: UsersViewController!
    
    // MARK: - Functions
    // MARK: Overrides
    override func setUp() {
        usersViewController = UsersViewController()
    }
}
