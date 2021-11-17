//
//  UserTableViewCell.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 16/11/2021.
//

import UIKit

class InvertedUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var detailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension InvertedUserTableViewCell: CellConfigurable {
    
    typealias Item = User
    func configure(with item: User) {
        usernameLbl.text = item.username
        detailsLbl.text = "Node ID: \(item.nodeId ?? "")"
        if let avatarUrl = item.avatarUrl,
           let url = URL(string: avatarUrl) {
            CustomImageLoader.shared.loadImage(from: url).sink { [weak self] image in
                self?.profileImageView.loadAnimatedImage(image: image ?? UIImage(), inverted: true)
            }
        }
    }
}

