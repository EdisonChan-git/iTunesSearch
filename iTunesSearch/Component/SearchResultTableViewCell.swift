//
//  SearchResultTableViewCell.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var albumArtImg: UIImageView!
    @IBOutlet weak var CellName: UILabel!
    @IBOutlet weak var TypeName: UILabel!
    @IBOutlet weak var Sub: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureAlbumArtImage(url: String!){
        // Assuming you have an `imageView` outlet connected to a UIImageView in your storyboard or code
        let url = URL(string: url)
        let options: SDWebImageOptions = [.continueInBackground, .highPriority]
        albumArtImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder-image"), options: options)
    }
    
    func setupSearchResultData() {
        
    }
}
