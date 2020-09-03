//
//  CurrencyConverter.swift
//  Market
//
//  Created by mac retina on 2/20/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation


func convertCurrecny (_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
