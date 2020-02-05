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
    var childName: String? {
        didSet {
            updateViews()
            styleCellBorder()
        }
    }
    
    override func awakeFromNib() {
        styleCellBorder()
    }
    private func updateViews() {
        guard let child = childName else { return }
        childNameLabel.text = child
    }
    
    private func styleCellBorder() {
        self.layer.cornerRadius = 20
    }
}
