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
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            collectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
        collectionView.reloadData()
    }
    
    func drawChart() {
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
        label.frame = CGRect(x: Int(SCREEN_WIDTH/2) - 25 , y: Int(self.bounds.height) - 75, width: 50, height: 50)
        backLabel.path = UIBezierPath(ovalIn: CGRect(x: SCREEN_WIDTH/2 - 20, y: self.bounds.height - 72, width: 40, height: 40)).cgPath
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
            if radius > 135 {
                radius = 135
            }
            if radius < 35 {
                radius = 35
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
        pathLine.move(to: CGPoint(x: SCREEN_WIDTH/2 , y: 300))
        pathLine.addArc(withCenter: CGPoint(x: SCREEN_WIDTH/2 , y: 300), radius: CGFloat(radius + 40), startAngle: startAngle + 0.25 , endAngle: startAngle + 0.25,  clockwise: true)
        let label = CXLabel().setup(lcolor: color[index], lfont: UIFont(name: "HelveticaNeue-Medium", size: 8)!, lText: stringForValue(value[index]), lFrame: CGRect(x: pathLine.cgPath.currentPoint.x - 10, y: pathLine.cgPath.currentPoint.y - 10, width: 100, height: 10))
        self.addSubview(label)
        labelLayersCollection.append(label)
        let shape = CXShapeLayer().add(shapeColor: color[index].cgColor, shapeOpacity: 1, shapeWidth: 1, shapePath: pathLine.cgPath, fillColor: color[index].cgColor, isHidden: false)
        self.layer.addSublayer(shape)
        lineslayersCollection.append(shape)
    }
    
    fileprivate func makeArc(radius: Float, startAngle:CGFloat, endAngle: CGFloat, path: UIBezierPath, index: Int) {
        path.move(to: CGPoint(x: SCREEN_WIDTH/2 , y: 300))
        path.addArc(withCenter: CGPoint(x: SCREEN_WIDTH/2 , y: 300), radius: CGFloat(radius + 10), startAngle: startAngle, endAngle: endAngle,  clockwise: true)
        
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
            imageView.frame = CGRect(x: labelFrame.frame.minX - 6, y:  labelFrame.frame.minY - 27, width: 30, height: 30)
            labelIconsLayersCollection.append(imageView)
            self.addSubview(imageView)
        }
    }
    
    fileprivate func makeOuterArc(radius: Float, startAngle:CGFloat, endAngle: CGFloat, path: UIBezierPath, index: Int) {
        path.move(to: CGPoint(x: SCREEN_WIDTH/2 , y: 300))
        path.addArc(withCenter: CGPoint(x: SCREEN_WIDTH/2 , y: 300), radius: CGFloat(radius + 17), startAngle: startAngle, endAngle: endAngle,  clockwise: true)
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
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let sliceLayers = self.arclayersCollection
            var currentIndex = -1
            for (index, _) in sliceLayers.enumerated() {
                let path = paths[index]
                if path.contains(touchLocation) {
                    currentIndex = index
                    break
                }
            }
            self.layerSelectedAtIndex(index: currentIndex)
        }
        super.touchesBegan(touches, with:event)
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
        
        //For Circular Arc
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedIndex == -1 {
                for layer in self.arclayersCollection {
                    layer.opacity = 1
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
            }
        }
        
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
        
        //For selected labels icons
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedIndex == -1 {
                for layer2 in self.labelIconsLayersCollection {
                    layer2.isHidden = false
                }
            }
            else {
                for (ind,layer2) in self.labelIconsLayersCollection.enumerated() {
                    if (ind == self.selectedIndex) {
                        layer2.isHidden = false
                        layer2.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        UIView.animate(withDuration: 0.6, delay: 0,
                                       usingSpringWithDamping: 0.35,
                                       initialSpringVelocity: 7,
                                       options: .curveEaseOut,
                                       animations: {
                            layer2.transform = .identity
                        })
                        
                    } else {
                        layer2.isHidden = true
                    }
                }
                
            }
        }
        
        //For circular arc with low opacity
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedIndex == -1 {
                for layer2 in self.outerArcLayersCollection {
                    layer2.isHidden = true
                }
            }
            else {
                for (ind,layer2) in self.outerArcLayersCollection.enumerated() {
                    if (ind == self.selectedIndex) {
                        layer2.isHidden = false
                    } else {
                        layer2.isHidden = true
                    }
                }
                
            }
        }
        
        //For lines
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedIndex == -1 {
                for layer2 in self.lineslayersCollection {
                    layer2.isHidden = false
                }
            }
            else {
                for (ind,layer2) in self.lineslayersCollection.enumerated() {
                    if (ind == self.selectedIndex) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            layer2.isHidden = false
                        }
                    } else {
                        layer2.isHidden = true
                    }
                }
                
            }
        }

        
        //For labels
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedIndex == -1 {
                for layer2 in self.labelLayersCollection {
                    layer2.isHidden = false
                    
                }
            }
            else {
                for (ind,layer2) in self.labelLayersCollection.enumerated() {
                    if (ind == self.selectedIndex) {
                        layer2.isHidden = false
                    } else {
                        layer2.isHidden = true
                        
                    }
                }
                
            }
        }
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
