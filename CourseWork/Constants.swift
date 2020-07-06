//
//  Constants.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/19/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import Foundation


struct CellIdentifierConstant {
    static var firmCell = "firmCell"
    static var categoryCell = "categoryCell"
    static var productCell = "productCell"
    static var productTableCell = "ProductCellIdentifier"
}

struct VCIDConstants {
    static var firmVC = "VCFirms"
    static var productVC = "VCProducts"
}

struct DBLink {
    
    struct Commands {
        static var getAll = "getAll"
        static var add = "add/"
        static var delete = "delete/"
    }
    
    static var categoryLink = "https://webapplication920200519141439.azurewebsites.net/api/Category/"
    static var firmLink = "https://webapplication920200519141439.azurewebsites.net/api/Firm/"
    static var productLink = "https://webapplication920200519141439.azurewebsites.net/api/Product/"
}

