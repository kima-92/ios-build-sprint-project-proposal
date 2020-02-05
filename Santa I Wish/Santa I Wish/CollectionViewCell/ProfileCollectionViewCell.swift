//
//  ProfileCollectionViewCell.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childAge: UILabel!
    @IBOutlet weak var lettersToSanta: UILabel!
    @IBOutlet weak var wishLists: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var child: Child? {
        didSet {
            updateViews()
            styleCellBorder()
        }
    }
    
    override func awakeFromNib() {
        styleCellBorder()
    }
    private func updateViews() {
        guard let child = child else { return }
        childNameLabel.text = child.name
        childAge.text = "age: \(child.age ?? "unavailable")"
        lettersToSanta.text = "Letters to santa \(child.letters?.count ?? 0)"
        wishLists.text = "wishlists \(child.items?.count ?? 0)"
        profileImage.image = UIImage(named: "profilePic")
    }
    
    private func styleCellBorder() {
        self.layer.cornerRadius = 20
    }
}
