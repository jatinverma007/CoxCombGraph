//
//  CXLabel.swift
//  COXCOMB
//
//  Created by JATIN VERMA on 19/07/22.
//

import Foundation
import UIKit

public class CXLabel: UILabel {
    func setup(lcolor: UIColor, lfont: UIFont, lText: String, lFrame:CGRect) -> UILabel {
        self.textColor = lcolor
        self.font = lfont
        self.text = lText
        self.frame = lFrame
        return self
    }
}
