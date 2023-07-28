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
    
    func updateSelection(isTick: Bool){
        tick.isHidden = !isTick
    }
    
}
