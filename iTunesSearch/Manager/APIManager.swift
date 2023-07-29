//
//  APIManager.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

import Alamofire

class APIManager {
    static let shared = APIManager()
    private let searchBaseURL = "https://itunes.apple.com/search?term=%@&offset=%ld&limit=%ld&entity=%@&lang=%@"
    
    /**
    Retrieves the language code to use for API calls based on the user's preferred language.
    Returns: A String representing the language code to use for API calls.
    */
    func APILang() -> String {
        let defaultLanguage = "en"
        let appLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ?? defaultLanguage
        
        if appLanguage == "zh-HK" {
            return "zh_hk"
        }else if appLanguage == "zh-Hans" {
            return "zh_cn"
        }else {
            return "en_hk"
        }
    }
    
    /**
    Fetches search results from the iTunes database based on the given search text, result type, and pagination information, and returns the results in an NSMutableArray.
    Parameters:
        searchText: The text to search for in the iTunes database.
        currentSelectType: The type of search result to fetch. (0=Music, 1=Album, 2=Artist)
        currentPage: The current page of search results to fetch.
        offset: The offset of search results to fetch.
        resultList: An optional NSMutableArray containing previously fetched search results.
        completion: A closure to be called upon completion of the API request, containing the fetched search results in an NSMutableArray.
    */
    func fetchiTunesResult(searchText: String!, currentSelectType: Int, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        if(currentSelectType == 2){
            fetchiTunesArtistResult(searchText: searchText, currentPage: currentPage, offset: offset, resultList: resultList) { arr in
                completion(arr)
            }
        }else if(currentSelectType == 1){
            fetchiTunesAlbumResult(searchText: searchText, currentPage: currentPage, offset: offset, resultList: resultList) { arr in
                completion(arr)
            }
        }else{
            fetchiTunesMusicResult(searchText: searchText, currentSelectType: currentSelectType, currentPage: currentPage, offset: offset, resultList: resultList) { arr in
                completion(arr)
            }
        }
    }
    
    /**
    Fetches iTunes music search results based on the given search text and pagination information, and returns the results in an NSMutableArray.
    Parameters:
        searchText: The text to search for in the iTunes music database.
        currentSelectType: The type of search result to fetch. (0=Music, 1=Album, 2=Artist)
        currentPage: The current page of search results to fetch.
        offset: The offset of search results to fetch.
        resultList: An optional NSMutableArray containing previously fetched search results.
        completion: A closure to be called upon completion of the API request, containing the fetched search results in an NSMutableArray.
    */
    func fetchiTunesMusicResult(searchText: String!, currentSelectType: Int, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        let urlString = String(format: searchBaseURL, searchText, currentPage, offset, "musicTrack", APILang())
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)
        let url = URL(string: encodedUrl!)!
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any]{
                    if let iTunesSearchResult = iTunesSearchResult(json: json){
                        var newResultList = NSMutableArray()
                        if(resultList != nil){
                            newResultList = NSMutableArray(array: resultList!)
                        }
                        newResultList.addObjects(from: iTunesSearchResult.results!)
                        
                        completion(newResultList)
                    }else{
                        print("error occur!")
                        completion(NSMutableArray())
                    }
                    
                }
            case .failure(let error):
                print(error)
                Utils.shared.showAlert(title: "Error", message: error.localizedDescription)
                completion(NSMutableArray())
            }
        }
    }
    
    /**
    Fetches iTunes album search results based on the given search text and pagination information, and returns the results in an NSMutableArray.
    Parameters:
        searchText: The text to search for in the iTunes album database.
        currentPage: The current page of search results to fetch.
        offset: The offset of search results to fetch.
        resultList: An optional NSMutableArray containing previously fetched search results.
        completion: A closure to be called upon completion of the API request, containing the fetched search results in an NSMutableArray.
    */
    func fetchiTunesAlbumResult(searchText: String!, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        
        let urlString = String(format: searchBaseURL, searchText, currentPage, offset, "album", APILang())
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)
        let url = URL(string: encodedUrl!)!
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any]{
                    if let iTunesAlbumResult = iTunesAlbumResult(json: json){
                        var newResultList = NSMutableArray()
                        if(resultList != nil){
                            newResultList = NSMutableArray(array: resultList!)
                        }
                        newResultList.addObjects(from: iTunesAlbumResult.results!)
                        
                        completion(newResultList)
                    }else{
                        print("error occur!")
                        completion(NSMutableArray())
                    }
                    
                }
            case .failure(let error):
                print(error)
                Utils.shared.showAlert(title: "Error", message: error.localizedDescription)
                completion(NSMutableArray())
            }
        }
    }
    
    /**
    Fetches iTunes artist search results based on the given search text and pagination information, and returns the results in an NSMutableArray.
    Parameters:
        searchText: The text to search for in the iTunes artist database.
        currentPage: The current page of search results to fetch.
        offset: The offset of search results to fetch.
        resultList: An optional NSMutableArray containing previously fetched search results.
        completion: A closure to be called upon completion of the API request, containing the fetched search results in an NSMutableArray.
    */
    func fetchiTunesArtistResult(searchText: String!, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        
        let urlString = String(format: searchBaseURL, searchText, currentPage, offset, "musicArtist", APILang())
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)
        let url = URL(string: encodedUrl!)!
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any]{
                    if let iTunesArtistResult = iTunesArtistResult(json: json){
                        var newResultList = NSMutableArray()
                        if(resultList != nil){
                            newResultList = NSMutableArray(array: resultList!)
                        }
                        newResultList.addObjects(from: iTunesArtistResult.results!)
                        
                        completion(newResultList)
                    }else{
                        print("error occur!")
                        completion(NSMutableArray())
                    }
                    
                }
            case .failure(let error):
                print(error)
                Utils.shared.showAlert(title: "Error", message: error.localizedDescription)
                completion(NSMutableArray())
            }
        }
    }
}
