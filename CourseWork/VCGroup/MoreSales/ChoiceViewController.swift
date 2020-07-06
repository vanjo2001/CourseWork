//
//  ChoiceViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 6/8/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit
import CoreData

class ChoiceViewController: UIViewController {
    
    
    struct CheckMarkMultiTable {
        typealias CheckMarkType = (categoryComponentRow: Int, firmComponentRow: Int, tableRow: Int, mark: Bool)
        
        var arr = [CheckMarkType]()
        
        subscript(categoryRow: Int, firmRow: Int) -> [Int] {
            var result = [Int]()
            for one in arr {
                if (one.categoryComponentRow == categoryRow && one.firmComponentRow == firmRow) {
                    result.append(one.tableRow)
                }
            }
            return result
        }
        
    }
    
    var categoryComponent: Int = 0
    var firmComponent: Int = 0
    var pickerRow: Int = 0
    var checkMark = CheckMarkMultiTable()

    
    var arrOfCategory = [Category]()
    var arrOfFirm = [Firm]()
    
    var arrOfSpecialFirm = [Firm]()
    var currentProducts = [Product]()
    
    var choosenProducts = [Product]()
    
    @IBOutlet weak var categoryFirmPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard !arrOfCategory.isEmpty else { return }
        arrOfSpecialFirm = arrOfFirm.filter({ (one) -> Bool in
            let custom = one.Name.replacingOccurrences(of: arrOfCategory[0].Name, with: arrOfCategory[0].Name + " ")
            let arr = custom.components(separatedBy: " ")
            
            return arrOfCategory[0].Name == arr[0]
        })
        
        retrieveData(str: arrOfSpecialFirm[0].Name)
        
        
    }
    
    func retrieveData(str: String) {

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let products = try PersistenceService.context.fetch(fetchRequest)
            
            currentProducts = products.filter({ (product) -> Bool in
                return product.firm == str
            })
            
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paingSegue" {
            let vc = segue.destination as! PreviewViewController
            vc.purchasedProducts = choosenProducts
        }
    }
    

}

extension ChoiceViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return arrOfCategory.count
        }
        
        return arrOfSpecialFirm.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return arrOfCategory[row].Name
        }
        
        return arrOfSpecialFirm[row].Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            categoryComponent = row
            firmComponent = 0
            
            arrOfSpecialFirm = arrOfFirm.filter({ (one) -> Bool in
                let custom = one.Name.replacingOccurrences(of: arrOfCategory[row].Name, with: arrOfCategory[row].Name + " ")
                let arr = custom.components(separatedBy: " ")
                
                return arrOfCategory[row].Name == arr[0]
            })
            
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            
            guard !arrOfSpecialFirm.isEmpty else { return }
            
            retrieveData(str: arrOfSpecialFirm[0].Name)
            
            return
        }
        firmComponent = row
        
        retrieveData(str: arrOfSpecialFirm[row].Name)
        
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierConstant.productTableCell, for: indexPath) as! ProductCell
        cell.name.text = currentProducts[indexPath.row].name
        cell.price.text = String(currentProducts[indexPath.row].price)
        cell.accessoryType = .none
        
        let arr = checkMark[categoryComponent, firmComponent]
        if arr.contains(indexPath.row) {
            if !choosenProducts.contains(currentProducts[indexPath.row]) {
                choosenProducts.append(currentProducts[indexPath.row])
            }
            cell.accessoryType = .checkmark
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ProductCell {
            
            if !choosenProducts.contains(currentProducts[indexPath.row]) {
                choosenProducts.append(currentProducts[indexPath.row])
            }
            checkMark.arr.append(CheckMarkMultiTable.CheckMarkType(categoryComponent, firmComponent, indexPath.row, true))
            cell.accessoryType = .checkmark
        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .none
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
