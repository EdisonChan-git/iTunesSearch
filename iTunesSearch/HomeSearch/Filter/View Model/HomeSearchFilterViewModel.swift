//
//  HomeSearchFilterViewModel.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 27/7/2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeSearchFilterViewModel{
    var raw_filterList_country: NSMutableArray
    var raw_filterList_mediaType: NSMutableArray
    
    let selcted_country = BehaviorRelay<NSMutableArray>(value: NSMutableArray())
    let selcted_mediaType = BehaviorRelay<NSMutableArray>(value: NSMutableArray())
    
    init(raw_filterList_country: NSMutableArray, raw_filterList_mediaType: NSMutableArray) {
        self.raw_filterList_country = raw_filterList_country
        self.raw_filterList_mediaType = raw_filterList_mediaType
    }
    
    /**
    Resets selected filter values.
    */
    func resetFilter()  {
        selcted_country.accept(NSMutableArray())
        selcted_mediaType.accept(NSMutableArray())
    }
}
