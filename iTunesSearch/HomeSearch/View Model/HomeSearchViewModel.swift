//
//  HomeSearchViewModel.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

class HomeSearchViewModel{
    var searchResult: NSMutableArray = []
    var filterList_country: NSMutableArray = []
    var filterList_mediaType: NSMutableArray = []
    var searchText = ""
    var currentPage = 0
    var offset = 20
    var count = 0
    var noMoreResult = false
    var currentSearchType = 0
    
    func resetSearchParam() {
        currentPage = 0
        offset = 20
        count = 0
        noMoreResult = false
        
        filterList_country = []
        filterList_mediaType = []
    }
    
    func performSearch(searchText: String, completion: @escaping () -> Void) {
        resetSearchParam()
        
        self.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        if(searchText.count == 0){
            searchResult.removeAllObjects()
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
            if(self.count == self.searchResult.count){
                self.noMoreResult = true
            }
            
            //update value
            self.currentPage += 1
            self.count = self.searchResult.count
            
            self.configureFilterList()
            
            completion()
        }
    }
    
    func getNext20SearchResult(completion: @escaping () -> Void) {
        if(searchText.count == 0) {return}
        APIManager.shared.fetchiTunesResult(searchText: searchText, currentSelectType: currentSearchType, currentPage: (currentPage*offset), offset: offset, resultList: searchResult) { response in
            self.searchResult = response
            if(self.count == self.searchResult.count){
                self.noMoreResult = true
            }
            
            //update value
            self.currentPage += 1
            self.count = self.searchResult.count
            print(self.count)
            
            self.configureFilterList()
            
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
                if !list.contains(kind) {
                    list.add(kind)
                }
            }
        }
        
        filterList_mediaType = list
    }
}
