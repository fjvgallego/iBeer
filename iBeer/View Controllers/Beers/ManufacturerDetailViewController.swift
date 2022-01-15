//
//  ManufacturerDetailViewController.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import UIKit

class ManufacturerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var establishmentDateLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var numberOfBeersLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: Variables
    
    var manufacturer: Manufacturer! {
        didSet {
            numberOfBeersLabel.text = "\(manufacturer.beers.count)"
            
            switch orderType {
            case .name:
                manufacturer.beers.sort { $0.name > $1.name }
            case .calories:
                manufacturer.beers.sort { $0.calories > $1.calories }
            case .abv:
                manufacturer.beers.sort { $0.abv > $1.abv }
            }
            
            Model.shared.updateManufacturer(manufacturer)
        }
    }
    
    var orderType = OrderType.name {
        didSet {
            switch orderType {
            case .name:
                manufacturer.beers.sort { $0.name > $1.name }
            case .calories:
                manufacturer.beers.sort { $0.calories > $1.calories }
            case .abv:
                manufacturer.beers.sort { $0.abv > $1.abv }
            }
            
            orderByButton.setTitle("Ordenar por: \(orderType.rawValue)", for: .normal)
        }
    }
    
    // MARK: Methods
    
    init?(coder: NSCoder, manufacturer: Manufacturer) {
        self.manufacturer = manufacturer
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let logoData = manufacturer.logoData, let image = UIImage(data: logoData) {
            logoImageView.image = image
        } else {
            logoImageView.image = UIImage(named: Constants.kUnknownImageName)!
        }

        tableView.delegate = self
        tableView.dataSource = self
        
        nameLabel.text = manufacturer.name
        establishmentDateLabel.text = manufacturer.formattedEstablishmentDate
        numberOfBeersLabel.text = "\(manufacturer.beers.count)"
        originLabel.text = manufacturer.origin.rawValue
        orderByButton.setTitle("Ordenar por: \(orderType.rawValue)", for: .normal)
    }
    
    // Support methods
    
    func getBeersForSection(_ section: Int) -> [Beer] {
        let type = BeerType.allCases[section]
        let filteredBeers = manufacturer.beers.filter { $0.type == type }
        return filteredBeers
    }
    
    // Outlet actions
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let isEditing = tableView.isEditing
        editButton.title = !isEditing ? "Hecho" : "Editar"
        tableView.setEditing(!isEditing, animated: true)
    }
    
    @IBAction func addBeerTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Tipo de Cerveza", message: "Elige un tipo de cerveza.", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = sender
        
        for type in BeerType.allCases {
            alertController.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { [weak self] _ in
                self?.manufacturer.addBeer(Beer(name: "Nueva Cerveza", abv: 0.0, calories: 0, type: type, imageData: nil))
                
                let beerTypeIndex = BeerType.allCases.firstIndex(of: type)!
                self?.tableView.reloadSections([beerTypeIndex], with: .automatic)
            }))
        }
        
        present(alertController, animated: true)
    }
    
    @IBAction func orderByTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Elige el filtro", message: "El orden se hará de mayor a menor.", preferredStyle: .actionSheet)
        
        alertController.popoverPresentationController?.sourceView = sender
        
        alertController.addAction(UIAlertAction(title: "Nombre", style: .default, handler: { [weak self] _ in
            self?.orderType = .name
            self?.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Aporte calórico", style: .default, handler: { [weak self] _ in
            self?.orderType = .calories
            self?.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Graduación", style: .default, handler: { [weak self] _ in
            self?.orderType = .abv
            self?.tableView.reloadData()
        }))
        
        present(alertController, animated: true)
    }
    
    
    @IBSegueAction func beerSegue(_ coder: NSCoder, sender: Any?) -> EditBeerTableViewController? {
        if let cell = sender as? UITableViewCell {
            let cellIndexPath = tableView.indexPath(for: cell)!
            let cellBeer = getBeersForSection(cellIndexPath.section)[cellIndexPath.row]
            return EditBeerTableViewController(coder: coder, beer: cellBeer)
        }
        
        return nil
    }
    
    
    @IBAction func unwindToManufacturerDetailViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveBeerUnwind",
              let sourceView = segue.source as? EditBeerTableViewController else { return }
        
        if let _ = tableView.indexPathForSelectedRow {
            let beer = sourceView.beer
            manufacturer.updateBeer(beer)
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        BeerType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        BeerType.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = BeerType.allCases[section]
        return manufacturer.beers.filter { $0.type == type }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell") as! BeerTableViewCell
        
        let type = BeerType.allCases[indexPath.section]
        let beer = manufacturer.beers.filter { $0.type == type }[indexPath.row]
        
        let name = beer.name
        let imageData = beer.imageData
        
        cell.configure(name: name, logoData: imageData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let beerToDelete = getBeersForSection(indexPath.section)[indexPath.row]
            manufacturer.removeBeer(beerToDelete)
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }
}
