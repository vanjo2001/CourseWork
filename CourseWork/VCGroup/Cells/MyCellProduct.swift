//
//  MyCellProduct.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/20/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


protocol MyCellProductDelegate: class {
    func delete(cell: MyCellProduct)
    func choosePicture()
}

class DiscountView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 7
    }
    
    @IBOutlet weak var discountLabel: UILabel!
}

class MyCellProduct: UICollectionViewCell {
    
    
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//
//    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
        
    }
    
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myLabelDescription: UILabel!
    @IBOutlet weak var myLabelCount: UILabel!
    @IBOutlet weak var myLabelPrice: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var discount: DiscountView!
    
    
    weak var delegate: MyCellProductDelegate?
    
    var isEditing: Bool = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    var isDiscount: Int16 = 0 {
        didSet {
            
            discount.discountLabel.text = String(isDiscount) + "%"
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else { return }
                
                self.discount.alpha = self.isDiscount != 0 ? 1.0 : 0.0
                self.discount.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            }) { (handle) in
                UIView.animate(withDuration: 0.2) {
                    self.discount.transform = .identity
                }
                
            }
            
        }
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        delegate?.delete(cell: self)
    }
    
    
    
}

