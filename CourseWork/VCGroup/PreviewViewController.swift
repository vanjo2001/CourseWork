//
//  PreviewViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 6/11/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


class PreviewViewController: UIViewController {
    
    var purchasedProducts = [Product]()
    var allPrice: Double = 0
    
    @IBOutlet weak var sumOfProducts: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var button: DisagneButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in purchasedProducts {
            allPrice += i.price
        }
        
        button.backgroundColor = Double(field.text ?? "0") ?? 0 < allPrice ? .gray : .orange
        
        sumOfProducts.text = String(allPrice)
        sumOfProducts.text = String(allPrice) + "р"
        print(purchasedProducts)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "purchaseSegue" {
            let navigaiotnVC = segue.destination as! UINavigationController
            let vc = navigaiotnVC.topViewController as! MyPurchasedInfo
            
            vc.products = purchasedProducts
            vc.allPrice = allPrice
            
            let client = Double(field.text ?? "0") ?? 0
            
            vc.cash = client
            vc.change = client - allPrice
        }
    }
    
}

extension PreviewViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return textField.text!.count + string.count < 6
    }
    

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let client = Double(textField.text ?? "0") ?? 0
        let change = client - allPrice
        labelPrice.text = String(change)
        
        
        button.isEnabled = client < allPrice ? false : true
        button.backgroundColor = client < allPrice ? .gray : .orange
    }
    
    
    
}
