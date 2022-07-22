//
//  CXShapeLayer.swift
//  COXCOMB
//
//  Created by JATIN VERMA on 19/07/22.
//

import Foundation
import UIKit


public class CXShapeLayer: CAShapeLayer {
    
    public func add(shapeColor: CGColor, shapeOpacity: Float, shapeWidth: CGFloat, shapePath:CGPath?, fillColor: CGColor?, isHidden: Bool) -> CAShapeLayer {
        self.strokeColor = shapeColor
        self.opacity = shapeOpacity
        self.lineWidth = shapeWidth
        self.path = shapePath
        self.fillColor = fillColor
        self.isHidden = isHidden
        return self
    }

    
}
