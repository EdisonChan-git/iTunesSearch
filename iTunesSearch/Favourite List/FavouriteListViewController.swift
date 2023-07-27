//
//  FavouriteListViewController.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import UIKit

class FavouriteListViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var songListView: UITableView!
    
    var list : NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        songListView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        list = Utils.shared.getFavouriteListFromUserDefault()
        songListView.reloadData()
    }

    @IBAction func popBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension FavouriteListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favouriteList = list else { return }
        let MusicResult = favouriteList[indexPath.row] as! MusicResult
        print("Want to open \(MusicResult.trackName!) By \(MusicResult.artistName!)")
        let vc = SongDetailViewController()
        vc.data = MusicResult
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavouriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favouriteList = list else { return 0 }
        
        return favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favouriteList = list else { return UITableViewCell() }
        
        let cell : SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        let MusicResult = favouriteList[indexPath.row] as! MusicResult
        cell.setupMusicResultData(data: MusicResult)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
