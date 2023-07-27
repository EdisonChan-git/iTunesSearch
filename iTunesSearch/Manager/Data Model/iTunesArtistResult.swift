//
//  iTunesArtistResult.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

class iTunesArtistResultResponse: NSObject {
    var resultCount: Int!
    var results: [ArtistResult]!
    
    init(resultCount: Int, results: [ArtistResult]) {
        self.resultCount = resultCount
        self.results = results
    }
        
    // Convenience initializer to create an `iTunesArtistResultResponse` object from JSON data
    convenience init?(json: [String: Any]) {
        guard let resultCount = json["resultCount"] as? Int,
              let resultsJSON = json["results"] as? [[String: Any]] else {
            return nil
        }
        
        var results = [ArtistResult]()
        for resultJSON in resultsJSON {
            if let result = ArtistResult(json: resultJSON) {
                results.append(result)
            }
        }
        
        self.init(resultCount: resultCount, results: results)
    }
}

class ArtistResult: NSObject{
    var wrapperType: String?
    var artistType: String?
    var artistName: String?
    var artistLinkUrl: String?
    var artistId: Int?
    var amgArtistId: Int?
    var primaryGenreName: String?
    var primaryGenreId: Int?
    
    init?(json: [String: Any]) {
        guard let wrapperType = json["wrapperType"] as? String,
              let artistType = json["artistType"] as? String,
              let artistName = json["artistName"] as? String,
              let artistLinkUrl = json["artistLinkUrl"] as? String,
              let artistId = json["artistId"] as? Int,
              let primaryGenreName = json["primaryGenreName"] as? String,
              let primaryGenreId = json["primaryGenreId"] as? Int else {
            return nil
        }
        
        self.wrapperType = wrapperType
        self.artistType = artistType
        self.artistName = artistName
        self.artistLinkUrl = artistLinkUrl
        self.artistId = artistId
        self.amgArtistId = json["amgArtistId"] as? Int
        self.primaryGenreName = primaryGenreName
        self.primaryGenreId = primaryGenreId
    }
}
