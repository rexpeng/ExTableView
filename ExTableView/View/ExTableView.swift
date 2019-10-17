//
//  ExTableView.swift
//  ExTableView
//
//  Created by Rex Peng on 2019/10/17.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

class ExTableView: UIView {
    
    var fixColCollectionView: UICollectionView!
    var fixRowCollectionView: UICollectionView!
    var fixDataCollectionView: UICollectionView!
    var dataCollectionView: UICollectionView!
    var cellSize: CGSize = .zero
    
    var cellDatas: [[String]] = []
    
    var sPoint: CGPoint = .zero
    
    var fixCol: Int = 2
    var fixRow: Int = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellSize = CGSize(width: 50, height: 50)
        dataCollectionView.frame = CGRect(x: CGFloat(fixCol)*50, y: CGFloat(fixRow)*50, width: CGFloat(20-fixCol)*50, height: bounds.height-CGFloat(fixRow)*50)
        if fixCol > 0 {
            fixColCollectionView.frame = CGRect(x: 0, y: CGFloat(fixRow)*50, width: CGFloat(fixCol)*50, height: bounds.height-CGFloat(fixRow)*50)
            fixColCollectionView.layer.addShadow(offset: .zero, opacity: 0.8, redius: 2)
            //bringSubviewToFront(fixColCollectionView)
        }
        if fixRow > 0 {
            fixRowCollectionView.frame = CGRect(x: CGFloat(fixCol)*50, y: 0, width: CGFloat(20-fixCol)*50, height: CGFloat(fixRow)*50)
            fixRowCollectionView.layer.addShadow(offset: .zero, opacity: 0.8, redius: 2)
            //bringSubviewToFront(fixRowCollectionView)
        }
        if fixCol > 0 && fixRow > 0 {
            fixDataCollectionView.frame = CGRect(x: 0, y: 0, width: CGFloat(fixCol)*50, height: CGFloat(fixRow)*50)
            fixDataCollectionView.layer.addShadow(offset: .zero, opacity: 0.8, redius: 2)
            //bringSubviewToFront(fixDataCollectionView)
        }
    }
    
    
    func setup() {
        self.clipsToBounds = true
        self.backgroundColor = .lightGray
        for r in 0..<20 {
            var cols: [String] = []
            for c in 0..<20 {
                cols.append("\(r)-\(c)")
            }
            cellDatas.append(cols)
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        dataCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        dataCollectionView.backgroundColor = .clear
        addSubview(dataCollectionView)
        
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        
        dataCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "exCell")
        
        dataCollectionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(cvPanAction)))
        
        setupFixRowView()
        setupFixColView()
        setupFixDataView()
    }
    
    func setupFixColView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        fixColCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        fixColCollectionView.backgroundColor = .clear
        addSubview(fixColCollectionView)
        
        fixColCollectionView.delegate = self
        fixColCollectionView.dataSource = self
        
        fixColCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "exCell")
        
        fixColCollectionView.isScrollEnabled = false
    }

    func setupFixRowView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        fixRowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        fixRowCollectionView.backgroundColor = .clear
        addSubview(fixRowCollectionView)
        
        fixRowCollectionView.delegate = self
        fixRowCollectionView.dataSource = self
        
        fixRowCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "exCell")
        
        fixRowCollectionView.isScrollEnabled = false
    }
    
    func setupFixDataView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        fixDataCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        fixDataCollectionView.backgroundColor = .clear
        addSubview(fixDataCollectionView)
        
        fixDataCollectionView.delegate = self
        fixDataCollectionView.dataSource = self
        
        fixDataCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "exCell")
        
        fixDataCollectionView.isScrollEnabled = false
    }

    @objc func cvPanAction(_ sender: UIPanGestureRecognizer) {
        let state = sender.state
        switch state {
        case .began:
            sPoint = sender.translation(in: dataCollectionView)
            break;
        case .changed:
            let epoint = sender.translation(in: dataCollectionView)
            var orgX = dataCollectionView.bounds.origin.x
            var orgY = dataCollectionView.bounds.origin.y
            var fixOrgY = fixColCollectionView.bounds.origin.y
            var fixOrgX = fixRowCollectionView.bounds.origin.x
            orgX -= (epoint.x-sPoint.x)
            orgY -= (epoint.y-sPoint.y)
            
            fixOrgX -= (epoint.x-sPoint.x)
            fixOrgY -= (epoint.y-sPoint.y)
            
            if orgX >= 0 {
                dataCollectionView.bounds.origin.x = orgX
                fixRowCollectionView.bounds.origin.x = fixOrgX
            } else if fixCol <= 0 {
                dataCollectionView.bounds.origin.x = orgX
                fixRowCollectionView.bounds.origin.x = fixOrgX
            }
            if orgY >= 0 {
                dataCollectionView.bounds.origin.y = orgY
                fixColCollectionView.bounds.origin.y = fixOrgY
            } else if fixRow <= 0 {
                //bringSubviewToFront(fixRowCollectionView)
                dataCollectionView.bounds.origin.y = orgY
                fixColCollectionView.bounds.origin.y = fixOrgY
            }
            
            sPoint = epoint
        case .ended:
            boundsBack()
            break;
        default:
            break;
        }
        
    }
    
    func boundsBack() {
        if dataCollectionView.bounds.origin.y < 0 {
            UIView.animate(withDuration: 0.2) {
                self.dataCollectionView.bounds.origin.y = 0
                self.fixColCollectionView.bounds.origin.y = 0
            }
        }
        if dataCollectionView.bounds.origin.x < 0 {
            UIView.animate(withDuration: 0.2) {
                self.dataCollectionView.bounds.origin.x = 0
                self.fixRowCollectionView.bounds.origin.x = 0
            }
        }
        if dataCollectionView.contentSize.height-dataCollectionView.bounds.origin.y < bounds.height-dataCollectionView.frame.origin.y {
            UIView.animate(withDuration: 0.2) {
                self.dataCollectionView.bounds.origin.y = self.dataCollectionView.contentSize.height-(self.bounds.height-self.dataCollectionView.frame.origin.y)
                self.fixColCollectionView.bounds.origin.y = self.fixColCollectionView.contentSize.height-(self.bounds.height-self.dataCollectionView.frame.origin.y)
            }
        }
        if dataCollectionView.contentSize.width-dataCollectionView.bounds.origin.x < bounds.width-dataCollectionView.frame.origin.x {
            UIView.animate(withDuration: 0.2) {
                self.dataCollectionView.bounds.origin.x = self.dataCollectionView.contentSize.width-(self.bounds.width-self.dataCollectionView.frame.origin.x)
                self.fixRowCollectionView.bounds.origin.x = self.fixRowCollectionView.contentSize.width-(self.bounds.width-self.dataCollectionView.frame.origin.x)
            }
        }
    }
}

extension ExTableView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ExTableView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == fixRowCollectionView || collectionView == fixDataCollectionView {
            return fixRow
        } else {
            return 20 - fixRow
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fixColCollectionView || collectionView == fixDataCollectionView {
            return fixCol
        } else {
            return 20 - fixCol
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exCell", for: indexPath)
        let contentView = cell.contentView
        for sub in contentView.subviews {
            sub.removeFromSuperview()
        }
        let label = UILabel()
        if collectionView == dataCollectionView {
            label.text = cellDatas[indexPath.section+fixRow][indexPath.row+fixCol]
        } else if collectionView == fixColCollectionView {
            label.text = cellDatas[indexPath.section+fixRow][indexPath.row]
        } else if collectionView == fixRowCollectionView {
            label.text = cellDatas[indexPath.section][indexPath.row+fixCol]
        } else {
            label.text = cellDatas[indexPath.section][indexPath.row]
        }
        cell.contentView.addSubview(label)
        label.sizeToFit()
        label.center = cell.contentView.center
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    
}

