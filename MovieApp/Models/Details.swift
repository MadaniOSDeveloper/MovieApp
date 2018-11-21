//
//  Details.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
struct Details:Codable{
    
    struct BelongsToCollection : Codable {
        let collectionId:Int64
        enum CodingKeys :String, CodingKey {
            case collectionId = "id"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            collectionId = try values.decode(Int64.self, forKey: .collectionId)
        }
    }
    let title:String?
    let id:Int64
    let posterPath:String?
    let belongsToCollection:BelongsToCollection?
    let overview:String?
    let releaseDate:String?
    let popularity:Double?
    
    enum CodingKeys : String, CodingKey {
        case title = "title"
        case id =  "id"
        case posterPath = "poster_path"
        case belongsToCollection = "belongs_to_collection"
        case overview = "overview"
        case releaseDate = "release_date"
        case popularity = "popularity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        id = try values.decode(Int64.self, forKey: .id)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        
        belongsToCollection = try values.decodeIfPresent(BelongsToCollection.self, forKey: .belongsToCollection)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
    }
}
