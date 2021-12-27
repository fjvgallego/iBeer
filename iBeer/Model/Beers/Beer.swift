//
//  Beer.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import Foundation

struct Beer: Codable, Equatable {
    static func ==(lhs: Beer, rhs: Beer) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var name: String
    var abv: Double
    var calories: Double
    var type: BeerType
    var imageData: Data?
    
    init(name: String, abv: Double, calories: Double, type: BeerType, imageData: Data? = nil) {
        self.name = name
        self.abv = abv
        self.calories = calories
        self.type = type
        self.imageData = imageData
    }
    
    init?(fromLine line: String) {
        let mainFields = line.components(separatedBy: ";")
        
        guard mainFields.count == 5,
              let abv = Double(mainFields[1]),
              let calories = Double(mainFields[2]),
              let type = BeerType(rawValue: mainFields[3]) else { return nil }
        
        self.name = mainFields[0]
        self.abv = abv
        self.calories = calories
        self.type = type
        self.imageData = mainFields[4].data(using: .utf8)
    }
}
