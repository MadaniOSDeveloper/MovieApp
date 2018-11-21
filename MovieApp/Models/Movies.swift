//
//  Movies.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
struct Movies:Codable{
    
    struct Movie : Codable{
        let title:String?
        let id:Int64
        let posterPath:String?
        enum CodingKeys : String, CodingKey {
            case title = "title"
            case id =  "id"
            case posterPath = "poster_path"
            
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            id = try values.decode(Int64.self, forKey: .id)
            posterPath = try values.decode(String.self, forKey: .posterPath)
        }
    }
    let result:[Movie]?
    let page: Int
    
    enum CodingKeys :String, CodingKey {
        case result = "results"
        case page = "page"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decode([Movie].self, forKey: .result)
        page = try values.decode(Int.self, forKey: .page)
        
    }
}
