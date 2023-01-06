//
//  ErrorResult.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 06/01/2023.
//

import Foundation

enum ErrorResult: Error {
    case network(errMessage: String)
    case parser(errMessage: String)
    case custom(errMessage: String)
}

extension ErrorResult {
    var errorMessage: String {
        switch self {
        case .network(let errMessage):
            return errMessage
        case .parser(let errMessage):
            return errMessage
        case .custom(let errMessage):
            return errMessage

        }
    }
}
