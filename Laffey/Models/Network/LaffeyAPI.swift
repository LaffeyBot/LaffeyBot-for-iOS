//
//  LaffeyAPI.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<LaffeyAPI>()

enum LaffeyAPI {
    case register(regForm: RegistrationForm)
    case login(loginForm: RegistrationForm)
    case requestOTP(email: String, for: String)
    case getRecords(updatedSince: String = "", type: String = "personal")
    case addRecord(recordForm: RecordForm)
    case linkToken(token: String)
}

extension LaffeyAPI: TargetType {
    var baseURL: URL { return URL(string: "http://s.dd.works:5555")! }
    var path: String {
        switch self {
        case .register:
            return "/v1/auth/sign_up"
        case .login:
            return "/v1/auth/login"
        case .requestOTP:
            return "/v1/email/request_otp"
        case .getRecords:
            return "/v1/record/get_records"
        case .addRecord:
            return "/v1/record/add_record"
        case .linkToken:
            return "/v1/push/link_token"
        }
    }
    var method: Moya.Method {
        switch self {
        case .register, .login, .requestOTP, .addRecord, .linkToken:
            return .post
        case .getRecords:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .login(loginForm):
            return .requestParameters(parameters: ["username": loginForm.username,
                                                   "password": loginForm.password], encoding: JSONEncoding.default)
        case let .register(regForm):
            return .requestParameters(parameters: ["username": regForm.username,
                                                   "password": regForm.password,
                                                   "email": regForm.email,
                                                   "otp": regForm.otp], encoding: JSONEncoding.default)
        case let .requestOTP(email, for_):
            return .requestParameters(parameters: ["for": for_,
                                                   "email": email], encoding: JSONEncoding.default)
        case let .getRecords(updatedSince, type):
                return .requestParameters(parameters: [
                    "updated_since": updatedSince.urlEscaped,
                    "type": type
                ], encoding: URLEncoding.queryString)
        case let .addRecord(recordForm):
            return .requestParameters(parameters: [
                "damage": Int(recordForm.damage) ?? 0,
                "type": recordForm.type,
                "boss_gen": Int(recordForm.boss_gen) ?? 0,
                "boss_order": recordForm.boss_order + 1
            ], encoding: JSONEncoding.default)
        case let .linkToken(token):
            return .requestParameters(parameters: [
                "token": token,
                "platform": "ios"
            ], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        var header = ["Content-type": "application/json"]
        switch self {
        case .getRecords, .addRecord, .linkToken:
            header["auth"] = Preferences().authToken
        default:
            break
        }
        return header
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
