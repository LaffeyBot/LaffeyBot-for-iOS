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
    case getRecords(updatedSince: String?)
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
        }
    }
    var method: Moya.Method {
        switch self {
        case .register, .login, .requestOTP:
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
        case let .getRecords(updatedSince):
            if updatedSince == nil {
                return .requestPlain
            } else {
                return .requestParameters(parameters: ["updated_since": updatedSince!.urlEscaped], encoding: URLEncoding.queryString)
            }
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
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
