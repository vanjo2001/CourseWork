//
//  MyCollectionProducts.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/20/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"
typealias ProductType = (name: String, price: String, count: String)



class MyCollectionProducts: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var arrOfCategory = [Category]()
    var arrOfFirm = [Firm]()
    
    var currentCell = 0

    let vcPurchased = MyPurchasedInfo()
    
    var arrOfNames = [String]()
    
    static weak var imageView: UIImageView!
    
    var fullPrevious: String = ""
    
    var arrOfProducts = [Product]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        deleteData()
        retrieveData()
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct)), editButtonItem]
        
    }
    
    func retrieveData() {
        
        print(fullPrevious)

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let products = try PersistenceService.context.fetch(fetchRequest)
            arrOfProducts = products
            collectionView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        
        arrOfProducts = arrOfProducts.filter { (product) -> Bool in
            return product.firm == self.fullPrevious
        }
        
    }
    
    func deleteData() {
        
        let managedContext = PersistenceService.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
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
    
    
    
    @objc func addProduct() {
        
        let alert = UIAlertController(title: "add product", message: "To add product you should filling all fields ", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "price"
        }
        
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "count"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "description"
        }
        
        let actionCancelAlert = UIAlertAction(title: "cancel", style: .cancel)
        
        let actionAlert = UIAlertAction(title: "add", style: .default) { [weak alert] _ in
            guard var name = alert?.textFields?[0].text,
                    let price = alert?.textFields?[1].text,
                    let count = alert?.textFields?[2].text,
                    let description = alert?.textFields?[3].text else { return }
            
            name = name.isEmpty ? "unknown" : name
            guard !self.arrOfNames.contains(name) else { return }
            
            self.arrOfNames.append(name)
            
            
            let product = Product(context: PersistenceService.context)
            product.name = name
            product.price = Double(price) ?? 20
            product.amount = Int64(count) ?? 1
            product.image = UIImage(named: "none_image")?.pngData()
            product.firm = self.fullPrevious
            product.descriptionc = description
            
            PersistenceService.saveContext()
            
            
            self.arrOfProducts.append(product)
            
            self.collectionView.reloadData()
            
            LoadDataFunctions.postJSONData(mainPath: DBLink.productLink, command: DBLink.Commands.add, parametr: self.fullPrevious + name + "/" + count + "/" + price)
            print(DBLink.productLink + DBLink.Commands.add + self.fullPrevious + name + "/" + count + "/" + price)
        }
        alert.addAction(actionCancelAlert)
        alert.addAction(actionAlert)
        present(alert, animated: true)
        
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        print("set")
        
        navigationItem.rightBarButtonItem?.isEnabled = !editing
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? MyCellProduct {
                    cell.isEditing = editing
                }
            }
        }

    }
    
    var contextMenuItems: [MenuItem] = {
        return [MenuItem(title: "sell", imagePaht: "change", index: 0),
                MenuItem(title: "delete", imagePaht: "delete", index: 1),
                MenuItem(title: "some", imagePaht: "info", index: 2)]
    }()
    
    
    // MARK: Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choiceSegue" {
            let vc = segue.destination as! ChoiceViewController
            vc.arrOfCategory = arrOfCategory
            vc.arrOfFirm = arrOfFirm
        }
        if segue.identifier == "paingSegueOne" {
            let vc = segue.destination as! PreviewViewController
            vc.purchasedProducts = [arrOfProducts[currentCell]]
        }
    }
    
    
    // MARK: Context menu
    
    func makeContextMenu() -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            return nil

        }) { (_) -> UIMenu? in
            let actionSale = UIAction(title: "sale", image: UIImage(systemName: "cart")) { (action) in
                
                
//                self.present(MyCollectionProducts.getVCfromSB(name: "PreviewViewController"), animated: true)
                self.performSegue(withIdentifier: "paingSegueOne", sender: nil)
                
            }
            let actionSales = UIAction(title: "sale more", image: UIImage(systemName: "cart.fill")) { (action) in
                
                self.performSegue(withIdentifier: "choiceSegue", sender: [self.arrOfCategory, self.arrOfFirm])
                
            }
            
            let actionPickImage = UIAction(title: "pick image", image: UIImage(systemName: "photo")) { (action) in
                self.choosePicture()
            }
            
            let actionDiscount = UIAction(title: "change discount", image: UIImage(systemName: "tag")) { (action) in
                
                let alert = UIAlertController(title: "discount", message: "add discount on product", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.keyboardType = .numberPad
                    textField.placeholder = "discount"
                }
                
                let alertActionOk = UIAlertAction(title: "ok", style: .default) { [weak alert] (action) in
                    guard alert != nil else { return }
                    
                    guard let cell = self.collectionView?.cellForItem(at: IndexPath(row: self.currentCell, section: 0)) as? MyCellProduct else { return }
                    guard var discountNumber = alert?.textFields?[0].text else { return }
                    
                    discountNumber = Int(discountNumber) ?? 0 > 80 ? "80" : discountNumber
                    
                    cell.discount.discountLabel.text = discountNumber + "%"
                    let disc = Int16(discountNumber) ?? 0
                    cell.isDiscount = disc
                    
                    self.arrOfProducts[self.currentCell].discount = disc
                    PersistenceService.saveContext()
                    
                }
                
                let alertActionCancel = UIAlertAction(title: "cancel", style: .cancel)
                alert.addAction(alertActionOk)
                alert.addAction(alertActionCancel)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            return UIMenu(title: "Menu", image: nil, identifier: nil, children: [actionSale, actionSales, actionPickImage, actionDiscount])
        }
        return configuration
    }
    

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfProducts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifierConstant.productCell, for: indexPath) as! MyCellProduct
        cell.myLabel.text = arrOfProducts[indexPath.row].name
        cell.backgroundColor = .white
        cell.myLabel.textColor = .black
        cell.myLabelPrice.text = String(arrOfProducts[indexPath.row].price).replacingOccurrences(of: ".0", with: "") + "руб"
        cell.myLabelCount.text = String(arrOfProducts[indexPath.row].amount) + "шт"
        cell.myLabelDescription.text = arrOfProducts[indexPath.row].descriptionc
        cell.myImage.image = UIImage(data: arrOfProducts[indexPath.row].image ?? Data()) ?? UIImage(named: "none_image")
        
        cell.myLabelPrice.adjustsFontSizeToFitWidth = true
        cell.myLabelPrice.minimumScaleFactor = 0.5
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 12
        cell.layer.shadowOpacity = 0.3
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = false
        
        cell.myImage.layer.cornerRadius = 20
        cell.delegate = self
        
//        cell.discount.discountLabel.text
        
        cell.isEditing = false
        cell.isDiscount = arrOfProducts[indexPath.row].discount
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/3, height: view.bounds.height/10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 5, bottom: 20, right: 5)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
    
    
}

extension MyCollectionProducts: MyCellProductDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        currentCell = indexPath.row
        return makeContextMenu()
    }
    
    func choosePicture() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) {

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self.arrOfProducts[self.currentCell].image = image.jpegData(compressionQuality: 0.0)
            PersistenceService.saveContext()
            
            self.collectionView.reloadItems(at: [IndexPath(row: self.currentCell, section: 0)])
            
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func delete(cell: MyCellProduct) {
        guard let indexP = collectionView.indexPath(for: cell) else { return }
        PersistenceService.context.delete(arrOfProducts.remove(at: indexP.row))
        PersistenceService.saveContext()
        collectionView.deleteItems(at: [indexP])
        
    }
    
    
}

extension UIViewController {
    static func getVCfromSB<T: UIViewController>(name: String, storyboardName sb: String? = nil) -> T {
        
        let storyboard = UIStoryboard(name: sb ?? "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: name)
        return controller as! T
    }
}
