//
//  MyPurchasedInfo.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 6/4/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit
import CoreData


class MyPurchasedInfo: UICollectionViewController {
    
    var checksForPDF: [Check] = []

    var checks = [Check]()
    
    var products = [Product]()
    var allPrice: Double = 0
    var cash: Double = 0
    var change: Double = 0
    
    var date: Date = Date()
    
    var dateFormatter: String = {
        let format = DateFormatter()
        format.dateStyle = .short
        return format.string(from: Date())
    }()
    
    var timeFormatter: String = {
        let format = DateFormatter()
        format.timeStyle = .short
        return format.string(from: Date())
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        deleteData() DO NOT TOUCH...BEACH...
        
        if !products.isEmpty {
            let check = Check(context: PersistenceService.context)
            
            check.cash = cash
            check.date = dateFormatter
            check.time = timeFormatter
            check.allPrice = allPrice
            check.change = change
            
            for one in products {
                
                check.addToProducts(one)
                
            }
            checks.append(check)
            
            
            PersistenceService.saveContext()
        }
        
        
        retrieveData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pdfpreviewSegue" {
            let vc = segue.destination as! PDFPreviewViewController
            vc.documentData = PDFCreator.createFlyer(checksForPDF, sizeOfHead: 25, sizeOfDefault: 16)
            checksForPDF = []
        }
    }
    
    
    
    func makeContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) -> UIMenu? in
            
            
            let exportOne = UIAction(title: "one", image: UIImage(systemName: "square"), identifier: .none, discoverabilityTitle: "export one to PDF", attributes: [], state: .off) { (action) in
                
                let one = self.checks[indexPath.row]
                
                self.checksForPDF.append(one)
                
                
                self.performSegue(withIdentifier: "pdfpreviewSegue", sender: nil)
            }
            
            let exportAll = UIAction(title: "all", image: UIImage(systemName: "square.stack"), identifier: .none, discoverabilityTitle: "export all to PDF", attributes: [], state: .off) { (action) in
                
                self.checksForPDF = self.checks
                
                self.performSegue(withIdentifier: "pdfpreviewSegue", sender: nil)
            }
            
            let subMenu = UIMenu(title: "to PDF", image: UIImage(systemName: "doc.text"), identifier: .none, options: [], children: [exportOne, exportAll]) //options = [.displayInLine]
            
            
            let remove = UIAction(title: "remove", image: UIImage(systemName: "delete.left"), identifier: .none, discoverabilityTitle: nil, attributes: .destructive, state: .off) { (action) in
                self.collectionView.deleteItems(at: [indexPath])
                PersistenceService.context.delete(self.checks.remove(at: indexPath.row))
                PersistenceService.saveContext()
                
                self.collectionView.reloadData()
            }
            
            return UIMenu(title: "export menu", image: nil, identifier: .none, options: .displayInline, children: [subMenu, remove])
        }
        return configuration
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "purchaseCellIdentifier", for: indexPath) as! CheckCell
//        cell.layer.contents = UIImage(named: "none_image")?.cgImage
//        cell.layer.contentsGravity = CALayerContentsGravity.center
//
//        cell.layer.isGeometryFlipped = true
        let check = checks[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.backgroundColor = #colorLiteral(red: 0.9654782678, green: 0.9654782678, blue: 0.9654782678, alpha: 1)
        cell.productsView.backgroundColor = #colorLiteral(red: 0.9654782678, green: 0.9654782678, blue: 0.9654782678, alpha: 1)
        cell.productsView.layer.cornerRadius = 10
        
        
        
        let products = check.products as? Set<Product> ?? []
        var arrOfProducts = Array(products)
        
        arrOfProducts = arrOfProducts.sorted(by: { (one, second) -> Bool in
            return one.name! > second.name!
        })
        
        var text = ""
        for i in arrOfProducts {
            text.append((i.name ?? "unk") + "\t\t\t\t\t" + String(i.price) + "\n")
        }
        cell.productsView.text = text
        
        cell.priceOfProducts.text = checkZeroDouble(check.allPrice) + "byn"
        cell.date.text = "Date: " + check.date!
        cell.time.text = "Time: " + check.time!
        cell.cash.text = checkZeroDouble(check.cash) + "byn"
        cell.change.text = checkZeroDouble(check.change) + "byn"
        
        
        return cell
        
    }
    
    func retrieveData() {

        let fetchRequest: NSFetchRequest<Check> = Check.fetchRequest()
        
        do {
            let data = try PersistenceService.context.fetch(fetchRequest)
            
            checks = data
            collectionView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteData() {
        
        let managedContext = PersistenceService.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Check")

        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test as! [NSManagedObject]
            for one in objectToDelete {
                managedContext.delete(one)
            }
            
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }

    
    func checkZeroDouble(_ doubleValue: Double) -> String {
        let str = String(doubleValue)
        let arr = str.components(separatedBy: ".")
        
        let fraction = Int(arr.last ?? "0")
        
        if (fraction == 0) {
            return str.replacingOccurrences(of: ".0", with: "")
        }
        
        return str
    }

}


extension MyPurchasedInfo: UIContextMenuInteractionDelegate {
    
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return makeContextMenu(indexPath: indexPath)
    }
    
    
}
