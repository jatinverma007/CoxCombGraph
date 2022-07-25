//
//  ViewController.swift
//  CustomCoxcombLibrary
//
//  Created by jatinverma007 on 07/22/2022.
//  Copyright (c) 2022 jatinverma007. All rights reserved.
//

import UIKit
import CustomCoxcombLibrary

class ViewController: UIViewController, CXCustomGraphProtocol {
    func didSelectCurrentIndex(index: Int) {
        print(index)
    }
    

    var customGraph:CXCustomGraph!

    override func viewDidLoad() {
        super.viewDidLoad()
        customGraph = CXCustomGraph(name: ["Health & Lifestyle", "Food & Grocery", "Added Money", "Shopping", "Recharge"], value: [20, 1, 17, 11, 22], color: [UIColor.hexStringToUIColor(hex: "852929"), UIColor.hexStringToUIColor(hex: "53b7ff"), UIColor.hexStringToUIColor(hex: "3be05c"), UIColor.hexStringToUIColor(hex: "da7804"), UIColor.hexStringToUIColor(hex: "e4cf29")], icons: [returnIconAccordingToCategory(category: "Health & Lifestyle"), returnIconAccordingToCategory(category: "Food & Grocery"), returnIconAccordingToCategory(category: "Added Money"), returnIconAccordingToCategory(category: "Shopping"), returnIconAccordingToCategory(category: "Recharge")])
        customGraph.delegate = self
        self.view.addSubview(customGraph!)
        customGraph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            customGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            customGraph.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            customGraph.heightAnchor.constraint(equalToConstant: 270)
        ])
    }

    func returnIconAccordingToCategory(category: String) -> UIImage {
        switch category {
        case "Health & Lifestyle":
            return UIImage(named: "icon-health-lifestyle")!
        case "Food & Grocery":
            return UIImage(named: "icon-food-grocery")!
        case "Added Money":
            return UIImage(named: "icon-added-money")!
        case "Shopping":
            return UIImage(named: "icon-shopping")!
        case "Recharge":
            return UIImage(named: "icon-recharge")!
        default:
            return UIImage(named: "icon-recharge")!
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customGraph.drawChart()
    }

}


extension UIColor {
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
