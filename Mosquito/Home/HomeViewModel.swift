//
//  HomeViewModel.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/03.
//

import Foundation

final class HomeViewModel {
    let service: MosquitoService!
    
    init(service: MosquitoService) {
        self.service = service
    }
    
    var didMosquitoInfoEnd: (() -> ())?
    
    func getMosquitoInfo() {
        print(#function)
        service.getMosquitoInfo { error in
            print(error)
            
        }
    }
}
