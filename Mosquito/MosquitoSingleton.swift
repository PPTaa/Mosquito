//
//  MosquitoSingleton.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/13.
//

import Foundation

class MosquitoSingleton {
    static let shared = MosquitoSingleton()
    
    var mosquitoDataList = [MosquitoStatus]()
    
    private init() { }
}
