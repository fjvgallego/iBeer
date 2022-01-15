//
//  ManufacturerTableViewCell.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import UIKit

class ManufacturerTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var establishmentDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(name: String, formattedEstablishmentDate: String, logoData: Data?) {
        if let logoData = logoData, let image = UIImage(data: logoData) {
            self.logoImage.image = image
        } else {
            self.logoImage.image = UIImage(named: Constants.kUnknownImageName)!
        }
        
        self.nameLabel.text = name
        self.establishmentDateLabel.text = formattedEstablishmentDate
    }
}
