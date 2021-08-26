//
//  comic.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 26/08/21.
//

import UIKit

// MARK: - Comic
class Comic {
    
    let name: String
    let resourceURI: String
    var detail: ComicDetail?
    
    init(dict: NSDictionary) {
        name = dict.getStringValue(key: "name")
        resourceURI = dict.getStringValue(key: "resourceURI")
    }
}

// MARK: - Comic Detail
struct ComicDetail {
    let id: String
    let title: String
    let description: String
    var thumbnail: Image?
    var images: [Image]
    var creators: [ComicCreator]
    
    var displayDescription: String {
        return description.isEmpty ? "No description available" : description
    }
    
    var descriptionCellHeight: CGFloat {
        let topSpace: CGFloat = 55
        let descriptionHeight: CGFloat = displayDescription.heightWithConstrainedWidth(width: _width - 40, font: AppFont.fontWithName(.book, size: 13))
        let bottomSpace: CGFloat = 30
        return topSpace + descriptionHeight + bottomSpace
    }
    
    func creatorCellHeight(creatorsHeight: CGFloat)-> CGFloat {
        guard !creators.isEmpty else {
            return 100
        }
        let topSpace: CGFloat = 55
        return topSpace + creatorsHeight
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        title = dict.getStringValue(key: "title")
        description = dict.getStringValue(key: "description")
        if let thumbnailDict = dict["thumbnail"] as? NSDictionary {
            thumbnail = Image(dict: thumbnailDict)
        }
        images = []
        if let imageDict = dict["images"] as? [NSDictionary] {
            for dict in imageDict {
                images.append(Image(dict: dict))
            }
        }
        creators = []
        if let creatorDict = dict["creators"] as? NSDictionary {
            if let itemDict = creatorDict["items"] as? [NSDictionary] {
                for dict in itemDict {
                    creators.append(ComicCreator(dict: dict))
                }
            }
        }
    }
}

// MARK: - Comic Creator
class ComicCreator {
    
    let name: String
    let role: String
    let resourceURI: String
    var detail: ComicCreatorDetail?
    
    init(dict: NSDictionary) {
        name = dict.getStringValue(key: "name")
        role = dict.getStringValue(key: "role")
        resourceURI = dict.getStringValue(key: "resourceURI")
    }
}

// MARK: - Creator Detail
struct ComicCreatorDetail {
    
    var thumbnail: Image?
    
    init(dict: NSDictionary) {
        if let thumbnailDict = dict["thumbnail"] as? NSDictionary {
            thumbnail = Image(dict: thumbnailDict)
        }
    }
}

// MARK: - Comic Detail Cell Type
enum ComicDetailCellType: CaseIterable {
    case image, description, creator
    
    var cellIdentifier: String {
        switch self {
        case .image: return ComicImageTC.identifier
        case .description: return DescriptionTC.identifier
        case .creator: return ComicCreatorTC.identifier
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .image: return 260 * _widthRatio
        case .description, .creator: return 0
        }
    }
}
