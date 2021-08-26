//
//  CharacterComicTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class CharacterComicTC: ParentTC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var parentVC: CharacterDetailVC!
    var comics: [Comic]!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ComicCC.nib, forCellWithReuseIdentifier: ComicCC.identifier)
        collectionView.register(NoDataCC.nib, forCellWithReuseIdentifier: NoDataCC.identifier)
    }
}

// MARK: - CollectionView method(s)
extension CharacterComicTC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comics.isEmpty ? 1 : comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return comics.isEmpty ? UIEdgeInsets.zero : UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return comics.isEmpty ? CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height) : CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = comics.isEmpty ? NoDataCC.identifier : ComicCC.identifier
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let noDataCell = cell as? NoDataCC {
            noDataCell.prepareUI(message: "No comics found")
        } else if let comicCell = cell as? ComicCC {
            comicCell.comic = comics[indexPath.row]
            comicCell.prepareUI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentVC.performSegue(withIdentifier: "segueComicDetailVC", sender: comics[indexPath.row])
    }
}
