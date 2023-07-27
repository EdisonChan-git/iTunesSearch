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
        albumArtImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: options)
    }
    
    func setupArtistResultData(data : ArtistResult) {
        CellName.text = data.artistName
        Sub.text = "\(data.artistType!) • \(data.primaryGenreName!)"
        albumArtImg.isHidden = true
    }
    
    func setupMusicResultData(data : MusicResult) {
        CellName.text = data.trackName
        TypeName.text = data.kind
        Sub.text = data.artistName
        if data.artworkUrl100 != nil {
            albumArtImg.isHidden = false
            configureAlbumArtImage(url: data.artworkUrl100)
        }else{
            albumArtImg.isHidden = true
        }
        albumArtImg.isHidden = false
        TypeName.isHidden = false
    }
    
    func setupAblumResultData(data : AlbumResult) {
        CellName.text = data.collectionName
        Sub.text = data.artistName
        if data.artworkUrl100 != nil {
            albumArtImg.isHidden = false
            configureAlbumArtImage(url: data.artworkUrl100)
        }else{
            albumArtImg.isHidden = true
        }
        TypeName.isHidden = true
    }
}
