//
//  BeerType.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import Foundation

enum BeerType: String, Codable, CaseIterable, Comparable {
    static func < (lhs: BeerType, rhs: BeerType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case paleLager = "Lager"
    case lagerPilsen = "Lager Pilsen"
    case lagerEspecial = "Lager Especial"
    case lagerExtra = "Lager Extra"
    case ales = "Ale"
    case paleAle = "Pale Ale"
    case darkLager = "Cerveza Negra"
    case belgianAle = "Ale Belga"
    case germanAle = "Ale Alemana"
    case abbey = "Abadía"
}
