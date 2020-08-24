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
    case modifyRecord(record: RecordForm)
    case addRecord(recordForm: RecordForm)
    case linkToken(token: String)
    case unlinkToken(token: String)
    case getMembers
    case kickMember(user: User)
    case deleteRecord(id: Int)
    case getCurrentBossStatus
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
        case .unlinkToken:
            return "/v1/push/unlink_token"
        case .getMembers:
            return "/v1/group/get_members"
        case .kickMember:
            return "/v1/group/kick_member"
        case .deleteRecord:
            return "/v1/record/delete_record"
        case .getCurrentBossStatus:
            return "/v1/record/get_current_team_record"
        case .modifyRecord:
            return "/v1/record/modify_record"
        }
    }
    var method: Moya.Method {
        switch self {
        case .register, .login, .requestOTP, .addRecord, .linkToken, .unlinkToken, .modifyRecord:
            return .post
        case .getRecords, .getMembers, .getCurrentBossStatus:
            return .get
        case .kickMember, .deleteRecord:
            return .delete
        }
    }
    var task: Task {
        switch self {
        case let .login(loginForm):
            var form = ["password": loginForm.password]
            if !loginForm.username.isValidEmail() {
                form["username"] = loginForm.username
            } else{
                form["email"] = loginForm.username
            }
            return .requestParameters(parameters: form, encoding: JSONEncoding.default)
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
                "boss_order": recordForm.boss_order + 1,
                "user_id": recordForm.user.id,
                "origin": "iOS App"
            ], encoding: JSONEncoding.default)
        case let .linkToken(token):
            return .requestParameters(parameters: [
                "token": token,
                "platform": "ios"
            ], encoding: JSONEncoding.default)
        case let .unlinkToken(token):
            return .requestParameters(parameters: [
                "token": token,
                "platform": "ios"
            ], encoding: JSONEncoding.default)
        case .getMembers:
            return .requestPlain
        case let .kickMember(user):
            return .requestParameters(parameters: ["id": user.id], encoding: JSONEncoding.default)
        case let .deleteRecord(id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .getCurrentBossStatus:
            return .requestPlain
        case let .modifyRecord(record):
            return .requestParameters(parameters: [
                "id": record.id ?? 0,
                "damage": record.damage,
                "type_": record.type,
                "boss_gen": record.boss_gen,
                "boss_order": record.boss_order
            ], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        var header = ["Content-type": "application/json"]
        switch self {
        case .getRecords, .addRecord, .linkToken, .getMembers, .unlinkToken, .deleteRecord, .getCurrentBossStatus, .modifyRecord:
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
