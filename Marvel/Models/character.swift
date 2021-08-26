//
//  Character.swift
//  Marvel
//
//  Created by Yudiz Solutions Pvt. Ltd. on 25/08/21.
//

import UIKit

// MARK: - Image Varient
enum ImageVarient: String {
    case portrait_small, standard_small, standard_medium, standard_large, standard_xlarge, standard_fantastic, standard_amazing, landscape_incredible
}

// MARK: - Thumbnail
struct Image {
    let path: String
    let thumbnailExtension: String
    
    init(dict: NSDictionary) {
        path = dict.getStringValue(key: "path")
        thumbnailExtension = dict.getStringValue(key: "extension")
    }
    
    var standardSmallURL: URL? {
        return URL(string: path + "/\(ImageVarient.standard_small.rawValue)" + "." + thumbnailExtension)
    }
    var standartFantasticURL: URL? {
        return URL(string: path + "/\(ImageVarient.standard_fantastic.rawValue)" + "." + thumbnailExtension)
    }
    var landscapeIncredibleURL: URL? {
        return URL(string: path + "/\(ImageVarient.landscape_incredible.rawValue)" + "." + thumbnailExtension)
    }
}

// MARK: - Marvel Character
class MarvelCharacter {
    
    let id: String
    let name: String
    let description: String
    var thumbnail: Image?
    let resourceURI: String
    var comics: [Comic]
    
    var displayDescription: String {
        return description.isEmpty ? "No description available" : description
    }
    
    var descriptionCellHeight: CGFloat {
        let topSpace: CGFloat = 55
        let descriptionHeight: CGFloat = displayDescription.heightWithConstrainedWidth(width: _width - 40, font: AppFont.fontWithName(.book, size: 13))
        let bottomSpace: CGFloat = 30
        return topSpace + descriptionHeight + bottomSpace
    }
    
    func comicCellHeight(individualCellHeight: CGFloat)-> CGFloat {
        guard !comics.isEmpty else {
            return 100
        }
        let topSpace: CGFloat = 55
        let rows: Int = Int(ceil(Float(comics.count) / Float(2)))
        let comicsHeight: CGFloat = CGFloat(CGFloat(rows) * (individualCellHeight + CGFloat(20)))
        return topSpace + comicsHeight
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        description = dict.getStringValue(key: "description")
        if let thumbnailDict = dict["thumbnail"] as? NSDictionary {
            thumbnail = Image(dict: thumbnailDict)
        }
        resourceURI = dict.getStringValue(key: "resourceURI")
        comics = []
        if let comicDict = dict["comics"] as? NSDictionary {
            if let itemDict = comicDict["items"] as? [NSDictionary] {
                for dict in itemDict {
                    comics.append(Comic(dict: dict))
                }
            }
        }
    }
}


// MARK: - Character Detail Cell Type
enum CharacterDetailCellType: CaseIterable {
    case image, description, comic
    
    var cellIdentifier: String {
        switch self {
        case .image: return CharacterImageTC.identifier
        case .description: return DescriptionTC.identifier
        case .comic: return CharacterComicTC.identifier
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .image: return 300
        case .description, .comic: return 0
        }
    }
}
