//
//  ComicDetailVC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

class ComicDetailVC: ParentViewController {
    
    var comic: Comic!
    let cells: [ComicDetailCellType] = ComicDetailCellType.allCases
    lazy var creatorCellWidth: CGFloat = (_width - 40) / 3
    lazy var creatorCellHeight: CGFloat = creatorCellWidth * 1.50

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

// MARK: - Utility method(s)
extension ComicDetailVC {
    
    func initialSetup() {
        lblTitle?.text = comic.name
        tableView.register(ComicImageTC.nib, forCellReuseIdentifier: ComicImageTC.identifier)
        tableView.register(DescriptionTC.nib, forCellReuseIdentifier: DescriptionTC.identifier)
        tableView.register(ComicCreatorTC.nib, forCellReuseIdentifier: ComicCreatorTC.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
}

// MARK: - TableView method(s)
extension ComicDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cells[indexPath.row] == .description {
            return comic.detail?.descriptionCellHeight ?? 0
        } else if cells[indexPath.row] == .creator {
            return comic.detail?.creatorCellHeight(creatorsHeight: creatorCellHeight) ?? 100
        }
        else {
            return cells[indexPath.row].cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].cellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageCell = cell as? ComicImageTC {
            imageCell.urls = comic.detail?.images.map({ $0.landscapeIncredibleURL })
            imageCell.collectionView.reloadData()
        } else if let descriptionCell = cell as? DescriptionTC {
            descriptionCell.prepareUI(description: comic.detail?.displayDescription ?? "")
        } else if let creatorCell = cell as? ComicCreatorTC {
            creatorCell.cellHeight = creatorCellHeight
            creatorCell.cellWidth = creatorCellWidth
            creatorCell.creators = comic.detail?.creators
            creatorCell.collectionView.reloadData()
        }
    }
}
