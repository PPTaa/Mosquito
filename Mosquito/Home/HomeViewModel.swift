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
    
    var didUpdateError: ((Error?) -> ())?
    var didMosquitoInfoEnd: (() -> ())?
    
    func getMosquitoInfo() {
        print(#function)
        let now = Date()
        service.getMosquitoInfo(date: now) { error, data in
            if let error = error {
                self.didUpdateError?(error)
            } else {
                MosquitoSingleton.shared.mosquitoDataList.removeAll {
                    $0.row[0].mosquitoDate == data?.mosquitoStatus?.row[0].mosquitoDate
                }
                guard let appendData = data?.mosquitoStatus else {
                    self.didUpdateError?(error)
                    return
                }
                MosquitoSingleton.shared.mosquitoDataList.append(appendData)
                MosquitoSingleton.shared.mosquitoDataList.sort {
                    $0.row[0].mosquitoDate < $1.row[0].mosquitoDate
                }
                print(MosquitoSingleton.shared.mosquitoDataList)
                
                self.didMosquitoInfoEnd?()
            }
            
        }
    }
    
    func getRotation(score: CGFloat) -> CGFloat {
        return score * CGFloat.pi / 100.0 - CGFloat.pi / 2.0
    }
    
    func getTodayStage(score: CGFloat) -> Int {
        let stage: Int
        switch score {
        case 0...24.9 :
            stage = 1
        case 25.0...49.9 :
            stage = 2
        case 50.0...74.9 :
            stage = 3
        case 75.0... :
            stage = 4
        default:
            stage = 1
        }
        return stage
        
    }
    /*
    {
        "MosquitoStatus": {
            "list_total_count":1,
            "RESULT": {
                "CODE":"INFO-000",
                "MESSAGE":"정상 처리되었습니다"
            },
            "row": [
                {
                 "MOSQUITO_DATE":"2023-03-13",
                 "MOSQUITO_VALUE_WATER":"43.9",
                 "MOSQUITO_VALUE_HOUSE":"26.7",
                 "MOSQUITO_VALUE_PARK":"25.6"
                }
            ]
        }
    }
     */
    
}
