//
//  CharacterDetailVC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class CharacterDetailVC: ParentViewController {
    
    var character: MarvelCharacter!
    let arrCell: [CharacterDetailCellType] = CharacterDetailCellType.allCases
    var comics: [ComicDetail]!
    lazy var comicCellWidth: CGFloat = (_width - 60) / 2
    lazy var comicCellHeight: CGFloat = comicCellWidth * 1.50

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueComicDetailVC" {
            let destVC = segue.destination as! ComicDetailVC
            destVC.comic = (sender as! Comic)
        }
    }
}

// MARK: - Utility method(s)
extension CharacterDetailVC {
    
    func initialSetup() {
        lblTitle?.text = character.name
        tableView.register(CharacterImageTC.nib, forCellReuseIdentifier: CharacterImageTC.identifier)
        tableView.register(DescriptionTC.nib, forCellReuseIdentifier: DescriptionTC.identifier)
        tableView.register(CharacterComicTC.nib, forCellReuseIdentifier: CharacterComicTC.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
}


// MARK: - TableView method(s)
extension CharacterDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrCell[indexPath.row] == .description {
            return character.descriptionCellHeight
        } else if arrCell[indexPath.row] == .comic {
            return character.comicCellHeight(individualCellHeight: comicCellHeight)
        } else {
            return arrCell[indexPath.row].cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: arrCell[indexPath.row].cellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageCell = cell as? CharacterImageTC {
            imageCell.prepareUI(thumbnail: character.thumbnail)
        } else if let descriptionCell = cell as? DescriptionTC {
            descriptionCell.prepareUI(description: character.displayDescription)
        } else if let comicCell = cell as? CharacterComicTC {
            comicCell.parentVC = self
            comicCell.cellWidth = comicCellWidth
            comicCell.cellHeight = comicCellHeight
            comicCell.comics = character.comics
            comicCell.collectionView.reloadData()
        }
    }
}
