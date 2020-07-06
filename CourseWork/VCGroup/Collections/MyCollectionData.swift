//
//  MyCollectionData.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/18/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit




@IBDesignable
class MyCollectionData: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var arrOfCategories = [Category]()
    
    
    
    let dictOfData = ["Pushchairs":          ["CAM": [("Pushchair1", 100), ("Pushchair2", 100), ("Pushchair3", 100)],
                                             "Peg Perego": [("Pushchair1", 100), ("Pushchair2", 330), ("Pushchair3", 100)],
                                             "Inglesinа": [("Pushchair1", 100), ("Pushchair2", 100), ("Pushchair3", 100)]],
                      
                      "Pacifiers":           ["MAM": [("Pacifier1", 100), ("Pacifier2", 1000), ("Pacifier3", 100)],
                                             "AVENT": [("Pacifier1", 60), ("Pacifier2", 100), ("Pacifier3", 100)],
                                             "NUK": [("Pacifier1", 100), ("Pacifier2", 100), ("Pacifier3", 100)]],
                      
                      "Diapers":            ["Essity Aktiebolag": [("Diaper1", 100), ("Diaper2", 10), ("Diaper3", 100)],
                                             "Kao Corporation": [("Diaper1", 50), ("Diaper2", 100), ("Diaper3", 120)],
                                             "Procter & Gamble": [("Diaper1", 100), ("Diaper2", 100), ("Diaper3", 100)]],
                      
                      "Educational toys":   ["Kano": [("Educational toy1", 135), ("Educational toy2", 70), ("Educational toy3", 100)],
                                             "Play Shifu": [("Educational toy1", 100), ("Educational toy2", 100), ("Educational toy3", 100)],
                                             "Lora DiCarlo": [("Educational toy1", 100), ("Educational toy2", 100), ("Educational toy3", 100)]],
    
                      "Bicycles":            ["Woom": [("Bicycle1", 100), ("Bicycle2", 100), ("Bicycle3", 15)],
                                             "Prevelo": [("Bicycle1", 100), ("Bicycle2", 100), ("Bicycle3", 100)],
                                             "Cleary": [("Bicycle1", 100), ("Bicycle2", 100), ("Bicycle3", 100)]]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        LoadDataFunctions.getJSONData(mainPath: DBLink.categoryLink, command: DBLink.Commands.getAll) { (data) in
            let json = try JSONDecoder().decode([Category].self , from: data)
            print(json)
            
            self.arrOfCategories = Array(Set(json)).sorted()
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
            
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
        
        DiagramView.dataDiagram = []
        
        for one in dictOfData {
            var accum = 0
            for firm in one.value {
                for res in firm.value {
                    accum += res.1
                }
            }
            
            DiagramView.dataDiagram.append(Double(accum))
            DiagramView.dataDiagram.sort()
            
            print(accum)
            accum = 0
        }
        
    }
    
    @objc func addCategory() {
        let alert = UIAlertController(title: "addProduct", message: "To add product you should filling all fields ", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        
        let actionCancelAlert = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actionAlert = UIAlertAction(title: "add", style: .default ) { [weak alert] _ in
            guard var name = alert?.textFields?[0].text else { return }
            name = name.isEmpty ? "unknown" : name
            
            guard !self.arrOfCategories.contains(Category(Name: name)) else { return }
            
            self.arrOfCategories.append(Category(Name: name))
            self.collectionView.reloadData()
            
            LoadDataFunctions.postJSONData(mainPath: DBLink.categoryLink, command: DBLink.Commands.add, parametr: name)
        }
        
        alert.addAction(actionCancelAlert)
        alert.addAction(actionAlert)
        
        present(alert, animated: true)
    }
    
    func prepareData() {
        
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrOfCategories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifierConstant.categoryCell, for: indexPath) as! MyCell
        cell.backgroundColor = .systemTeal
        cell.myLabel.text = arrOfCategories[indexPath.row].Name
        cell.myLabel.textColor = .white
        cell.layer.cornerRadius = cell.frame.width/7
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/3, height: view.bounds.height/10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 40, bottom: 20, right: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: VCIDConstants.firmVC) as! MyCollectionFirms
        vc.previous = arrOfCategories[indexPath.row].Name
        vc.arrOfCategory = arrOfCategories
        
        navigationController?.pushViewController(vc, animated: true)
        print(vc.arrOfFirm)
    }
    
}


