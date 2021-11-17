//
//  ViewController.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 13/11/2021.
//

import UIKit

class UsersViewController: UITableViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    private var lastSeenId: Int32 = 0
    
    var users: [User] = [User]()
    var filteredUsers: [User] = [User]()
    var usersLoadedFromDB: Bool = true
    var filteredApplied:Bool = false
    
    lazy var refreshControlK: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .label
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.label,
            .font: UIFont.systemFont(ofSize: 15.0)
        ]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refreshUsers(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var noInternetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.text = "No internet connection"
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addPullToRefresh()
        
        let cells = [UserTableViewCell.self, InvertedUserTableViewCell.self, UserNoteTableViewCell.self]
        cells.forEach { cell in
            tableView.register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell.self))
            
        }
        
        loadLocalUsersIfAny()
        loadUsersFromAPI()
        configureReachabilityObserver()

    }
    
    
    
    @objc func refreshUsers(_ sender: AnyObject) {
        lastSeenId = 0
        usersLoadedFromDB = true
        loadUsersFromAPI()
    }
    
    func loadUsersFromAPI() {
        
        if !ReachabilityManager.shared.isReachable {
            removeTableViewLoadingFooter()
            setIsRefreshing(false)
            showNoInternetView()
            ReachabilityManager.shared.startObserver()
            return
        }
        
        GithubGatewayManager.shared.getUsers(params: ["since": lastSeenId]) { [weak self] (result: Result<[User], Error>) in
            
            DispatchQueue.main.async {
                self?.setIsRefreshing(false)
                self?.removeTableViewLoadingFooter()
                
                switch result {
                case .success(let users):
                    self?.onUsersResponse(users: users)
                    print(users.count)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.onAPIError(error: error)
                    
                }
            }
        }
    }
    
    func setIsRefreshing(_ isRefreshing: Bool) {
        DispatchQueue.main.async {
            isRefreshing ? self.refreshControlK.beginRefreshing() : self.refreshControlK.endRefreshing()
        }
    }
    
    func onUsersResponse(users: [User]) {
        if usersLoadedFromDB {
            deleteAllDBUsers()
            self.users = users
            saveLocalDB()
            tableView.reloadData()
            usersLoadedFromDB = false
        } else {
            self.users.append(contentsOf: users)
            tableView.reloadData()
        }
        if let last = users.last {
            lastSeenId = last.id
            print(last.id)
        }
    }
    
    func deleteAllDBUsers() {
        CoreDataManager.shared.deleteAllUsers()
    }
    
    func onAPIError(error: Error) {
        showNoInternetView()
    }
    
    func showNoInternetView(){
        if users.count == 0 {
            noInternetLabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(50))
            tableView.tableFooterView = noInternetLabel
        }
    }
    
    func saveLocalDB(){
        try? CoreDataManager.shared.persistentContainer.viewContext.save()
    }
    
    func loadLocalUsersIfAny(){
        do {
            let req = User.fetchRequest()
            let users = try CoreDataManager.shared.persistentContainer.viewContext.fetch(req)
            
            if users.count > 0 {
                self.users = users
                usersLoadedFromDB = true
                tableView.reloadData()
                print("DB users: \(users.count)")
            }
        } catch {
            print("error")
        }
    }
    
    func addPullToRefresh() {
        tableView.refreshControl = refreshControlK
    }
    
    func setup() {
        title = "Users"
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        coordinator?.navigationController.navigationBar.topItem?.searchController = searchController
        coordinator?.navigationController.navigationBar.prefersLargeTitles = true
        coordinator?.navigationController.navigationItem.hidesSearchBarWhenScrolling = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func showTableViewLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(50))
        tableView.tableFooterView = spinner
    }
    
    func removeTableViewLoadingFooter(){
        self.tableView.tableFooterView = nil
    }
    
    
}

extension UsersViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredApplied ? filteredUsers.count :users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = filteredApplied ? filteredUsers[indexPath.row] :users[indexPath.row]
        if (indexPath.row + 1) % 4 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InvertedUserTableViewCell.self), for: indexPath) as? InvertedUserTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(with: user)
            return cell
        }
        
        if let note = CoreDataManager.shared.getNoteForUser(user){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserNoteTableViewCell.self), for: indexPath) as? UserNoteTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(with: user)
            cell.note = note
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self), for: indexPath) as? UserTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showProfile(of: filteredApplied ? filteredUsers[indexPath.row] : users[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if filteredApplied {
            return
        }
        
        if indexPath.row == (users.count - 1) && !usersLoadedFromDB {
            showTableViewLoadingFooter()
            loadUsersFromAPI()
        }
    }
}

extension UsersViewController {
    private func configureReachabilityObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusNotification(notification:)), name: .networkStatusNotification, object: nil)
    }
    
    @objc private func networkStatusNotification(notification: NSNotification) {
        guard let isConnected = notification.object as? Bool else { return }
        
        if isConnected {
            tableView.tableHeaderView = nil
            loadUsersFromAPI()
        }
    }
    
    func search(with text: String){
       
        let notes = CoreDataManager.shared.getUsers(with: text)
        filteredUsers = self.users.filter({ (user) -> Bool in
            let hasName = user.username?.lowercased().contains(text.lowercased()) ?? false
            let hasNote = notes.contains(where: {$0.userId == user.id})
            return hasName || hasNote
        })
        
        filteredApplied = true
        tableView.reloadData()
    }
}


extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            search(with: text)
        } else {
            self.filteredApplied = false
            self.filteredUsers = [User]()
        }
    }
}
