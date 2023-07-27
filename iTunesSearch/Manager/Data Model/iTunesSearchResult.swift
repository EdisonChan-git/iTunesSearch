//
//  iTunesSearchResult.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

class iTunesSearchResult: NSObject {
    var resultCount: Int!
    var results: [MusicResult]!
    
    init(resultCount: Int, results: [MusicResult]) {
        self.resultCount = resultCount
        self.results = results
    }
        
    // Convenience initializer to create an `iTunesSearchResult` object from JSON data
    convenience init?(json: [String: Any]) {
        guard let resultCount = json["resultCount"] as? Int,
              let resultsJSON = json["results"] as? [[String: Any]] else {
            return nil
        }
        
        var results = [MusicResult]()
        for resultJSON in resultsJSON {
            if let result = MusicResult(json: resultJSON) {
                results.append(result)
            }
        }
        
        self.init(resultCount: resultCount, results: results)
    }
}

class MusicResult: NSObject {
    var wrapperType: String?
    var kind: String?
    var artistId: Int?
    var collectionId: Int?
    var trackId: Int?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
    var collectionCensoredName: String?
    var trackCensoredName: String?
    var artistViewUrl: String?
    var collectionViewUrl: String?
    var trackViewUrl: String?
    var previewUrl: String?
    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var collectionPrice: Double?
    var trackPrice: Double?
    var releaseDate: String?
    var collectionExplicitness: String?
    var trackExplicitness: String?
    var discCount: Int?
    var discNumber: Int?
    var trackCount: Int?
    var trackNumber: Int?
    var trackTimeMillis: Int?
    var country: String?
    var currency: String?
    var primaryGenreName: String?
    var isStreamable: Bool?
    
    init(wrapperType: String?, kind: String?, artistId: Int?, collectionId: Int?, trackId: Int?, artistName: String?, collectionName: String?, trackName: String?, collectionCensoredName: String?, trackCensoredName: String?, artistViewUrl: String?, collectionViewUrl: String?, trackViewUrl: String?, previewUrl: String?, artworkUrl30: String?, artworkUrl60: String?, artworkUrl100: String?, collectionPrice: Double?, trackPrice: Double?, releaseDate: String?, collectionExplicitness: String?, trackExplicitness: String?, discCount: Int?, discNumber: Int?, trackCount: Int?, trackNumber: Int?, trackTimeMillis: Int?, country: String?, currency: String?, primaryGenreName: String?, isStreamable: Bool?) {
        self.wrapperType = wrapperType
        self.kind = kind
        self.artistId = artistId
        self.collectionId = collectionId
        self.trackId = trackId
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.collectionCensoredName = collectionCensoredName
        self.trackCensoredName = trackCensoredName
        self.artistViewUrl = artistViewUrl
        self.collectionViewUrl = collectionViewUrl
        self.trackViewUrl = trackViewUrl
        self.previewUrl = previewUrl
        self.artworkUrl30 = artworkUrl30
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.releaseDate = releaseDate
        self.collectionExplicitness = collectionExplicitness
        self.trackExplicitness = trackExplicitness
        self.discCount = discCount
        self.discNumber = discNumber
        self.trackCount = trackCount
        self.trackNumber = trackNumber
        self.trackTimeMillis = trackTimeMillis
        self.country = country
        self.currency = currency
        self.primaryGenreName = primaryGenreName
        self.isStreamable = isStreamable
    }
    
    convenience init?(json: [String: Any]) {
        self.init(
            wrapperType: json["wrapperType"] as? String,
            kind: json["kind"] as? String,
            artistId: json["artistId"] as? Int,
            collectionId: json["collectionId"] as? Int,
            trackId: json["trackId"] as? Int,
            artistName: json["artistName"] as? String,
            collectionName: json["collectionName"] as? String,
            trackName: json["trackName"] as? String,
            collectionCensoredName: json["collectionCensoredName"] as? String,
            trackCensoredName: json["trackCensoredName"] as? String,
            artistViewUrl: json["artistViewUrl"] as? String,
            collectionViewUrl: json["collectionViewUrl"] as? String,
            trackViewUrl: json["trackViewUrl"] as? String,
            previewUrl: json["previewUrl"] as? String,
            artworkUrl30: json["artworkUrl30"] as? String,
            artworkUrl60: json["artworkUrl60"] as? String,
            artworkUrl100: json["artworkUrl100"] as? String,
            collectionPrice: json["collectionPrice"] as? Double,
            trackPrice: json["trackPrice"] as? Double,
            releaseDate: json["releaseDate"] as? String,
            collectionExplicitness: json["collectionExplicitness"] as? String,
            trackExplicitness: json["trackExplicitness"] as? String,
            discCount: json["discCount"] as? Int,
            discNumber: json["discNumber"] as? Int,
            trackCount: json["trackCount"] as? Int,
            trackNumber: json["trackNumber"] as? Int,
            trackTimeMillis: json["trackTimeMillis"] as? Int,
            country: json["country"] as? String,
            currency: json["currency"] as? String,
            primaryGenreName: json["primaryGenreName"] as? String,
            isStreamable: json["isStreamable"] as? Bool
        )
    }
}
