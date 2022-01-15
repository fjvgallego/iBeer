//
//  ManufacturersViewController.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import UIKit

class ManufacturersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Support methods
    
    private func getManufacturersForSection(_ section: Int) -> [Manufacturer] {
        let origin = Origin.allCases[section]
        let filteredManufacturers = Model.shared.getManufacturersForOrigin(origin)
        return filteredManufacturers
    }
    
    // Outlet actions
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let isEditing = tableView.isEditing
        editButton.title = !isEditing ? "Hecho" : "Editar"
        tableView.setEditing(!isEditing, animated: true)
    }
    
    @IBAction func unwindToManufacturersViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveManufacturerUnwind",
              let sourceViewController = segue.source as? AddManufacturerTableViewController,
              let manufacturer = sourceViewController.manufacturer else { return }
        
        let section = Origin.allCases.firstIndex(of: manufacturer.origin)!
        let row = getManufacturersForSection(section).count
        let newIndexPath = IndexPath(row: row, section: section)
        
        Model.shared.addManufacturer(manufacturer)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    @IBSegueAction func seeManufacturerSegue(_ coder: NSCoder, sender: Any?) -> ManufacturerDetailViewController? {
        if let cell = sender as? UITableViewCell {
            let cellIndexPath = tableView.indexPath(for: cell)!
            let cellManufacturer = getManufacturersForSection(cellIndexPath.section)[cellIndexPath.row]
            return ManufacturerDetailViewController(coder: coder, manufacturer: cellManufacturer)
        }
        
        return nil
    }
    
    // TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Origin.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Origin.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredManufacturers = getManufacturersForSection(section)
        return filteredManufacturers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManufacturerCell", for: indexPath) as! ManufacturerTableViewCell
        
        let filteredManufacturers = getManufacturersForSection(indexPath.section)
        let manufacturerForCell = filteredManufacturers[indexPath.row]
        
        let name = manufacturerForCell.name
        let formattedEstablishmentDate = manufacturerForCell.formattedEstablishmentDate
        let logoData = manufacturerForCell.logoData
        
        cell.configure(name: name, formattedEstablishmentDate: formattedEstablishmentDate, logoData: logoData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let manufacturerToDelete = getManufacturersForSection(indexPath.section)[indexPath.row]
            Model.shared.removeManufacturer(manufacturerToDelete)
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }
}
