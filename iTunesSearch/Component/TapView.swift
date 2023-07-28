//
//  TapView.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import UIKit

class TapView: UICollectionViewCell {
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var tabBGView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tabBGView.layer.cornerRadius = 16
    }
    
    /**
    Sets up the appearance and accessibility information for a UI cell based on the given parameters.
    Parameters:
        displayText: The text to display in the cell.
        accessibilityText: The accessibility text to set for the cell.
        isSelected: A Boolean value indicating whether the cell is selected.
    */
    func setupCell(displayText:String, accessibilityText:String, isSelected:Bool) {
        if(isSelected){
            self.tabLabel.textColor = .white
            self.tabBGView.backgroundColor = .black
            self.tabBGView.layer.borderColor = UIColor.white.cgColor
        }else{
            self.tabLabel.textColor = .black
            self.tabBGView.backgroundColor = .white
            self.tabBGView.layer.borderColor = UIColor.black.cgColor
        }
        self.tabLabel.text = displayText
        self.accessibilityLabel = accessibilityText
    }

}
