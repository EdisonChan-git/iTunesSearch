//
//  HomeSearchViewModel.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation
import SVProgressHUD
import RxSwift
import RxCocoa

class HomeSearchViewModel{
    var searchResult: NSMutableArray = []
    var filterList_country: NSMutableArray = []
    var filterList_mediaType: NSMutableArray = []
    var searchText = ""
    var currentPage = 0
    var offset = 20
    var count = 0
    var noMoreResult = false
    var applyingFilter = false
    
    /**
     search criteria (0 = Song, 1 = Alubm, 2 = Artist)
    */
    var currentSearchType = 0
    
    var selected_filter_country: NSMutableArray = []
    var selected_filter_mediaType: NSMutableArray = []
    var displaySearchResult = BehaviorRelay<NSMutableArray>(value: NSMutableArray())
    
    /**
    Resets the search parameters and filter values.
    */
    func resetSearchParam() {
        currentPage = 0
        offset = 20
        count = 0
        noMoreResult = false
        
        //reset filter value list
        filterList_country = []
        filterList_mediaType = []
    }
    
    /**
    Performs a search based on the inputted search query, resets the search parameters and filter values, and updates the search results.
    Parameter
        searchText: The search query to perform.
    */
    func performSearch(searchText: String) {
        resetSearchParam()
        
        self.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        if(searchText.count == 0){
            searchResult.removeAllObjects()
            displaySearchResult.value.removeAllObjects()
        }else{
            getSearchResult()
        }
    }
    
    /**
    Fetches the first 20 search results based on the current search criteria, updates the searchResult property with the new results, and updates the UI with the filtered results.
    */
    func getSearchResult() {
        if(searchText.count == 0) {return}
        SVProgressHUD.show()
        APIManager.shared.fetchiTunesResult(searchText: searchText, currentSelectType: currentSearchType, currentPage: currentPage, offset: offset, resultList: nil) { response in
            SVProgressHUD.dismiss()
            
            self.searchResult = response
            self.displaySearchResult.accept(response)
            if(self.count == self.searchResult.count){
                self.noMoreResult = true
            }
            
            //update paging value
            self.currentPage += 1
            self.count = self.searchResult.count
            
            self.configureFilterList()
            
            self.performFilterOperation()
        }
    }
    
    /**
    Fetches the next 20 search results based on the current search criteria, updates the searchResult property with the new results, and updates the UI with the filtered results.
    The function fetches the next 20 search results using the APIManager fetchiTunesResult method, passing the current search criteria and pagination values. It then updates the searchResult property with the new results, updates the UI with the filtered results, and updates the filter and pagination values. The function also updates the noMoreResult property if there are no more results to fetch.
    */
    func getNext20SearchResult() {
        if(searchText.count == 0) {return}
        SVProgressHUD.show()
        APIManager.shared.fetchiTunesResult(searchText: searchText, currentSelectType: currentSearchType, currentPage: (currentPage*offset), offset: offset, resultList: searchResult) { response in
            SVProgressHUD.dismiss()
            
            self.searchResult = response
            self.displaySearchResult.accept(response)
            if(self.count == self.searchResult.count){
                self.noMoreResult = true
            }
            
            //update paging value
            self.currentPage += 1
            self.count = self.searchResult.count
            
            self.configureFilterList()
            
            self.performFilterOperation()
        }
    }
    
    /**
     Configures the country and media type filter lists based on the search results.
    */
    func configureFilterList() {
        configureCountryListFromResult()
        configureMediaTypeListFromResult()
    }
    
    /**
     Configures the country filter list based on the search results, and updates the filterList_country property with the filtered countries.
    */
    func configureCountryListFromResult() {
        //reset data
        filterList_country = []
        
        let list = NSMutableArray()
        for item in searchResult{
            if let result = item as? MusicResult, let country = result.country {
                //check if the value is already in the list or not
                if !list.contains(country) {
                    list.add(country)
                }
            }
        }
        
        filterList_country = list
    }
    
    /**
     Configures the country filter list based on the search results, and updates the filterList_mediaType property with the filtered media type.
    */
    func configureMediaTypeListFromResult() {
        //reset data
        filterList_mediaType = []
        
        let list = NSMutableArray()
        for item in searchResult{
            if let result = item as? MusicResult, let kind = result.kind {
                //check if the value is already in the list or not
                if !list.contains(kind) {
                    list.add(kind)
                }
            }
        }
        
        filterList_mediaType = list
    }
    
    /**
    Performs filter operations on the search result based on the selected country and media type filters. The filtered results are then displayed using the displaySearchResult BehaviorRelay.
    */
    func performFilterOperation(){
        //perform OR operation in Country Filter
        let arr_passCountryFilter = NSMutableArray()
        for filterItem in selected_filter_country{
            let arr = self.searchResult.mutableCopy() as! NSMutableArray
            let predicate = NSPredicate(format: "country == %@", filterItem as! CVarArg)
            arr.filter(using: predicate)
            arr_passCountryFilter.addObjects(from: arr as [AnyObject])
        }
        
        //perform OR operation in Media Type Filter
        let arr_passMediaTypeFilter = NSMutableArray()
        for filterItem in selected_filter_mediaType{
            let arr = self.searchResult.mutableCopy() as! NSMutableArray
            let predicate = NSPredicate(format: "kind == %@", filterItem as! CVarArg)
            arr.filter(using: predicate)
            arr_passMediaTypeFilter.addObjects(from: arr as [AnyObject])
        }
        
        if(selected_filter_country.count > 0 && selected_filter_mediaType.count > 0){
            //perform AND operation
            let commonResults = arr_passCountryFilter.filter { result1 in
                arr_passMediaTypeFilter.contains { result2 in
                    (result1 as! MusicResult).trackId == (result2 as! MusicResult).trackId
                }
            }
            self.displaySearchResult.accept(NSMutableArray(array: commonResults))
        }else if(selected_filter_country.count > 0){
            self.displaySearchResult.accept(arr_passCountryFilter)
        }else if(selected_filter_mediaType.count > 0){
            self.displaySearchResult.accept(arr_passMediaTypeFilter)
        }else{
            self.displaySearchResult.accept(searchResult)
        }
    }
}
