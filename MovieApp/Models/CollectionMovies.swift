//
//  CollectionMovies.swift
//  MovieApp
//
//  Created by Madan on 21/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

struct CollectionMovies:Codable {
    
    struct Parts:Codable{
        let id:Int64
        let posterPath:String?
        
        enum CodingKeys : String, CodingKey {
            case id
            case posterPath = "poster_path"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(Int64.self, forKey: .id)
            posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        }
    }
    let parts:[Parts]?
    
    enum CodingKeys :String, CodingKey {
        case parts
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        parts = try values.decode([Parts].self, forKey: .parts)
    }

}
