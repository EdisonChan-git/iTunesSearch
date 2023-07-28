//
//  HomeSearchViewController.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 26/7/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class HomeSearchViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var langButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var tableViewTopStackView: UIStackView!
    @IBOutlet weak var tapCollectionView: UICollectionView!
    
    let viewModel = HomeSearchViewModel()
    var searchText : String = ""
    var tapArray = ["Song".localize(),"Album".localize(),"Artist".localize()]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Register Cell
        self.searchResultTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        self.tapCollectionView.register(UINib.init(nibName: "TapView", bundle: nil), forCellWithReuseIdentifier: "TapView")
        
        //Register Notification
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: Notification.Name("AppLanguageDidChange"), object: nil)
        
        searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                // Handle text changes
                self?.searchText = text
                self?.search()
            })
            .disposed(by: disposeBag)
        
        viewModel.displaySearchResult.subscribe(onNext: { _ in
            self.searchResultTableView.reloadData()
            
            self.tapCollectionView.reloadData()
            
            //The tableViewTopStackView component contains both the TapView and Filter Button elements, which are only displayed upon completion of a search operation
            self.tableViewTopStackView.isHidden = self.viewModel.searchText.count == 0
            
        }).disposed(by: disposeBag)
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

    func search() {
        viewModel.performSearch(searchText: self.searchText)
    }
    
    @objc func languageDidChange() {
        // Reload the content of your view controller
        setupLocalizationString()
    }
    
    @IBAction func didClickFilter(_ sender: Any) {
        let vc = HomeSearchFilterViewController(raw_filterList_country: viewModel.filterList_country, raw_filterList_mediaType: viewModel.filterList_mediaType, selected_filterList_country: viewModel.selected_filter_country, selected_filterList_mediaType: viewModel.selected_filter_mediaType)
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didClickFavourite(_ sender: Any) {
        let vc = FavouriteListViewController()

        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didClickChangeLang(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Language".localize(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "English" , style: .default, handler: { _ in
            // Update app's language with the language code
            Utils.shared.updateLanguage(lang: "en")
        }))
        alert.addAction(UIAlertAction(title: "繁體中文（香港）" , style: .default, handler: { _ in
            // Update app's language with the language code
            Utils.shared.updateLanguage(lang: "zh-HK")
        }))
        alert.addAction(UIAlertAction(title: "简体中文（中国）" , style: .default, handler: { _ in
            // Update app's language with the language code
            Utils.shared.updateLanguage(lang: "zh-Hans")
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
        return viewModel.displaySearchResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        cell.TypeName.isHidden = true
        if let ArtistResult = viewModel.displaySearchResult.value[indexPath.row] as? ArtistResult{
            cell.setupArtistResultData(data: ArtistResult)
        }else if let AlbumResult = viewModel.displaySearchResult.value[indexPath.row] as? AlbumResult{
            cell.setupAblumResultData(data: AlbumResult)
        }else{
            let MusicResult = viewModel.displaySearchResult.value[indexPath.row] as! MusicResult
            cell.setupMusicResultData(data: MusicResult)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.displaySearchResult.value.count - 1 { // last 1 cell
            if !viewModel.noMoreResult || !viewModel.applyingFilter { // check if more items to fetch
                viewModel.getNext20SearchResult()
            }
        }
    }
}

extension HomeSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ArtistResult = viewModel.displaySearchResult.value[indexPath.row] as? ArtistResult{
            Utils.shared.openURL(ArtistResult.artistLinkUrl ?? "")
        }else if let AlbumResult = viewModel.displaySearchResult.value[indexPath.row] as? AlbumResult{
            Utils.shared.openURL(AlbumResult.collectionViewUrl )
        }else{
            let MusicResult = viewModel.displaySearchResult.value[indexPath.row] as! MusicResult
            print("Want to open \(MusicResult.trackName!) By \(MusicResult.artistName!)")
            let vc = SongDetailViewController()
            vc.data = MusicResult
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeSearchViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Update current search type (0 = Song, 1 = Alubm, 2 = Artist)
        self.viewModel.currentSearchType = indexPath.row
        
        //Only show filter button when searching song
        self.filterButton.isHidden = self.viewModel.currentSearchType != 0
        
        //Perform Search
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
                isSelected: (self.viewModel.currentSearchType == indexPath.row)
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

extension HomeSearchViewController: FilterSelectionDelegate {
    func didSelectFilters(_ Countryfilters: NSMutableArray,_ MediaTypefilter: NSMutableArray) {
        // Handle the selected filters from selection page
        viewModel.applyingFilter = true
        viewModel.selected_filter_country = Countryfilters
        viewModel.selected_filter_mediaType = MediaTypefilter
        viewModel.performFilterOperation()
        searchResultTableView.reloadData()
    }
}
