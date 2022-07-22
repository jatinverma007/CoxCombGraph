//
//  Double+Extension.swift
//  COXCOMB
//
//  Created by JATIN VERMA on 19/07/22.
//

import Foundation
extension Double {
    var kmFormatted: String {
        
        if self >= 1000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale(identifier: "en_IN"),self/1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale(identifier: "en_IN"),self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale(identifier: "en_IN"),self)
    }
    
}
