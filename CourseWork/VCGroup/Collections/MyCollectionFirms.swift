//
//  MyCollectionFirms.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/18/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit

class MyCollectionFirms: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var userDef = UserDefaults.standard
    
    
    var arrOfCategory: [Category] = []
    var arrOfFirm: [Firm] = []
    
    var allFirms = [Firm]()
    
    var previous: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("s")
        
        
        
        LoadDataFunctions.getJSONData(mainPath: DBLink.firmLink, command: DBLink.Commands.getAll) { (data) in
            let json = try JSONDecoder().decode([Firm].self , from: data)
            
            self.arrOfFirm = Array(Set(json)).sorted()
            
            self.allFirms = self.arrOfFirm
            
            self.arrOfFirm = self.arrOfFirm.filter({ (one) -> Bool in
                let custom = one.Name.replacingOccurrences(of: self.previous, with: self.previous + " ")
                let arr = custom.components(separatedBy: " ")
                
                return self.previous == arr[0]
            })
            
            
            self.arrOfFirm = self.arrOfFirm.map { (one) -> Firm in
                return Firm(Name: one.Name.replacingOccurrences(of: self.previous, with: ""))
            }
            
            print(self.arrOfFirm)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFirm)), editButtonItem]
        collectionView.backgroundColor = .white
    }
    
    
    
    @objc func addFirm() {
        let alert = UIAlertController(title: "add firm", message: "To add firm you should filling all fields ", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        
        let actionCancelAlert = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actionAlert = UIAlertAction(title: "add", style: .default ) { [weak alert] _ in
            guard var name = alert?.textFields?[0].text else { return }
            name = name.isEmpty ? "unknown" : name
            
            guard !self.arrOfFirm.contains(Firm(Name: name)) else { return }
            
            
            self.arrOfFirm.append(Firm(Name: name))
            print(self.arrOfFirm)
            self.collectionView.reloadData()
            
            LoadDataFunctions.postJSONData(mainPath: DBLink.firmLink, command: DBLink.Commands.add, parametr: self.previous + " " + name)
            print(DBLink.firmLink + DBLink.Commands.add + self.previous + name)
        }
        
        alert.addAction(actionCancelAlert)
        alert.addAction(actionAlert)
        
        present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrOfFirm.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifierConstant.firmCell, for: indexPath) as! MyCellFirm
        cell.backgroundColor = .systemGreen
        cell.myLabel.text = arrOfFirm[indexPath.row].Name
        cell.myLabel.textColor = .white
        cell.layer.cornerRadius = cell.frame.width/7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: VCIDConstants.productVC) as! MyCollectionProducts
        
        vc.arrOfCategory = arrOfCategory
        vc.arrOfFirm = allFirms
        
        vc.fullPrevious = previous + arrOfFirm[indexPath.row].Name
        
        navigationController?.pushViewController(vc, animated: true)
        print(vc.arrOfProducts)
        print(vc.fullPrevious)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/3, height: view.bounds.height/10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 15, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    

}
