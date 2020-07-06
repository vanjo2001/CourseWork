//
//  LoadDataFunctions.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 5/28/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


class LoadDataFunctions {
    
    static func getJSONData(mainPath: String, command: String, closureForData: @escaping (Data) throws -> ()) {
        let session = URLSession.shared
        
        guard let url = URL(string: mainPath + command) else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                try closureForData(data!)
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
    }
    
    
    static func postJSONData(mainPath: String, command: String, parametr: String) {
        
        let session = URLSession.shared
        
        guard let url = URL(string: mainPath + command + parametr) else { return }
        
        session.dataTask(with: url).resume()
    }
    
    
    
}
