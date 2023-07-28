//
//  FilterSelectionTableViewCell.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import UIKit

class FilterSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var tick: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /**
    Updates the selection state of a UI element by hiding or showing a tick image view based on the given Boolean value.
    Parameters:
     isTick: A Boolean value indicating whether the tick image view should be hidden or shown.
    */
    func updateSelection(isTick: Bool){
        tick.isHidden = !isTick
    }
    
}
