//
//  MosquitoModel.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/13.
//

struct Mosquito: Codable {
    let mosquitoStatus: MosquitoStatus?
    let result: MosquitoResult?
    
    enum CodingKeys : String, CodingKey {
        case mosquitoStatus = "MosquitoStatus"
        case result = "RESULT"
    }
}

struct MosquitoStatus: Codable {
    let listTotalCount: Int
    let result: MosquitoResult
    let row: [MosquitoRow]
    
    enum CodingKeys : String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row = "row"
    }
}

struct MosquitoResult: Codable {
    let code: String
    let message: String
    
    enum CodingKeys : String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct MosquitoRow: Codable {
    let mosquitoDate: String
    let mosquitoValueWater: String
    let mosquitoValueHouse: String
    let mosquitoValuePark: String
    
    enum CodingKeys : String, CodingKey {
        case mosquitoDate = "MOSQUITO_DATE"
        case mosquitoValueWater = "MOSQUITO_VALUE_WATER"
        case mosquitoValueHouse = "MOSQUITO_VALUE_HOUSE"
        case mosquitoValuePark = "MOSQUITO_VALUE_PARK"
    }
}

//{
//    "MosquitoStatus": {
//        "list_total_count":1,
//        "RESULT": {
//            "CODE":"INFO-000",
//            "MESSAGE":"정상 처리되었습니다"
//        },
//        "row": [
//            {
//             "MOSQUITO_DATE":"2023-03-13",
//             "MOSQUITO_VALUE_WATER":"43.9",
//             "MOSQUITO_VALUE_HOUSE":"26.7",
//             "MOSQUITO_VALUE_PARK":"25.6"
//            }
//        ]
//    }
//}
