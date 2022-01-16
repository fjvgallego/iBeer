//
//  Constants.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import Foundation

struct Constants {
    static let kFileName = "appdata"
    static let kFileExtension = ".txt"
    static var kFullFileName: String { kFileName + kFileExtension }
    static let kFM = FileManager.default
    static let kBundle = Bundle.main
    static let kUnknownImageName = "unknown-logo"
}
