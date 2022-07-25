//
//  CXCustomGraph.swift
//  COXCOMB
//
//  Created by JATIN VERMA on 19/07/22.
//

import Foundation
import UIKit

public class CXCustomGraph: UIView {
    var name:[String] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var value:[Double]
    var color:[UIColor]
    var icons:[UIImage]
    
    let scrollViewParentView = UIView()
    let labelCircle = CAShapeLayer()
    let backLabel = CAShapeLayer()
    let label = UILabel()
    
    
    var selectedIndex = -1
    var total = 0.0
    
    let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    var arclayersCollection: [CALayer] = []
    var labelLayersCollection:[UILabel] = []
    var labelIconsLayersCollection:[UIImageView] = []
    var lineslayersCollection: [CAShapeLayer] = []
    var outerArcLayersCollection:[CAShapeLayer] = []
    var paths: [CGPath] = []
    
    //Collection view to show data
    var collectionView: UICollectionView!
    
    public var delegate:CXCustomGraphProtocol? = nil
    
    public init(name:[String], value: [Double], color: [UIColor], icons: [UIImage]) {
        self.name = name
        self.value = value
        self.color = color
        self.icons = icons
        super.init(frame: .zero)
        setupCollectionView()
        assert(name.count != 0 , "Options must be atleast 1")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.register(OCGraphLabelCollectionViewCell.self, forCellWithReuseIdentifier: OCGraphLabelCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
        collectionView.reloadData()
    }
    
    public func drawChart() {
        total = value.reduce(0, { x, y in
            return x + y
        })
        generateElements()
        setTotalLabelView()
    }

    fileprivate func setTotalLabelView() {
        label.text = stringForValue(total)
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.textColor = .white
        label.frame = CGRect(x: Int(SCREEN_WIDTH/2) - 25 , y: Int(self.bounds.height) - 45, width: 50, height: 50)
        backLabel.path = UIBezierPath(ovalIn: CGRect(x: SCREEN_WIDTH/2 - 20, y: self.bounds.height - 42, width: 40, height: 40)).cgPath
        backLabel.fillColor = UIColor.gray.cgColor
        backLabel.opacity = 0.9
        self.layer.addSublayer(backLabel)
        self.addSubview(label)
    }
    
    fileprivate func generateElements() {
        let angle1 = (Int(120) / Int(value.count))
        let angle = CGFloat(angle1) * CGFloat(3.14 / 120)
        
        var startAngle =  CGFloat(-3.14)
        var endAngle = -(.pi) + CGFloat(angle)
        
        for (i, _) in value.enumerated() {
            var radius = Int(value[i]) * Int(SCREEN_WIDTH * 1.5) / Int(total)
            if radius > 130 {
                radius = 130
            }
            if radius < 15 {
                radius = 15
            }
            let currentPath = UIBezierPath()
            makeLine(radius: Float(radius), startAngle: startAngle, endAngle: endAngle, path: currentPath, index: i)
            makeArc(radius: Float(radius), startAngle: startAngle, endAngle: endAngle, path: currentPath, index: i)
            makeOuterArc(radius: Float(radius), startAngle: startAngle, endAngle: endAngle, path: currentPath, index: i)
            startAngle = endAngle
            endAngle = endAngle + CGFloat(angle)
            currentPath.close()
        }
        self.makeLabelIcons()
    }
    
    fileprivate func makeLine(radius: Float, startAngle:CGFloat, endAngle: CGFloat, path: UIBezierPath, index: Int) {
        let pathLine = UIBezierPath()
        pathLine.move(to: CGPoint(x: SCREEN_WIDTH/2 , y: self.bounds.height - 25))
        pathLine.addArc(withCenter: CGPoint(x: SCREEN_WIDTH/2 , y: self.bounds.height - 25), radius: CGFloat(radius + 40), startAngle: startAngle + 0.25 , endAngle: startAngle + 0.25,  clockwise: true)
        let label = CXLabel().setup(lcolor: color[index], lfont: UIFont(name: "HelveticaNeue-Medium", size: 8)!, lText: stringForValue(value[index]), lFrame: CGRect(x: pathLine.cgPath.currentPoint.x - 10, y: pathLine.cgPath.currentPoint.y - 10, width: 40, height: 10))
        label.sizeToFit()
        self.addSubview(label)
        labelLayersCollection.append(label)
        let shape = CXShapeLayer().add(shapeColor: color[index].cgColor, shapeOpacity: 1, shapeWidth: 1, shapePath: pathLine.cgPath, fillColor: color[index].cgColor, isHidden: false)
        self.layer.addSublayer(shape)
        lineslayersCollection.append(shape)
    }
    
    fileprivate func makeArc(radius: Float, startAngle:CGFloat, endAngle: CGFloat, path: UIBezierPath, index: Int) {
        path.move(to: CGPoint(x: SCREEN_WIDTH/2 , y: self.bounds.height - 25))
        path.addArc(withCenter: CGPoint(x: SCREEN_WIDTH/2 , y: self.bounds.height - 25), radius: CGFloat(radius + 10), startAngle: startAngle, endAngle: endAngle,  clockwise: true)
        
        let shape = CXShapeLayer().add(shapeColor: color[index].cgColor, shapeOpacity: 1, shapeWidth: 0, shapePath: path.cgPath, fillColor: color[index].cgColor, isHidden: false)
        self.layer.addSublayer(shape)
        arclayersCollection.append(shape)
        paths.append(shape.path!)
    }
    
    fileprivate func makeLabelIcons() {
        if icons.count == 0 && icons.count != name.count {
            return
        }
        for (ind,icon) in icons.enumerated() {
            let imageView = UIImageView(image: icon)
            let labelFrame = labelLayersCollection[ind]
            imageView.frame = CGRect(x: labelFrame.center.x - 12.5, y:  labelFrame.center.y - 31, width: 25, height: 25)
            labelIconsLayersCollection.append(imageView)
            self.addSubview(imageView)
        }
    }
    
    fileprivate func makeOuterArc(radius: Float, startAngle:CGFloat, endAngle: CGFloat, path: UIBezierPath, index: Int) {
        path.move(to: CGPoint(x: SCREEN_WIDTH/2 , y: self.bounds.height - 25))
        path.addArc(withCenter: CGPoint(x: SCREEN_WIDTH/2 , y: self.bounds.height - 25), radius: CGFloat(radius + 17), startAngle: startAngle, endAngle: endAngle,  clockwise: true)
        let shape = CXShapeLayer().add(shapeColor: color[index].withAlphaComponent(0.2).cgColor, shapeOpacity: 1, shapeWidth: 0, shapePath: path.cgPath, fillColor: color[index].withAlphaComponent(0.2).cgColor, isHidden: true)
        self.layer.addSublayer(shape)
        outerArcLayersCollection.append(shape)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollViewParentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            scrollViewParentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewParentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            scrollViewParentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    private func stringForValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IN")
        formatter.multiplier = 1.0
        formatter.zeroSymbol = "₹"
        return "₹" + value.kmFormatted
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let sliceLayers = self.arclayersCollection
            var currentIndex = -1
            for (ind, _) in sliceLayers.enumerated() {
                let path = paths[ind]
                if path.contains(touchLocation) {
                    currentIndex = ind
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.layerSelectedAtIndex(index: currentIndex)
                    }
                    break
                }
            }
            if currentIndex == -1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.layerSelectedAtIndex(index: currentIndex)
                }
            }
        }
    }

    
    func layerSelectedAtIndex(index: Int) {
        if index == -1 && self.selectedIndex == -1 {
            return
        }
        if self.selectedIndex == index {
            self.selectedIndex = -1
        }
        else {
            self.selectedIndex = index
        }
        if self.selectedIndex == -1 {
            for layer in self.arclayersCollection {
                layer.opacity = 1
            }
            for layer in self.labelIconsLayersCollection {
                layer.isHidden = false
            }
            for layer2 in self.outerArcLayersCollection {
                layer2.isHidden = true
            }
            for layer2 in self.lineslayersCollection {
                layer2.isHidden = false
            }
            for layer2 in self.labelLayersCollection {
                layer2.isHidden = false
            }
        }
        else {
            for (ind, layer2) in self.arclayersCollection.enumerated() {
                if ind == self.selectedIndex {
                    layer2.opacity = 1
                }
                else {
                    layer2.opacity = 0.1
                }
            }
            for (ind, layer2) in self.labelIconsLayersCollection.enumerated() {
                if ind == self.selectedIndex {
                    layer2.isHidden = false
                    layer2.isHidden = false
                    layer2.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    UIView.animate(withDuration: 0.6, delay: 0,
                                   usingSpringWithDamping: 0.35,
                                   initialSpringVelocity: 7,
                                   options: .curveEaseOut,
                                   animations: {
                        layer2.transform = .identity
                    })
                }
                else {
                    layer2.isHidden = true
                }
            }
            for (ind,layer2) in self.outerArcLayersCollection.enumerated() {
                if (ind == self.selectedIndex) {
                    layer2.isHidden = false
                } else {
                    layer2.isHidden = true
                }
            }
            for (ind,layer2) in self.lineslayersCollection.enumerated() {
                if (ind == self.selectedIndex) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        layer2.isHidden = false
                    }
                } else {
                    layer2.isHidden = true
                }
            }
            for (ind,layer2) in self.labelLayersCollection.enumerated() {
                if (ind == self.selectedIndex) {
                    layer2.isHidden = false
                } else {
                    layer2.isHidden = true
                    
                }
            }

        }
        self.delegate?.didSelectCurrentIndex(index: self.selectedIndex)
        
        //For center circular button
        if self.selectedIndex == -1 {
            backLabel.opacity = 0.9
        }
        else {
            backLabel.opacity = 0.7
        }
        
        //Scroll to particular collectionview
        if selectedIndex != -1 {
            collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        else {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
        collectionView.reloadData()
    }
}

extension CXCustomGraph: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if name.count == 0 {
            return 0
        }
        return name.count == 0 ? 0 : 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return name.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OCGraphLabelCollectionViewCell.identifier, for: indexPath) as! OCGraphLabelCollectionViewCell
        if indexPath.item == selectedIndex {
            cell.graphLabel.textColor = UIColor.black
        }
        else {
            cell.graphLabel.textColor = .lightGray
        }
        cell.graphView.backgroundColor = color[indexPath.item]
        cell.graphLabel.text = name[indexPath.item]
        return cell
        
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = name[indexPath.item]
        let width = UILabel.textWidth(font: UIFont(name: "HelveticaNeue-Medium", size: 10)!, text: text)
        return CGSize(width: width + 35, height: 32)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.layerSelectedAtIndex(index: indexPath.item)
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


extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
}

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

public protocol CXCustomGraphProtocol:AnyObject {
    func didSelectCurrentIndex(index: Int)
}
