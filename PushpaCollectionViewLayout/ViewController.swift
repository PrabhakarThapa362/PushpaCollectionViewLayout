//
//  ViewController.swift
//  PushpaCollectionViewLayout
//
//  Created by Canopas on 19/10/18.
//  Copyright © 2018 Canopas Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var colors: [UIColor]  = [
        UIColor(red: 137, green: 50, blue: 90),
        UIColor(red: 149, green: 120, blue: 92),
        UIColor(red: 194, green: 134, blue: 89),
        UIColor(red: 1, green: 25, blue: 54),
        UIColor(red: 155, green: 84, blue: 109)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! PushpaCollectionViewLayout
        layout.itemSize = CGSize(width: collectionView.frame.width - 100, height: collectionView.frame.width + 100)
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255 ,
                  green: CGFloat(green)/255,
                  blue: CGFloat(blue)/255,
                  alpha: 1.0)
    }
}
