//
//  Utils.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation
import UIKit

extension String {
    /**
    Localizes a string based on the user's preferred language setting in UserDefaults.
    Parameter comment: An optional description for the localized string.
    Returns: The localized version of the string, or the original string if a localized version could not be found.
    */
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
    
    /**
    Returns the formatted publish date string for a given date string in ISO 8601 format.
    Returns: A string representing the date in "yyyy-MM-dd" format, or an empty string if the input string is not in the correct format.
    */
    func publishDate() -> String {
        // Create a date formatter for the ISO 8601 format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        // Attempt to convert the input string to a Date object using the ISO 8601 formatter
        if let date = formatter.date(from: self) {
            // If the conversion is successful, create a new date formatter for the desired output format
            let publishDateFormatter = DateFormatter()
            publishDateFormatter.dateFormat = "yyyy-MM-dd"
            publishDateFormatter.locale = Locale.current
            
            // Format the date as a string using the desired output format
            return publishDateFormatter.string(from: date)
        }
        
        return ""
    }
    
    /**
    Returns the formatted publish year string for a given date string in ISO 8601 format.
    Returns: A string representing the year in "yyyy" format, or an empty string if the input string is not in the correct format.
    */
    func publishYear() -> String {
        // Create a date formatter for the ISO 8601 format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        // Attempt to convert the input string to a Date object using the ISO 8601 formatter
        if let date = formatter.date(from: self) {
            // If the conversion is successful, create a new date formatter for the desired output format
            let publishDateFormatter = DateFormatter()
            publishDateFormatter.dateFormat = "yyyy"
            publishDateFormatter.locale = Locale.current
            
            // Format the date as a string using the desired output format
            return publishDateFormatter.string(from: date)
        }
        
        return ""
    }
}

class Utils {
    static let shared = Utils()
    
    /**
    Displays an alert with the given title and message.
    Parameters:
        title: The title of the alert.
        message: The message to display in the alert.
    */
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    /**
    Attempts to open the URL specified by the given string.
    Parameters:
        urlString: The URL string to open.
    */
    func openURL(_ urlString: String) {
        // Attempt to create a URL object from the given string
        guard let url = URL(string: urlString) else {
            // If the URL is invalid, display an error alert and return
            showAlert(title: "Error", message: "Invalid URL: \(urlString)")
            return
        }
        
        // Check if the app can open the given URL
        if UIApplication.shared.canOpenURL(url) {
            // If the app can open the URL, open it
            UIApplication.shared.open(url)
        } else {
            // If the app cannot open the URL, display an error alert
            showAlert(title: "Error", message: "Cannot open URL: \(urlString)")
        }
    }
    
    /**
    Updates the user's preferred language setting and posts a notification to notify other parts of the app that the language setting has changed.
    Parameters:
        lang: The new language setting to set.
    */
    func updateLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name("AppLanguageDidChange"), object: nil)
    }
    
    /**
    Updates the user's favorite list of music tracks in UserDefaults with the given song. It adds or removes the given song to/from the favorite list based on whether it is already present in the list or not.
    Parameters:
        song: The song to add or remove from the favorite list.
    */
    func updateFavouriteList(song: MusicResult) {
        // Get the current favorite list from UserDefaults
        let list = getFavouriteListFromUserDefault()
        
        if(!checkIfSongIsExistInFavouriteList(song: song)){
            // If the given song is not already in the favorite list, add it to the list
            let newList = NSMutableArray(array: list).adding(song) as! [MusicResult]
            
            let encoder = PropertyListEncoder()
            if let encodedList = try? encoder.encode(newList) {
                // Store the encoded data in user defaults
                UserDefaults.standard.set(encodedList, forKey: "myList")
                UserDefaults.standard.synchronize()
            }
        }else{
            // If the given song is already in the favorite list, remove it from the list
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
    /**
    Checks if the given song is already present in the user's favorite list of music tracks.
    Parameters:
        song: The song to check for existence in the favorite list.
    Returns: A Boolean value indicating whether the given song is already present in the user's favorite list.
    */
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
    
    /**
    Retrieves the user's favorite list of music tracks from UserDefaults.
    Returns: An NSMutableArray containing the user's favorite list of music tracks.
    */
    func getFavouriteListFromUserDefault() -> NSMutableArray {
        let decoder = PropertyListDecoder()
        if let savedList = UserDefaults.standard.data(forKey: "myList"),
           let decodedList = try? decoder.decode([MusicResult].self, from: savedList) {
            return NSMutableArray(array: decodedList)
        } else {
            return NSMutableArray()
        }
    }
    
    /**
    Clears the user's favorite list of music tracks from UserDefaults.
    */
    func clearFavouriteListFromUserDefault() {
        UserDefaults.standard.removeObject(forKey: "myList")
        UserDefaults.standard.synchronize()
    }
    
}
