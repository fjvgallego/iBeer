//
//  AddManufacturerTableViewController.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import UIKit

class AddManufacturerTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var originSegmentedControl: UISegmentedControl!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Variables
    
    var manufacturer: Manufacturer?
    
    var name: String { nameTextField.text ?? "" }
    
    var establishmentDate: Date { datePicker.date }
    var origin: Origin {
        let selectedIndex = originSegmentedControl.selectedSegmentIndex
        let origin = Origin.allCases[selectedIndex]
        return origin
    }
    var logoData: Data? {
        logoImageView.image?.pngData()
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tfText = nameTextField.text ?? ""
        saveButton.isEnabled = !tfText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        originSegmentedControl.removeAllSegments()
        for (index, origin) in Origin.allCases.enumerated() {
            originSegmentedControl.insertSegment(withTitle: origin.rawValue, at: index, animated: true)
        }
        
        originSegmentedControl.selectedSegmentIndex = 0
    }
    
    // Outlet methods
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertController = UIAlertController(title: "Elige una fuente", message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = sender
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let alertAction = UIAlertAction(title: "Biblioteca", style: .default) { [weak self] _ in
                self?.present(imagePickerController, animated: true)
            }
            alertController.addAction(alertAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { [weak self] _ in
                imagePickerController.sourceType = .camera
                self?.present(imagePickerController, animated: true)
            }))
        }
        
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveManufacturerUnwind",
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        manufacturer = Manufacturer(name: name, establishmentDate: establishmentDate, logoData: logoData, origin: origin, beers: [])
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "¿Seguro?", message: "Se perderán los cambios.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Salir", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        
        present(alertController, animated: true)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        saveButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        logoImageView.image = image
        self.dismiss(animated: true)
    }
    
    
}
