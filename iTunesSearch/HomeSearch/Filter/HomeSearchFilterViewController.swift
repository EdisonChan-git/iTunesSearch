//
//  HomeSearchFilterViewController.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import UIKit
import RxSwift

protocol FilterSelectionDelegate: AnyObject {
    func didSelectFilters(_ Countryfilters: NSMutableArray,_ MediaTypefilter: NSMutableArray)
}

class HomeSearchFilterViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var mediaTypeBtn: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var viewModel : HomeSearchFilterViewModel
    var currentDisplayTab = 0 //0:Country, 1:Media Type
    let disposeBag = DisposeBag()
    
    weak var delegate: FilterSelectionDelegate?
    
    init(raw_filterList_country: NSMutableArray,
        raw_filterList_mediaType: NSMutableArray,
        selected_filterList_country: NSMutableArray,
        selected_filterList_mediaType: NSMutableArray) {
        
        viewModel = HomeSearchFilterViewModel(raw_filterList_country: raw_filterList_country, raw_filterList_mediaType: raw_filterList_mediaType)
        viewModel.selcted_country.accept(selected_filterList_country)
        viewModel.selcted_mediaType.accept(selected_filterList_mediaType)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        self.filterTableView.register(UINib(nibName: "FilterSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterSelectionTableViewCell")
        
        viewModel.selcted_country.subscribe(onNext: { _ in
            self.filterTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.selcted_mediaType.subscribe(onNext: { _ in
            self.filterTableView.reloadData()
        }).disposed(by: disposeBag)
        
        filterTableView.reloadData()
    }
    
    func setupLocalizationString() {
        headerLabel.text = "Filter".localize()
        countryBtn.setTitle("Country".localize(), for: .normal)
        mediaTypeBtn.setTitle("Media Type".localize(), for: .normal)
        resetBtn.setTitle("Reset".localize(), for: .normal)
        confirmBtn.setTitle("Confirm".localize(), for: .normal)
    }
    
    func setupUI() {
        resetBtn.layer.cornerRadius = 25
        confirmBtn.layer.cornerRadius = 25
        resetBtn.layer.borderWidth = 1
        confirmBtn.layer.borderWidth = 1
        resetBtn.layer.borderColor = UIColor.black.cgColor
        confirmBtn.layer.borderColor = UIColor.black.cgColor
        resetBtn.setTitleColor(UIColor.black, for: .normal)
        confirmBtn.setTitleColor(UIColor.black, for: .normal)
        
        if(currentDisplayTab == 0){
            countryBtn.setTitleColor(UIColor.black, for: .normal)
            mediaTypeBtn.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
            countryBtn.setTitleColor(UIColor.lightGray, for: .normal)
            mediaTypeBtn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func didPressReset(_ sender: Any) {
        viewModel.resetFilter()
        
        filterTableView.reloadData()
    }
    
    @IBAction func didPressConfirm(_ sender: Any) {
        delegate?.didSelectFilters(viewModel.selcted_country.value, viewModel.selcted_mediaType.value)
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didPressCountry(_ sender: Any) {
        if(currentDisplayTab != 0){
            currentDisplayTab = 0
            filterTableView.reloadData()
            setupUI()
        }
    }
    
    @IBAction func didPressMediaType(_ sender: Any) {
        if(currentDisplayTab != 1){
            currentDisplayTab = 1
            filterTableView.reloadData()
            setupUI()
        }
    }
}

extension HomeSearchFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentDisplayTab{
        case 0:
            return viewModel.raw_filterList_country.count
        case 1:
            return viewModel.raw_filterList_mediaType.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FilterSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectionTableViewCell", for: indexPath) as! FilterSelectionTableViewCell
        if(currentDisplayTab == 0){
            cell.value.text = viewModel.raw_filterList_country[indexPath.row] as? String
            cell.updateSelection(isTick: viewModel.selcted_country.value.contains(viewModel.raw_filterList_country[indexPath.row]))
        }else{
            cell.value.text = viewModel.raw_filterList_mediaType[indexPath.row] as? String
            cell.updateSelection(isTick: viewModel.selcted_mediaType.value.contains(viewModel.raw_filterList_mediaType[indexPath.row]))
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeSearchFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : FilterSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectionTableViewCell", for: indexPath) as! FilterSelectionTableViewCell
        if(currentDisplayTab == 0){
            let value = viewModel.raw_filterList_country[indexPath.row] as! String
            let arr = viewModel.selcted_country.value
            if arr.contains(viewModel.raw_filterList_country[indexPath.row]){
                arr.remove(value)
                cell.tick.isHidden = true
            }else{
                arr.add(value)
                cell.tick.isHidden = false
            }
            viewModel.selcted_country.accept(arr)
            print("filterList_country: " ,viewModel.selcted_country)
        }else{
            let value = viewModel.raw_filterList_mediaType[indexPath.row] as! String
            let arr = viewModel.selcted_mediaType.value
            if arr.contains(viewModel.raw_filterList_mediaType[indexPath.row]) {
                arr.remove(value)
                cell.tick.isHidden = true
            }else{
                arr.add(value)
                cell.tick.isHidden = false
            }
            viewModel.selcted_mediaType.accept(arr)
            print("filterList_mediaType: " ,viewModel.selcted_mediaType)
        }
    }
}
