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
    private let searchBaseURL = "https://itunes.apple.com/search?term=%@&offset=%ld&limit=%ld&entity=%@"
    
    func fetchiTunesResult(searchText: String!, currentSelectType: Int, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        if(currentSelectType == 2){
            fetchiTunesArtistResult(searchText: searchText, currentPage: currentPage, offset: offset, resultList: resultList) { arr in
                completion(arr)
            }
        }else{
            fetchiTunesMusicAlbumResult(searchText: searchText, currentSelectType: currentSelectType, currentPage: currentPage, offset: offset, resultList: resultList) { arr in
                completion(arr)
            }
        }
    }
    
    func fetchiTunesMusicAlbumResult(searchText: String!, currentSelectType: Int, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        let entity = currentSelectType == 0 ? "song" : "album"
        
        let urlString = String(format: searchBaseURL, searchText, currentPage, offset, entity)
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
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchiTunesArtistResult(searchText: String!, currentPage: Int, offset: Int, resultList: NSMutableArray?, completion: @escaping (NSMutableArray) -> Void) {
        
        let urlString = String(format: searchBaseURL, searchText, currentPage, offset, "musicArtist")
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)
        let url = URL(string: encodedUrl!)!
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any]{
                    if let iTunesArtistResultResponse = iTunesArtistResultResponse(json: json){
                        var newResultList = NSMutableArray()
                        if(resultList != nil){
                            newResultList = NSMutableArray(array: resultList!)
                        }
                        newResultList.addObjects(from: iTunesArtistResultResponse.results!)
                        
                        completion(newResultList)
                    }else{
                        print("error occur!")
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
