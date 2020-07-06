//
//  PDFPreviewViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 6/13/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    var documentData: Data?
    var userDef = UserDefaults.standard
    
    @IBOutlet weak var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
            
        }
        
        
    }
    
    @IBAction func share(_ sender: Any) {
        if let data = documentData {
            
            let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
            present(vc, animated: true, completion: nil)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PDFPreviewViewController {
    
    
    
}
