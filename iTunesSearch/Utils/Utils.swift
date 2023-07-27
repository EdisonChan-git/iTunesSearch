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
}
