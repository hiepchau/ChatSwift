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

extension Notification.Name {
    /// Notificaiton  when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
    static let didLogOutnotification = Notification.Name("didLogOutNotification")
    static let errorNotification = Notification.Name("errorNotification")
}
