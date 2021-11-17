//
//  ProfileViewController.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 17/11/2021.
//

import UIKit

class ProfileViewController: UIViewController, Storyboarded {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var blogLbl: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    
    var note: Note?
    var user: User?
    weak var coordinator: MainCoordinator?
    
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user,
              let username = user.username else {
            coordinator?.pop(animated: true)
            return
            
        }
        
        setupView()
        title = user.username
        getUserProfile(username: username)
        loadNote()
        
    }
    
    func loadNote(){
        notesTextView.text = note?.note ?? ""
    }
    
    func setupView(){
        infoView.layer.borderWidth = 1
        infoView.layer.borderColor = UIColor.gray.cgColor
        
        
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func onSave(_ sender: Any) {
        if notesTextView.text?.isEmpty ?? true{
            coordinator?.pop(animated: true)
            return
        }
        
        guard let user = user else {
            coordinator?.pop(animated: true)
            return
        }
        
        if let note = note {
            note.note = notesTextView.text
        } else {
            
            let note = Note(context: CoreDataManager.shared.persistentContainer.viewContext)
            note.note = notesTextView.text
            note.userId = user.id
        }
        
        CoreDataManager.shared.saveContext()
        coordinator?.pop(animated: true)
    }
    
    func getUserProfile(username: String){
        showLoader()
        GithubGatewayManager.shared.getUserProfile(username: username) { [weak self] (result: Result<UserProfile, Error>) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.onProfileResponse(profile: profile)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.onAPIError(error: error)
                }
            }
        }
    }
    
    func showLoader(){
        spinner.color = .blue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
    }
    
    func hideLoader(){
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    func onProfileResponse(profile: UserProfile){
        hideLoader()
        
        nameLbl.text = "Name: \(profile.name ?? "")"
        followersLbl.text = "Followers: \(profile.followers ?? 0)"
        followingLbl.text = "Following: \(profile.following ?? 0)"
        companyLbl.text = "Company: \(profile.company ?? "")"
        blogLbl.text = "Blog: \(profile.blog ?? "")"
        
        if let avatarUrl = profile.avatarUrl,
           let url = URL(string: avatarUrl) {
            CustomImageLoader.shared.loadImage(from: url).sink { [weak self] image in
                self?.profileImage.loadAnimatedImage(image: image ?? UIImage(), inverted: false)
            }
        }
    }
    
    
    func showNoInternetView(){
        
    }
    
    func onAPIError(error: Error) {
        hideLoader()
        showNoInternetView()
    }
}
