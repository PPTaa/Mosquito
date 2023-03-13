//
//  SplashViewModel.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/13.
//
import Foundation

class SplashViewModel {
    let service: MosquitoService!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "ko_kr")
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var getMosquitoCount = 0
    
    var didMosquitoInfoEnd: (() -> ())?
    
    init(service: MosquitoService!) {
        self.service = service
    }
    
    func getMosquitoInfo() {
        let now = Date()
        print(#function)
//        self.didMosquitoInfoEnd?()
        for i in 0 ..< 7 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: now)!
            if let existData = UserDefaults.standard.object(forKey: dateFormatter.string(from: date)) as? Data {
                let data = self.decodingToObject(data: existData)
                print("existData", data)
                MosquitoSingleton.shared.mosquitoDataList.append(data!)
                self.getMosquitoCount += 1
                if self.getMosquitoCount == 7 {
                    MosquitoSingleton.shared.mosquitoDataList.sort {
                        $0.row[0].mosquitoDate < $1.row[0].mosquitoDate
                    }
                    self.didMosquitoInfoEnd?()
                }
            } else {
                service.getMosquitoInfo(date: date) { [weak self] error, data in
                    self?.getMosquitoCount += 1
                    guard let data = data?.mosquitoStatus,
                          let encodingData = self?.encodingToData(mosquitoStatus: data) else {
                        if self?.getMosquitoCount == 7 {
                            MosquitoSingleton.shared.mosquitoDataList.sort {
                                $0.row[0].mosquitoDate < $1.row[0].mosquitoDate
                            }
                            self?.didMosquitoInfoEnd?()
                        }
                        return
                    }
                    
                    MosquitoSingleton.shared.mosquitoDataList.append(data)
                    UserDefaults.standard.set(encodingData, forKey: data.row[0].mosquitoDate)
                    
                    if self?.getMosquitoCount == 7 {
                        MosquitoSingleton.shared.mosquitoDataList.sort {
                            $0.row[0].mosquitoDate < $1.row[0].mosquitoDate
                        }
                        self?.didMosquitoInfoEnd?()
                    }
                }
            }
        }
    }
    private func encodingToData(mosquitoStatus: MosquitoStatus) -> Data? {
        let encoder = JSONEncoder()
        // encoded는 Data형
        guard let encoded = try? encoder.encode(mosquitoStatus) else { return nil}
        return encoded
    }
    
    private func decodingToObject(data: Data) -> MosquitoStatus? {
        let decoder = JSONDecoder()
        guard let savedObject = try? decoder.decode(MosquitoStatus.self, from: data) else { return nil }
        return savedObject
    }
}

