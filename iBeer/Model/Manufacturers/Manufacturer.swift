//
//  Manufacturer.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import Foundation

struct Manufacturer: Codable, Equatable {
    static func ==(lhs: Manufacturer, rhs: Manufacturer) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    let name: String
    let establishmentDate: Date
    var formattedEstablishmentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: establishmentDate)
    }
    let logoData: Data?
    let origin: Origin
    var beers: [Beer]
    
    init(name: String, establishmentDate: Date, logoData: Data? = nil, origin: Origin, beers: [Beer]) {
        self.name = name
        self.establishmentDate = establishmentDate
        self.logoData = logoData
        self.origin = origin
        self.beers = beers
    }
    
    init?(fromLine line: String) {
        let mainFields = line.components(separatedBy: "#")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        guard mainFields.count == 5,
              let establishmentDate = dateFormatter.date(from: mainFields[1]),
              let origin = Origin(rawValue: mainFields[3]) else { return nil }
        
        self.name = mainFields[0]
        self.establishmentDate = establishmentDate
        self.logoData = mainFields[2].data(using: .utf8)
        self.origin = origin
        self.beers = mainFields[4].components(separatedBy: "\t").compactMap { Beer(fromLine: $0) }
    }
}
