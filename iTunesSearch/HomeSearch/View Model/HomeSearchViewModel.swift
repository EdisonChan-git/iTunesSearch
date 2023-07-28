//
//  HomeSearchViewModel.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

class HomeSearchViewModel{
    var searchResult: NSMutableArray = []
    var displaySearchResult: NSMutableArray = []
    var filterList_country: NSMutableArray = []
    var filterList_mediaType: NSMutableArray = []
    var searchText = ""
    var currentPage = 0
    var offset = 20
    var count = 0
    var noMoreResult = false
    var applyingFilter = false
    var currentSearchType = 0
    
    var selected_filter_country: NSMutableArray = []
    var selected_filter_mediaType: NSMutableArray = []
    
    func resetSearchParam() {
        currentPage = 0
        offset = 20
        count = 0
        noMoreResult = false
        
        //reset filter value list
        filterList_country = []
        filterList_mediaType = []
    }
    
    func performSearch(searchText: String, completion: @escaping () -> Void) {
        resetSearchParam()
        
        self.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        if(searchText.count == 0){
            searchResult.removeAllObjects()
            displaySearchResult.removeAllObjects()
            completion()
        }else{
            getSearchResult {
                completion()
            }
        }
    }
    
    func getSearchResult(completion: @escaping () -> Void) {
        if(searchText.count == 0) {return}
        APIManager.shared.fetchiTunesResult(searchText: searchText, currentSelectType: currentSearchType, currentPage: currentPage, offset: offset, resultList: nil) { response in
            self.searchResult = response
            self.displaySearchResult = response
            if(self.count == self.searchResult.count){
                self.noMoreResult = true
            }
            
            //update paging value
            self.currentPage += 1
            self.count = self.searchResult.count
            
            self.configureFilterList()
            
            self.performFilterOperation()
            
            completion()
        }
    }
    
    func getNext20SearchResult(completion: @escaping () -> Void) {
        if(searchText.count == 0) {return}
        APIManager.shared.fetchiTunesResult(searchText: searchText, currentSelectType: currentSearchType, currentPage: (currentPage*offset), offset: offset, resultList: searchResult) { response in
            self.searchResult = response
            self.displaySearchResult = response
            if(self.count == self.searchResult.count){
                self.noMoreResult = true
            }
            
            //update paging value
            self.currentPage += 1
            self.count = self.searchResult.count
            
            self.configureFilterList()
            
            self.performFilterOperation()
            
            completion()
        }
    }
    
    func configureFilterList() {
        configureCountryListFromResult()
        configureMediaTypeListFromResult()
    }
    
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
            self.displaySearchResult = NSMutableArray(array: commonResults)
        }else if(selected_filter_country.count > 0){
            self.displaySearchResult = arr_passCountryFilter
        }else if(selected_filter_mediaType.count > 0){
            self.displaySearchResult = arr_passMediaTypeFilter
        }else{
            self.displaySearchResult = searchResult
        }
    }
}
