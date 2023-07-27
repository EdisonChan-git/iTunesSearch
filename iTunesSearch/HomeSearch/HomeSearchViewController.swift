//
//  HomeSearchViewController.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 26/7/2023.
//

import UIKit

class HomeSearchViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var langButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var tableViewTopStackView: UIStackView!
    @IBOutlet weak var tapCollectionView: UICollectionView!
    
    let viewModel = HomeSearchViewModel()
    var timer : Timer?
    var searchText : String = ""
    var tapArray = ["Song".localize(),"Album".localize(),"Artist".localize()]
    var currentSearchType = 0 // 0 = Song, 1 = Alubm, 2 = Artist
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchResultTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        self.tapCollectionView.register(UINib.init(nibName: "TapView", bundle: nil), forCellWithReuseIdentifier: "TapView")
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: Notification.Name("AppLanguageDidChange"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLocalizationString()
    }
    
    func setupLocalizationString() {
        self.headerLabel.text = "iTunes Search".localize()
        self.searchBar.placeholder = "Search Songs, Artists, Albums.....".localize()
        tapArray = ["Song".localize(),"Album".localize(),"Artist".localize()]
        self.tapCollectionView.reloadData()
    }

    @objc func search() {
        viewModel.performSearch(searchText: self.searchText, completion: {
            self.searchResultTableView.reloadData()
            self.tableViewTopStackView.isHidden = self.viewModel.searchText.count == 0
            self.tapCollectionView.reloadData()
        })
    }
    
    @objc func languageDidChange() {
        // Reload the content of your view controller
        setupLocalizationString()
    }
    
    @IBAction func didClickFilter(_ sender: Any) {
        
    }
    @IBAction func didClickChangeLang(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Language".localize(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "English" , style: .default, handler: { _ in
            // Update app's language with the language code
            UserDefaults.standard.set("en", forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: Notification.Name("AppLanguageDidChange"), object: nil)
        }))
        alert.addAction(UIAlertAction(title: "繁體中文（香港）" , style: .default, handler: { _ in
            // Update app's language with the language code
            UserDefaults.standard.set("zh-HK", forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: Notification.Name("AppLanguageDidChange"), object: nil)
        }))
        alert.addAction(UIAlertAction(title: "简体中文（中国）" , style: .default, handler: { _ in
            // Update app's language with the language code
            UserDefaults.standard.set("zh-Hans", forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: Notification.Name("AppLanguageDidChange"), object: nil)
        }))

           // Show change language alert to user
       self.present(alert, animated: true, completion: nil)
    }
}

extension HomeSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
}

extension HomeSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        if let ArtistResult = viewModel.searchResult[indexPath.row] as? ArtistResult{
            cell.CellName.text = ArtistResult.artistName
            cell.TypeName.text = ArtistResult.artistType
            cell.Sub.text = ArtistResult.primaryGenreName
            cell.albumArtImg.image = UIImage(named: "placeholder-image")
        }else{
            let MusicResult = viewModel.searchResult[indexPath.row] as! MusicResult
            cell.CellName.text = MusicResult.trackName ?? MusicResult.collectionName ?? ""
            if(MusicResult.kind != nil){
                cell.TypeName.isHidden = false
                cell.TypeName.text = MusicResult.kind!
            }else{
                cell.TypeName.isHidden = true
            }
            cell.Sub.text = MusicResult.artistName ?? ""
            cell.configureAlbumArtImage(url: MusicResult.artworkUrl100!)
            
            if indexPath.row == viewModel.searchResult.count - 5 { // last 5 cell
                if !viewModel.noMoreResult { // check if more items to fetch
                    viewModel.getNext20SearchResult {
                        tableView.reloadData()
                    }
                }
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HomeSearchViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSearchType = indexPath.row
        self.viewModel.currentSearchType = indexPath.row
        print(self.currentSearchType)
        search()
    }
}

extension HomeSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.tapCollectionView.dequeueReusableCell(withReuseIdentifier: "TapView", for: indexPath) as? TapView {
            cell.setupCell(
                displayText: self.tapArray[indexPath.row] ,
                accessibilityText: self.tapArray[indexPath.row] ,
                isSelected: (self.currentSearchType == indexPath.row)
            )
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension HomeSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension HomeSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if(timer != nil){
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HomeSearchViewController.search), userInfo: nil, repeats: false)
    }
}
