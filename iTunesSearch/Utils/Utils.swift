//
//  Utils.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation

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
