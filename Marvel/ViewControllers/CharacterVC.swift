//
//  HomeVC.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 25/08/21.
//

import UIKit

class CharacterVC: ParentViewController {
    
    @IBOutlet weak var searchStack: UIStackView!
    @IBOutlet weak var searchTFBack: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchStackWidth: NSLayoutConstraint!
    
    var characters: [MarvelCharacter]!
    var searchedCharacters: [MarvelCharacter] {
        guard let characters = characters else { return [] }
        return characters.filter { (character) -> Bool in
            let comicNames = character.comics.map { $0.name }
            return character.name.contains(find: searchText) || comicNames.contains(where:  { $0.contains(find: searchText) })
            
        }
    }
    var loadMore = LoadMore()
    var searchText: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
    var isSearching: Bool {
        return !searchText.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getCharacters(isInitialCall: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCharacterDetailVC" {
            let destVC = segue.destination as! CharacterDetailVC
            destVC.character = (sender as! MarvelCharacter)
        }
    }
}

// MARK: - IBAction(s)
extension CharacterVC {
    
    @IBAction func btnSearchTap() {
        if closeButton.isHidden {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let weakSelf = self else { return }
                weakSelf.searchStackWidth.constant = _width - 25
                weakSelf.closeButton.isHidden = false
                weakSelf.searchTF.isHidden = false
                weakSelf.searchTFBack.isHidden = false
                weakSelf.searchButton.isHidden = true
                weakSelf.view.layoutIfNeeded()
            } completion: { (_) in
                self.searchTF.becomeFirstResponder()
            }

        }
    }
    
    @IBAction func btnCloseTap() {
        searchText = ""
        searchTF.text = ""
        view.endEditing(true)
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.searchStackWidth.constant = 50
            weakSelf.closeButton.isHidden = true
            weakSelf.searchTF.isHidden = true
            weakSelf.searchTFBack.isHidden = true
            weakSelf.searchButton.isHidden = false
            weakSelf.view.layoutIfNeeded()
        }
    }
    
    @IBAction func tfSearchChange(tf: UITextField) {
        searchText = tf.text!.trimmedString()
    }
}

// MARK: - Utility method(s)
extension CharacterVC {
    
    func initialSetup() {
        tableView.register(NoDataTC.nib, forCellReuseIdentifier: NoDataTC.identifier)
        tableView.register(CharacterTC.nib, forCellReuseIdentifier: CharacterTC.identifier)
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 30, right: 0)
    }
    
    @objc func refreshCharacters() {
        loadMore = LoadMore()
        getCharacters()
    }
}

// MARK: - TableView method(s)
extension CharacterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if characters == nil {
            return 0
        } else {
            if isSearching {
                return searchedCharacters.isEmpty ? 1 : searchedCharacters.count
            } else {
                return characters.isEmpty ? 1 : characters.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            return searchedCharacters.isEmpty ? 300 : 66
        } else {
            return characters.isEmpty ? 300 : 66
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        if isSearching {
            identifier = searchedCharacters.isEmpty ? NoDataTC.identifier : CharacterTC.identifier
        } else {
            identifier = characters.isEmpty ? NoDataTC.identifier : CharacterTC.identifier
        }
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let noDataCell = cell as? NoDataTC {
            noDataCell.prepareUI(message: "No characters found")
        } else if let characterCell = cell as? CharacterTC {
            if isSearching {
                characterCell.prepareUI(character: searchedCharacters[indexPath.row])
            } else {
                characterCell.prepareUI(character: characters[indexPath.row])
            }
        }
        // for pagination
        if let characters = characters, !loadMore.isLoading && !characters.isEmpty && indexPath.row == characters.count - 1 && !loadMore.isAllLoaded {
            let paginationSpinner = UIActivityIndicatorView(style: .medium)
            paginationSpinner.color = AppColor.cEC1D24
            paginationSpinner.startAnimating()
            paginationSpinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            tableView.tableFooterView = paginationSpinner
            tableView.tableFooterView?.isHidden = false
            getCharacters()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        guard let characters = characters else { return }
        if isSearching {
            if !searchedCharacters.isEmpty {
                performSegue(withIdentifier: "segueCharacterDetailVC", sender: searchedCharacters[indexPath.row])
            }
        } else {
            if !characters.isEmpty {
                performSegue(withIdentifier: "segueCharacterDetailVC", sender: characters[indexPath.row])
            }
        }
        
    }
}

// MARK: - Search Header
extension CharacterVC: SearchHeaderDelegate {
    
    func didChange(text: String) {
        searchText = text
    }
}

// MARK: - API(s)
extension CharacterVC {
    
    
    func getCharacters(isInitialCall: Bool = false) {
        loadMore.isLoading = true
        if !refresh.isRefreshing && isInitialCall {
            showCentralSpinner()
        }
        let param: [String: Any] = ["limit": loadMore.limit, "offset": loadMore.offset]
        WebService.shared.getCharacters(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideCentralSpinner()
            weakSelf.refresh.endRefreshing()
            weakSelf.loadMore.isLoading = false
            weakSelf.tableView.tableFooterView?.isHidden = true
            weakSelf.tableView.tableFooterView = nil
            if statusCode == 200, let dict = json as? NSDictionary {
                if let dataDict = dict["data"] as? NSDictionary {
                    if let resultDict = dataDict["results"] as? [NSDictionary] {
                        if weakSelf.loadMore.index == 1 {
                            weakSelf.characters = []
                        }
                        if resultDict.isEmpty {
                            weakSelf.loadMore.isAllLoaded = true
                        } else {
                            for dict in resultDict {
                                weakSelf.characters.append(MarvelCharacter(dict: dict))
                            }
                            weakSelf.loadMore.index += 1
                        }
                        weakSelf.tableView.reloadData()
                    }
                }
            } else {
                weakSelf.showError(data: json)
                weakSelf.tableView.reloadData()
            }
        }
    }
}
