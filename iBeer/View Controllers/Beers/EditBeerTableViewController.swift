//
//  EditBeerTableViewController.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import UIKit

class EditBeerTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var abvStepper: UIStepper!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriesStepper: UIStepper!
    
    @IBOutlet weak var beerTypePicker: UIPickerView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var beer: Beer
    
    var name: String { nameTextField.text ?? "" }
    var abv: Double { abvStepper.value }
    var calories: Double { caloriesStepper.value }
    var beerType: BeerType { BeerType.allCases[beerTypePicker.selectedRow(inComponent: 0)] }
    var imageData: Data? { photoImageView.image?.pngData() }
    
    // MARK: Methods
    
    init?(coder: NSCoder, beer: Beer) {
        self.beer = beer
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        abvStepper.minimumValue = 0.0
        abvStepper.maximumValue = 15.0
        abvStepper.stepValue = 0.1
        
        caloriesStepper.minimumValue = 0.0
        caloriesStepper.maximumValue = 500.0
        caloriesStepper.stepValue = 10
        
        beerTypePicker.dataSource = self
        beerTypePicker.delegate = self
        
        updateUI()
    }
    
    private func updateUI() {
        nameTextField.text = beer.name

        abvStepper.value = beer.abv
        abvLabel.text = "\(abv.formatted()) %"
        
        caloriesStepper.value = beer.calories
        caloriesLabel.text = "\(calories.formatted()) kCal"
        
        let typeIndex = BeerType.allCases.firstIndex(of: beer.type)!
        beerTypePicker.selectRow(typeIndex, inComponent: 0, animated: true)
        
        if let imageData = beer.imageData, let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image =  UIImage(named: Constants.kUnknownImageName)!
        }
    }

    // Outlet actions
    
    @IBAction func abvStepperChanged(_ sender: UIStepper, forEvent event: UIEvent) {
        abvLabel.text = "\(abv.formatted()) %"
    }
    
    @IBAction func caloriesStepperChanged(_ sender: UIStepper) {
        caloriesLabel.text = "\(calories.formatted()) kCal"
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertController = UIAlertController(title: "Elige una fuente", message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = sender
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(UIAlertAction(title: "Librería", style: .default, handler: { [weak self] _ in
                self?.present(imagePickerController, animated: true)
            }))
        }
        
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveBeerUnwind" else { return }
        
        let name = nameTextField.text ?? ""
        let abv = abvStepper.value
        let calories = caloriesStepper.value
        let type = beerType
        
        beer.name = name
        beer.abv = abv
        beer.calories = calories
        beer.type = type
        beer.imageData = imageData
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "¿Seguro?", message: "Se perderán los cambios.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Salir", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        
        present(alertController, animated: true)
    }
    
    // PickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        BeerType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        BeerType.allCases[row].rawValue
    }
    
    // ImagePicker Delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        photoImageView.image = image
        self.dismiss(animated: true)
    }
}
