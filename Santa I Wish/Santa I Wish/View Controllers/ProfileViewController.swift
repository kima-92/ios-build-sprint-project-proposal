//
//  ProfileViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
    }
    let childrenNames = ["kora"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCollectionView.reloadData()
    }

    @IBOutlet var profileCollectionView: UICollectionView!
    
    private func configureViews() {
        navigationController?.navigationBar.isHidden = true
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
    }

}

extension ProfileViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childrenNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell()}
        let childName = childrenNames[indexPath.item]
        cell.childNameLabel.text = childName
        return cell
    }
    
}
