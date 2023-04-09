//
//  MosquitoService.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/06.
//

import Foundation
import Alamofire

struct MosquitoService {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "ko_kr")
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // http://openapi.seoul.go.kr:8088/sample/xml/MosquitoStatus/1/5/
    func getMosquitoInfo(date: Date, closure: @escaping (Error?, Mosquito?) -> ()) {
        let key = "6e62564f4632337039366961457369"
        let date = dateFormatter.string(from: date)
//        print(date)
        let url = "http://openapi.seoul.go.kr:8088/\(key)/json/MosquitoStatus/1/5/\(date)"
        
        AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "").responseDecodable(of: Mosquito.self) { response in
//            print(response)
            switch response.result {
            case .success(let data):
                closure(nil, data)
            case .failure(let error):
                closure(error, nil)
            }
        }
    }
    
    /*
     KEY    String(필수)    인증키    OpenAPI 에서 발급된 인증키
     TYPE    String(필수)    요청파일타입    xml : xml, xml파일 : xmlf, 엑셀파일 : xls, json파일 : json
     SERVICE    String(필수)    서비스명    MosquitoStatus
     START_INDEX    INTEGER(필수)    요청시작위치    정수 입력 (페이징 시작번호 입니다 : 데이터 행 시작번호)
     END_INDEX    INTEGER(필수)    요청종료위치    정수 입력 (페이징 끝번호 입니다 : 데이터 행 끝번호)
     MOSQUITO_DATE    STRING(필수)    모기지수 발생일    YYYY-MM-DD
     */
    //6e62564f4632337039366961457369
}
