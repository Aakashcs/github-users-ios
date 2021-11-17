//
//  GithubUsers_iOSTests.swift
//  GithubUsers-iOSTests
//
//  Created by Aakash on 13/11/2021.
//

import XCTest
@testable import GithubUsers_iOS

class UsersViewControllerTests: BaseUnitTests {
    
    func testSearchResult() {
        XCTAssertNotNil(usersViewController.users, "Users object must not be nil.")
    }
    
    func testSearchAppliedNotTrueAtStart(){
        XCTAssertFalse(usersViewController.filteredApplied, "Filters should not be applied at start")
    }

    func testFilters(){
        XCTAssertNotNil(usersViewController.search(with:"aakash"), "Search results should not be nil, but can be empty.")
    }
}
