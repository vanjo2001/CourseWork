//
//  ViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/18/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBInspectable @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

}

@IBDesignable
class DisagneButton: UIButton {
    
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor() {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
