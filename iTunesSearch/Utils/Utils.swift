//
//  Utils.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation
import UIKit

extension String {
    func localize(comment: String = "") -> String {
        let defaultLanguage = "en"
        let appLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ?? defaultLanguage
        let value = NSLocalizedString(self, comment: comment)
        if value != self || Locale.preferredLanguages.first?.hasPrefix(appLanguage) == true {
            return value // String localization was found
        }

        // Load resource for app language to be used as the fallback language
        guard let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return value
        }

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
    func publishDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = formatter.date(from: self) {
            let publishDateFormatter = DateFormatter()
            publishDateFormatter.dateFormat = "yyyy-MM-dd"
            publishDateFormatter.locale = Locale.current
            return publishDateFormatter.string(from: date)
        }
        
        return ""
    }
    
    func publishYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = formatter.date(from: self) {
            let publishDateFormatter = DateFormatter()
            publishDateFormatter.dateFormat = "yyyy"
            publishDateFormatter.locale = Locale.current
            return publishDateFormatter.string(from: date)
        }
        
        return ""
    }
}

class Utils {
    static let shared = Utils()
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            showAlert(title: "Error", message: "Invalid URL: \(urlString)")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Error", message: "Cannot open URL: \(urlString)")
        }
    }
    
    func updateLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name("AppLanguageDidChange"), object: nil)
    }
    
    func updateFavouriteList(song: MusicResult) {
        let list = getFavouriteListFromUserDefault()
        
        if(!checkIfSongIsExistInFavouriteList(song: song)){
            print("add \(song.trackName!)")
            let newList = NSMutableArray(array: list).adding(song) as! [MusicResult]
            
            let encoder = PropertyListEncoder()
            if let encodedList = try? encoder.encode(newList) {
                // Store the encoded data in user defaults
                UserDefaults.standard.set(encodedList, forKey: "myList")
                UserDefaults.standard.synchronize()
            }
        }else{
            print("remove \(song.trackName!)")
            let newList = NSMutableArray()
            for item in list {
                if let musicItem = item as? MusicResult {
                    if(musicItem.trackId != song.trackId){
                        newList.add(musicItem)
                    }
                }
            }
            
            let encoder = PropertyListEncoder()
            if let encodedList = try? encoder.encode(newList as! [MusicResult]) {
                // Store the encoded data in user defaults
                UserDefaults.standard.set(encodedList, forKey: "myList")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func checkIfSongIsExistInFavouriteList(song: MusicResult) -> Bool{
        var IsExisted = false
        let list = getFavouriteListFromUserDefault()
        
        for item in list {
            if let musicItem = item as? MusicResult {
                if(musicItem.trackId == song.trackId){
                    IsExisted = true
                }
            }
        }
        
        return IsExisted
    }
    
    func getFavouriteListFromUserDefault() -> NSMutableArray {
        let decoder = PropertyListDecoder()
        if let savedList = UserDefaults.standard.data(forKey: "myList"),
           let decodedList = try? decoder.decode([MusicResult].self, from: savedList) {
            return NSMutableArray(array: decodedList)
        } else {
            return NSMutableArray()
        }
    }
    
}
