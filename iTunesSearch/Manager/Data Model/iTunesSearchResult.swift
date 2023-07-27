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
            if let result = MusicResult(dictionary: resultJSON) {
                results.append(result)
            }
        }
        
        self.init(resultCount: resultCount, results: results)
    }
}

class MusicResult: NSObject, Codable, NSCoding {
    var wrapperType: String?
    var kind: String?
    var artistId: Int?
    var collectionId: Int?
    var trackId: Int?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
    var trackViewUrl: String?
    var previewUrl: String?
    var artworkUrl100: String?
    var releaseDate: String?
    var country: String?
    var primaryGenreName: String?
    
    init(wrapperType: String?, kind: String?, artistId: Int?, collectionId: Int?, trackId: Int?, artistName: String?, collectionName: String?, trackName: String?, trackViewUrl: String?, previewUrl: String?, artworkUrl100: String?, releaseDate: String?, country: String?, primaryGenreName: String?) {
        self.wrapperType = wrapperType
        self.kind = kind
        self.artistId = artistId
        self.collectionId = collectionId
        self.trackId = trackId
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.trackViewUrl = trackViewUrl
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
        self.releaseDate = releaseDate
        self.country = country
        self.primaryGenreName = primaryGenreName
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let wrapperType = dictionary["wrapperType"] as? String,
            let kind = dictionary["kind"] as? String,
            let artistId = dictionary["artistId"] as? Int,
            let collectionId = dictionary["collectionId"] as? Int,
            let trackId = dictionary["trackId"] as? Int,
            let artistName = dictionary["artistName"] as? String,
            let collectionName = dictionary["collectionName"] as? String,
            let trackName = dictionary["trackName"] as? String,
            let trackViewUrl = dictionary["trackViewUrl"] as? String,
            let previewUrl = dictionary["previewUrl"] as? String,
            let artworkUrl100 = dictionary["artworkUrl100"] as? String,
            let releaseDate = dictionary["releaseDate"] as? String,
            let country = dictionary["country"] as? String,
            let primaryGenreName = dictionary["primaryGenreName"] as? String else {
                return nil
        }
        
        self.init(wrapperType: wrapperType, kind: kind, artistId: artistId, collectionId: collectionId, trackId: trackId, artistName: artistName, collectionName: collectionName, trackName: trackName, trackViewUrl: trackViewUrl, previewUrl: previewUrl, artworkUrl100: artworkUrl100, releaseDate: releaseDate, country: country, primaryGenreName: primaryGenreName)
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case kind
        case artistId
        case collectionId
        case trackId
        case artistName
        case collectionName
        case trackName
        case trackViewUrl
        case previewUrl
        case artworkUrl100
        case releaseDate
        case country
        case primaryGenreName
    }
    
    struct PropertyKey {
        static let wrapperType = "wrapperType"
        static let kind = "kind"
        static let artistId = "artistId"
        static let collectionId = "collectionId"
        static let trackId = "trackId"
        static let artistName = "artistName"
        static let collectionName = "collectionName"
        static let trackName = "trackName"
        static let trackViewUrl = "trackViewUrl"
        static let previewUrl = "previewUrl"
        static let artworkUrl100 = "artworkUrl100"
        static let releaseDate = "releaseDate"
        static let country = "country"
        static let primaryGenreName = "primaryGenreName"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(wrapperType, forKey: PropertyKey.wrapperType)
        coder.encode(kind, forKey: PropertyKey.kind)
        coder.encode(artistId, forKey: PropertyKey.artistId)
        coder.encode(collectionId, forKey: PropertyKey.collectionId)
        coder.encode(trackId, forKey: PropertyKey.trackId)
        coder.encode(artistName, forKey: PropertyKey.artistName)
        coder.encode(collectionName, forKey: PropertyKey.collectionName)
        coder.encode(trackName, forKey: PropertyKey.trackName)
        coder.encode(trackViewUrl, forKey: PropertyKey.trackViewUrl)
        coder.encode(previewUrl, forKey: PropertyKey.previewUrl)
        coder.encode(artworkUrl100, forKey: PropertyKey.artworkUrl100)
        coder.encode(releaseDate, forKey: PropertyKey.releaseDate)
        coder.encode(country, forKey: PropertyKey.country)
        coder.encode(primaryGenreName, forKey: PropertyKey.primaryGenreName)
    }
    
    required convenience init?(coder: NSCoder) {
        let wrapperType = coder.decodeObject(forKey: PropertyKey.wrapperType) as! String
        let kind = coder.decodeObject(forKey: PropertyKey.kind) as! String
        let artistId = coder.decodeInteger(forKey: PropertyKey.artistId)
        let collectionId = coder.decodeInteger(forKey: PropertyKey.collectionId)
        let trackId = coder.decodeInteger(forKey: PropertyKey.trackId)
        let artistName = coder.decodeObject(forKey: PropertyKey.artistName) as! String
        let collectionName = coder.decodeObject(forKey: PropertyKey.collectionName) as! String
        let trackName = coder.decodeObject(forKey: PropertyKey.trackName) as! String
        let trackViewUrl = coder.decodeObject(forKey: PropertyKey.trackViewUrl) as! String
        let previewUrl = coder.decodeObject(forKey: PropertyKey.previewUrl) as! String
        let artworkUrl100 = coder.decodeObject(forKey: PropertyKey.artworkUrl100) as! String
        let releaseDate = coder.decodeObject(forKey: PropertyKey.releaseDate) as! String
        let country = coder.decodeObject(forKey: PropertyKey.country) as! String
        let primaryGenreName = coder.decodeObject(forKey: PropertyKey.primaryGenreName) as! String
        
        self.init(
            wrapperType: wrapperType,
            kind: kind,
            artistId: artistId,
            collectionId: collectionId,
            trackId: trackId,
            artistName: artistName,
            collectionName: collectionName,
            trackName: trackName,
            trackViewUrl: trackViewUrl,
            previewUrl: previewUrl,
            artworkUrl100: artworkUrl100,
            releaseDate: releaseDate,
            country: country,
            primaryGenreName: primaryGenreName
        )
    }
}
