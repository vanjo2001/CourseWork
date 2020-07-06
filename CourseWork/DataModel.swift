//
//  DataModel.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 5/21/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import Foundation


struct Category: Codable {
    var CategoryId: Int?
    var Name: String
}

extension Category: Comparable, Hashable {
    
    static func < (lhs: Category, rhs: Category) -> Bool {
        return lhs.Name < rhs.Name
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.Name == rhs.Name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Name)
    }
    
}

struct Firm: Codable {
    
    var FirmId: Int?
    var Name: String
}

extension Firm: Comparable, Hashable {
    
    static func < (lhs: Firm, rhs: Firm) -> Bool {
        return lhs.Name < rhs.Name
    }
    
    static func == (lhs: Firm, rhs: Firm) -> Bool {
        return lhs.Name == rhs.Name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Name)
    }
}


struct MenuItem {
    var title = ""
    var imagePaht = ""
    var index = 0
}
