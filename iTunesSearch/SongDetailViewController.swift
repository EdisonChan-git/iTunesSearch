//
//  SongDetailViewController.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import UIKit
import WebKit
import SDWebImage

class SongDetailViewController: UIViewController {
    @IBOutlet weak var AddOrRemoveBtn: UIButton!
    @IBOutlet weak var CoverImage: UIImageView!
    @IBOutlet weak var SongName: UILabel!
    @IBOutlet weak var ArtistName: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var PublishDate: UILabel!
    
    var data : MusicResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignData()
    }

    @IBAction func popBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didClickAddOrRemoveBtn(_ sender: Any) {
        guard let songData = data else { return }
        
        Utils.shared.updateFavouriteList(song: songData)
        
        if(Utils.shared.checkIfSongIsExistInFavouriteList(song: songData)){
            self.AddOrRemoveBtn.setImage(UIImage(named: "icon_favorite_selected"), for: .normal)
        }else{
            self.AddOrRemoveBtn.setImage(UIImage(named: "icon_favorite_unselected"), for: .normal)
        }
    }
    
    func assignData() {
        guard let songData = data else { return }
        
        let url = URL(string: songData.artworkUrl100!)
        let options: SDWebImageOptions = [.continueInBackground, .highPriority]
        CoverImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: options)
        
        SongName.text = songData.trackName
        ArtistName.text = songData.artistName
        PublishDate.text = songData.releaseDate!.publishDate()
        SubTitle.text = "\(songData.kind!) • \(songData.releaseDate!.publishYear())"
        
        if(Utils.shared.checkIfSongIsExistInFavouriteList(song: songData)){
            self.AddOrRemoveBtn.setImage(UIImage(named: "icon_favorite_selected"), for: .normal)
        }else{
            self.AddOrRemoveBtn.setImage(UIImage(named: "icon_favorite_unselected"), for: .normal)
        }
    }
    
}
