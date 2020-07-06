//
//  PDFCreator.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 6/13/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import Foundation
import PDFKit


enum Direction {
    case right
    case left
}


class PDFCreator {
    
    typealias ShiftType = (top: CGFloat, rect: CGRect)
    
    
    
    //MARK: Add Line
    
    class func addLine(pageRect: CGRect, currentTop top: CGFloat) -> ShiftType {
        var attributedText = NSAttributedString(string: "- ",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        
        
        var text: String = "- "
        
        while attributedText.size().width < pageRect.width {
            text += text
            attributedText = NSAttributedString(string: text,
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        }
        
        let textSize = attributedText.size()
        
        attributedText.draw(in: CGRect(x: 0, y: top, width: textSize.width, height: textSize.height))
        
        return (top + textSize.height, CGRect())
    }
    
 
    //MARK: Add Title
    
    class func addTitle(pageRect: CGRect, currentTop top: CGFloat, title: String) -> ShiftType {
        
        let attributedTitle = NSAttributedString(string: title,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)])
        
        let titleStringSize = attributedTitle.size()
        
        let rectOfText = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                     y: 36 + top,
                                     width: titleStringSize.width,
                                     height: titleStringSize.height)
        
        attributedTitle.draw(in: rectOfText)
        
        return (rectOfText.origin.y + rectOfText.size.height, rectOfText)
    }
    
    
    //MARK: Add to CGPoint
    
    class func addToCGPoint(point: CGPoint, currentTop top: CGFloat, _ text: String) -> ShiftType {
        
        let attributedText = NSAttributedString(string: text,
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        
        let textSize = attributedText.size()
        
        let rectOfText = CGRect(x: point.x, y: top, width: textSize.width, height: textSize.height)
        
        attributedText.draw(in: rectOfText)
        
        return (rectOfText.origin.y + rectOfText.height, rectOfText)
        
    }
    
    
    //MARK: Add to Edge
    
    class func addToEdge(pageRect: CGRect, currentTop top: CGFloat, side to: Direction, padding: CGFloat, _ text: String) -> ShiftType {
        
        let attributedText = NSAttributedString(string: text,
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        
        let textSize = attributedText.size()
        
        let rectOfText: CGRect
        
        
        if to == .left {
            rectOfText = CGRect(x: 0 + padding, y: top, width: textSize.width, height: textSize.height)
            attributedText.draw(in: rectOfText)
            return (rectOfText.origin.y + rectOfText.height, rectOfText)
        }
        
        rectOfText = CGRect(x: pageRect.width - textSize.width - padding, y: top, width: textSize.width, height: textSize.height)
        attributedText.draw(in: rectOfText)
        
        return (rectOfText.origin.y + rectOfText.height, rectOfText)
        
    }
    
    
    //MARK: Create Flyer
    
    class func createFlyer(_ str: [Check], sizeOfHead head: CGFloat, sizeOfDefault def: CGFloat) -> Data {
      
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "Vanjo"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]


        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0 * Double(str.count)
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)


        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in

            context.beginPage()
            
            var nextCheckShift: CGFloat = 0
            
            for one in str {
                
                let titleShift = addTitle(pageRect: pageRect,
                                          currentTop: nextCheckShift,
                                          title: "CHECK")
                
                let receiptShift = addToEdge(pageRect: pageRect,
                                             currentTop: titleShift.top + 15,
                                             side: .left,
                                             padding: 100,
                                             "CASH RECEIPT")
                
                let dateShift = addToEdge(pageRect: pageRect,
                                          currentTop: receiptShift.rect.origin.y - receiptShift.rect.height/2,
                                          side: .right,
                                          padding: 100,
                                          "Date: \(one.date ?? "none")")
                
                let timeShift = addToCGPoint(point: dateShift.rect.origin, currentTop: dateShift.top, "Time: \(one.time ?? "none")")
                
                let topLineShift = addLine(pageRect: pageRect, currentTop: timeShift.top + 25)
                
                let products = one.products as? Set<Product> ?? []
                
                var topForProducts: CGFloat = topLineShift.top
                
                for product in products {
                    
                    let _ = addToEdge(pageRect: pageRect, currentTop: topForProducts, side: .left, padding: 10, "\(product.name ?? "none")")
                    let _ = addToEdge(pageRect: pageRect, currentTop: topForProducts, side: .right, padding: 10, "\(product.price)")
                    
                    topForProducts += 25
                    
                }
                
                let bottomLineShift = addLine(pageRect: pageRect, currentTop: topForProducts)
                
                let allPriceShift = addToEdge(pageRect: pageRect, currentTop: bottomLineShift.top + 10, side: .right, padding: 10, "\(one.allPrice)" + "byn")
                
                let cashShift = addToEdge(pageRect: pageRect, currentTop: allPriceShift.top, side: .left, padding: 10, "CASH")
                
                let _ = addToCGPoint(point: allPriceShift.rect.origin, currentTop: allPriceShift.top, "\(one.cash)" + "byn")
                
                let _ = addToCGPoint(point: cashShift.rect.origin, currentTop: cashShift.top, "CHANGE")
                
                let _ = addToCGPoint(point: allPriceShift.rect.origin, currentTop: cashShift.top, "\(one.change)" + "byn")
                
                nextCheckShift = cashShift.top + 30
                
            }
            
            
            
            
        }

        return data
    }
    
}


