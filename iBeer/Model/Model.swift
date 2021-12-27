//
//  Model.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import Foundation

struct Model {
    static let shared = Model()
    private(set) var manufacturers = [Manufacturer]()
    
    init() {
        loadManufacturers()
    }
    
    // MARK: Methods to work with data.
    
    mutating func addManufacturer(_ manufacturer: Manufacturer) {
        guard !manufacturers.contains(manufacturer) else { return }
        manufacturers.append(manufacturer)
    }
    
    mutating func editManufacturer(_ manufacturer: Manufacturer) {
        guard let manufacturerIndex = manufacturers.firstIndex(of: manufacturer) else { return }
        manufacturers[manufacturerIndex] = manufacturer
    }
    
    mutating func removeManufacturer(_ manufacturer: Manufacturer) {
        guard let manufacturerIndex = manufacturers.firstIndex(of: manufacturer) else { return }
        manufacturers.remove(at: manufacturerIndex)
    }
    
    // MARK: Methods to load data.
    
    mutating func loadManufacturers() {
        do {
            self.manufacturers = try loadManufacturersFromDocuments()
            return
        } catch {
            print("ERROR: Couldn't load data from documents.")
        }
        
        do {
            self.manufacturers = try loadManufacturersFromBundle()
        } catch {
            print("ERROR: Couldn't load data from bundle.")
        }
    }
    
    private func loadManufacturersFromBundle() throws -> [Manufacturer] {
        let bundleURL = Constants.kBundle.url(forResource: Constants.kFileName, withExtension: Constants.kFileExtension)
        
        guard let bundleURL = bundleURL else { return [] }
        
        var documentLines = [String]()
        documentLines = try String(contentsOf: bundleURL).components(separatedBy: "\n")
        
        let manufacturers = documentLines.compactMap { Manufacturer(fromLine: $0) }
        return manufacturers

    }
    
    private func loadManufacturersFromDocuments() throws -> [Manufacturer] {
        let documentsURL = Constants.kFM.urls(for: .documentDirectory, in: .userDomainMask).first
        
        guard let documentsURL = documentsURL else { return [] }
        
        let manufacturersData = try Data(contentsOf: documentsURL)
        let decodedManufacturers = try JSONDecoder().decode([Manufacturer].self, from: manufacturersData)
        return decodedManufacturers
    }
    
    // MARK: Methods to save data.
    
    func saveManufacturers() {
        let documentsURL = Constants.kFM.urls(for: .documentDirectory, in: .userDomainMask).first
        
        guard let documentsURL = documentsURL else { return }
        
        do {
            let manufacturersFileURL = documentsURL.appendingPathComponent(Constants.kFullFileName)
            let encodedManufacturers = try JSONEncoder().encode(manufacturers)
            try encodedManufacturers.write(to: manufacturersFileURL, options: .atomic)
        } catch {
            print("ERROR: Couldn't save the data.")
        }
    }
}