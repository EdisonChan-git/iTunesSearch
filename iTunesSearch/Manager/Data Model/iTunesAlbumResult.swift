//
//  iTunesAlbumResult.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

class iTunesAlbumResult: NSObject {
    var resultCount: Int!
    var results: [AlbumResult]!
    
    init(resultCount: Int, results: [AlbumResult]) {
        self.resultCount = resultCount
        self.results = results
    }
        
    // Convenience initializer to create an `iTunesArtistResultResponse` object from JSON data
    convenience init?(json: [String: Any]) {
        guard let resultCount = json["resultCount"] as? Int,
              let resultsJSON = json["results"] as? [[String: Any]] else {
            return nil
        }
        
        var results = [AlbumResult]()
        for resultJSON in resultsJSON {
            if let result = AlbumResult(json: resultJSON) {
                results.append(result)
            }
        }
        
        self.init(resultCount: resultCount, results: results)
    }
}

class AlbumResult: NSObject {
    var wrapperType: String
    var collectionType: String
    var artistId: Int
    var collectionId: Int
    var artistName: String
    var collectionName: String
    var collectionCensoredName: String
    var collectionViewUrl: String
    var artworkUrl60: String?
    var artworkUrl100: String?
    var collectionPrice: Double
    var collectionExplicitness: String
    var trackCount: Int
    var country: String
    var currency: String
    var releaseDate: String
    var primaryGenreName: String
    
    convenience init?(json: [String: Any]) {
        guard let wrapperType = json["wrapperType"] as? String,
              let collectionType = json["collectionType"] as? String,
              let artistId = json["artistId"] as? Int,
              let collectionId = json["collectionId"] as? Int,
              let artistName = json["artistName"] as? String,
              let collectionName = json["collectionName"] as? String,
              let collectionCensoredName = json["collectionCensoredName"] as? String,
              let collectionViewUrl = json["collectionViewUrl"] as? String,
              let artworkUrl60 = json["artworkUrl60"] as? String,
              let artworkUrl100 = json["artworkUrl100"] as? String,
              let collectionPrice = json["collectionPrice"] as? Double,
              let collectionExplicitness = json["collectionExplicitness"] as? String,
              let trackCount = json["trackCount"] as? Int,
              let country = json["country"] as? String,
              let currency = json["currency"] as? String,
              let releaseDate = json["releaseDate"] as? String,
              let primaryGenreName = json["primaryGenreName"] as? String
        else {
            return nil
        }
        
        self.init(wrapperType: wrapperType, collectionType: collectionType, artistId: artistId, collectionId: collectionId, artistName: artistName, collectionName: collectionName, collectionCensoredName: collectionCensoredName, collectionViewUrl: collectionViewUrl, artworkUrl60: artworkUrl60, artworkUrl100: artworkUrl100, collectionPrice: collectionPrice, collectionExplicitness: collectionExplicitness, trackCount: trackCount, country: country, currency: currency, releaseDate: releaseDate, primaryGenreName: primaryGenreName)
    }
    
    init(wrapperType: String, collectionType: String, artistId: Int, collectionId: Int, artistName: String, collectionName: String, collectionCensoredName: String, collectionViewUrl: String, artworkUrl60: String, artworkUrl100: String, collectionPrice: Double, collectionExplicitness: String, trackCount: Int, country: String, currency: String, releaseDate: String, primaryGenreName: String) {
        self.wrapperType = wrapperType
        self.collectionType = collectionType
        self.artistId = artistId
        self.collectionId = collectionId
        self.artistName = artistName
        self.collectionName = collectionName
        self.collectionCensoredName = collectionCensoredName
        self.collectionViewUrl = collectionViewUrl
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        self.collectionExplicitness = collectionExplicitness
        self.trackCount = trackCount
        self.country = country
        self.currency = currency
        self.releaseDate = releaseDate
        self.primaryGenreName = primaryGenreName
    }
}
