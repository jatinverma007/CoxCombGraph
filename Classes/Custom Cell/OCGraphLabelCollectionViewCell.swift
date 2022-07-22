//
//  OCGraphLabelCollectionViewCell.swift
//  TestCoreData
//
//  Created by JATIN VERMA on 19/07/22.
//

import UIKit

class OCGraphLabelCollectionViewCell: UICollectionViewCell {
    
    
    var graphLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var graphView: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "OCGraphLabelCollectionViewCell"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(graphLabel)
        self.addSubview(graphView)
        graphView.layer.cornerRadius = 2
        graphView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        graphView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        graphView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        graphLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        graphLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        graphLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
