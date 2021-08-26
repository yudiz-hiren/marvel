//
//  ComicCreatorTC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class ComicCreatorTC: ParentTC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var parentVC: ComicDetailVC!
    var creators: [ComicCreator]!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ComicCreatorCC.nib, forCellWithReuseIdentifier: ComicCreatorCC.identifier)
        collectionView.register(NoDataCC.nib, forCellWithReuseIdentifier: NoDataCC.identifier)
    }
}

// MARK: - CollectionView method(s)
extension ComicCreatorTC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creators.isEmpty ? 1 : creators.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return creators.isEmpty ? UIEdgeInsets.zero : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return creators.isEmpty ? CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height) : CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = creators.isEmpty ? NoDataCC.identifier : ComicCreatorCC.identifier
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let noDataCell = cell as? NoDataCC {
            noDataCell.prepareUI(message: "No creator found")
        } else if let comicCell = cell as? ComicCreatorCC {
            comicCell.creator = creators[indexPath.row]
            comicCell.prepareUI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
