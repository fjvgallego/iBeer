//
//  OnlineBeer.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 16/1/22.
//

import Foundation

struct OnlineBeer: Decodable {
    let name: String
    let abv: Double
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case abv
        case imageURL = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.abv = try container.decode(Double.self, forKey: CodingKeys.abv)
        self.imageURL = try container.decode(String.self, forKey: CodingKeys.imageURL)
    }
}
