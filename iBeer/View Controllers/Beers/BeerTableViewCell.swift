//
//  BeerTableViewCell.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 27/12/21.
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(name: String, logoData: Data?) {
        nameLabel.text = name
        
        if let logoData = logoData, let image = UIImage(data: logoData) {
            logoImageView.image = image
        } else {
            logoImageView.image = UIImage(named: Constants.kUnknownImageName)
        }
    }
}
