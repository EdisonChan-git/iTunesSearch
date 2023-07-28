//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by EDISON CHAN on 26/7/2023.
//

import XCTest
@testable import iTunesSearch

final class iTunesSearchTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBookmarkSong() {
        // Generate input data
        let result = MusicResult(wrapperType: "track", kind: "song", artistId: 64398046, trackId: 258604731, artistName: "Sara Bareilles", trackName: "Love Song", trackViewUrl: "https://music.apple.com/us/album/love-song/258604731?i=258604737&uo=4", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/e7/ba/51/e7ba51e4-11ae-da4b-5ee3-e2550c14dd3c/mzaf_14379985924893258217.plus.aac.p.m4a", artworkUrl100: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/0c/8a/2e/0c8a2ecb-4f1a-5866-a31d-fcef7ddafbd5/mzi.ofoacfis.jpg/100x100bb.jpg", releaseDate: "2007-06-16T07:00:00Z", country: "USA", primaryGenreName: "Singer/Songwriter")
        Utils.shared.clearFavouriteListFromUserDefault()
        
        //Call bookmark function to add result to bookmarks
        Utils.shared.updateFavouriteList(song: result)
        
        //Get bookmark list from UserDefault
        var bookmarks = Utils.shared.getFavouriteListFromUserDefault()
        
        // Verify bookmarked data
        XCTAssertEqual(bookmarks.count, 1)
        XCTAssertEqual((bookmarks[0] as! MusicResult).trackName, "Love Song")
        
        // Call bookmark function to remove result from bookmarks
        Utils.shared.updateFavouriteList(song: result)
        
        //Get bookmark list from UserDefault after removing
        bookmarks = Utils.shared.getFavouriteListFromUserDefault()
        
        // Verify remain bookmark data
        XCTAssertEqual(bookmarks.count, 0)
    }
    
    func testBookmark() {
        // Generate input data
        let result = MusicResult(wrapperType: "track", kind: "song", artistId: 64398046, trackId: 258604731, artistName: "Sara Bareilles", trackName: "Love Song", trackViewUrl: "https://music.apple.com/us/album/love-song/258604731?i=258604737&uo=4", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/e7/ba/51/e7ba51e4-11ae-da4b-5ee3-e2550c14dd3c/mzaf_14379985924893258217.plus.aac.p.m4a", artworkUrl100: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/0c/8a/2e/0c8a2ecb-4f1a-5866-a31d-fcef7ddafbd5/mzi.ofoacfis.jpg/100x100bb.jpg", releaseDate: "2007-06-16T07:00:00Z", country: "USA", primaryGenreName: "Singer/Songwriter")
        let result2 = MusicResult(wrapperType: "track", kind: "song", artistId: 307054368, trackId: 1153140086, artistName: "中田ヤスタカ", trackName: "NANIMONO (feat. 米津玄師)", trackViewUrl: "https://music.apple.com/jp/album/nanimono-feat-%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB/1153140035?i=1153140086&uo=4", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/b0/dc/c1/b0dcc1c6-c1a0-0da2-ebc8-2835331c19a2/mzaf_3401018843655257391.plus.aac.p.m4a", artworkUrl100: "https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/c5/d0/f5/c5d0f5a1-212a-d7d7-1c4f-c4029689dfd1/190295899776.jpg/100x100bb.jpg", releaseDate: "2016-10-05T12:00:00Z", country: "JPN", primaryGenreName: "エレクトロニック")
        Utils.shared.clearFavouriteListFromUserDefault()
        
        //Call bookmark function to add result to bookmarks
        Utils.shared.updateFavouriteList(song: result)
        Utils.shared.updateFavouriteList(song: result2)
        
        // Call bookmark function to remove result from bookmarks
        Utils.shared.updateFavouriteList(song: result)
        
        //Get bookmark list from UserDefault after removing
        let bookmarks = Utils.shared.getFavouriteListFromUserDefault()
        
        // Verify remain bookmark data
        XCTAssertEqual(bookmarks.count, 1)
        XCTAssertEqual((bookmarks[0] as! MusicResult).country, "JPN")
    }
    
    func testFilter() {
        let result1 = MusicResult(wrapperType: "track", kind: "music-video", artistId: 64398046, trackId: 267380102, artistName: "Sara Bareilles", trackName: "Love Song", trackViewUrl: "https://music.apple.com/us/music-video/love-song/267380102?uo=4", previewUrl: "https://video-ssl.itunes.apple.com/itunes-assets/Video122/v4/18/0e/84/180e848d-9648-c644-42e3-c0e414fadc04/mzvf_14784498319784668519.640x480.h264lc.U.p.m4v", artworkUrl100: "https://is5-ssl.mzstatic.com/image/thumb/Video112/v4/c1/35/6d/c1356d19-a108-45d9-abe1-a282d85750fa/dj.caxnsyrv.jpg/100x100bb.jpg", releaseDate: "2007-06-19T07:00:00Z", country: "USA", primaryGenreName: "Pop")
        let result2 = MusicResult(wrapperType: "track", kind: "song", artistId: 307054368, trackId: 1153140086, artistName: "中田ヤスタカ", trackName: "NANIMONO (feat. 米津玄師)", trackViewUrl: "https://music.apple.com/jp/album/nanimono-feat-%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB/1153140035?i=1153140086&uo=4", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/b0/dc/c1/b0dcc1c6-c1a0-0da2-ebc8-2835331c19a2/mzaf_3401018843655257391.plus.aac.p.m4a", artworkUrl100: "https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/c5/d0/f5/c5d0f5a1-212a-d7d7-1c4f-c4029689dfd1/190295899776.jpg/100x100bb.jpg", releaseDate: "2016-10-05T12:00:00Z", country: "JPN", primaryGenreName: "エレクトロニック")
        let resultArr = NSMutableArray()
        resultArr.add(result1)
        resultArr.add(result2)
        
        let viewModel = HomeSearchViewModel()
        viewModel.searchResult = resultArr
        viewModel.displaySearchResult.accept(resultArr)
        viewModel.configureFilterList()
        
        // Verify filter value
        XCTAssertEqual(viewModel.filterList_country.count, 2)
        XCTAssertTrue(viewModel.filterList_country.contains("USA"))
        XCTAssertTrue(viewModel.filterList_country.contains("JPN"))
        
        XCTAssertEqual(viewModel.filterList_mediaType.count, 2)
        XCTAssertTrue(viewModel.filterList_mediaType.contains("music-video"))
        XCTAssertTrue(viewModel.filterList_mediaType.contains("song"))
        
        //test filer case [country : JPN]
        viewModel.selected_filter_mediaType = []
        viewModel.selected_filter_country = ["JPN"]
        viewModel.performFilterOperation()
        
        // Verify filter result
        XCTAssertEqual(viewModel.displaySearchResult.value.count, 1)
        
        //test filer case [country : JPN, USA]
        viewModel.selected_filter_mediaType = []
        viewModel.selected_filter_country = ["JPN","USA"]
        viewModel.performFilterOperation()
        
        // Verify filter result
        XCTAssertEqual(viewModel.displaySearchResult.value.count, 2)
        
        //test filer case [Country : JPN, Media Type : music-video]
        viewModel.selected_filter_mediaType = ["music-video"]
        viewModel.selected_filter_country = ["JPN"]
        viewModel.performFilterOperation()
        
        // Verify filter result
        XCTAssertEqual(viewModel.displaySearchResult.value.count, 0)
        
        //test filer case [Country : USA, Media Type : music-video]
        viewModel.selected_filter_mediaType = ["music-video"]
        viewModel.selected_filter_country = ["USA"]
        viewModel.performFilterOperation()
        
        // Verify filter result
        XCTAssertEqual(viewModel.displaySearchResult.value.count, 1)
        
        //test filer case [Country : USA, JPN, Media Type : music-video]
        viewModel.selected_filter_mediaType = ["music-video"]
        viewModel.selected_filter_country = ["USA","JPN"]
        viewModel.performFilterOperation()
        
        // Verify filter result
        XCTAssertEqual(viewModel.displaySearchResult.value.count, 1)
        
        //test filer case [Country : USA, JPN, Media Type : music-video, song]
        viewModel.selected_filter_mediaType = ["music-video","song"]
        viewModel.selected_filter_country = ["USA","JPN"]
        viewModel.performFilterOperation()
        
        // Verify filter result
        XCTAssertEqual(viewModel.displaySearchResult.value.count, 2)
        
    }

}
