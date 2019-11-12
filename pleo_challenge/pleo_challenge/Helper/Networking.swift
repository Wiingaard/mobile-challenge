//
//  Networking.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import Foundation
import RxSwift

class Networking {
    
    private static let baseUrlString = "http://localhost:3000"
    
    // MARK: - Expenses
    
    private struct ExpensesResponse: Codable {
        let expenses: [Expense]
        let total: Int
    }
    
    func getExpenses(limit: Int, offset: Int) -> Single<[Expense]> {
        let query = "/expenses?limit=\(limit)&offset=\(offset)"
        let request: Single<ExpensesResponse> = Networking.request(query: query)
        return request.map { $0.expenses }
    }
    
    func getExpense(id: String) -> Single<Expense> {
        let query = "/expenses/\(id)"
        return Networking.request(query: query)
    }
    
    func postExpenseComment(id: String, comment: String) -> Single<Expense> {
        let query = "/expenses/\(id)"
        let body: [String: Any] = ["comment": comment]
        return Networking.request(query: query, method: "POST", body: body)
    }
    
    // MARK: - Generic Helper
    
    private static func request<T: Codable>(query: String, method: String = "GET", body: [String: Any]? = nil) -> Single<T> {
        return Single<T>.create { observer -> Disposable in
            guard let url = URL(string: "http://localhost:3000" + query) else { fatalError("Expented to be able to make a URL from query-string") }
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            if let body = body, let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
                request.httpBody = jsonBody
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer(.error(NetworkingError.underlyingError(error: error)))
                } else {
                    
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.iso8601)
                            let result = try decoder.decode(T.self, from: data)
                            observer(.success(result))
                        } catch let error {
                            observer(.error(NetworkingError.decodeError(error: error)))
                        }
                    } else {
                        if let response = response, let httpResponse = response as? HTTPURLResponse {
                            observer(.error(NetworkingError.httpError(code: httpResponse.statusCode)))
                        } else {
                            fatalError("Expented either 'data' or 'HTTPURLResponse' from URLSession completion")
                        }
                    }
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: - Error
    
    enum NetworkingError: Error {
        case underlyingError(error: Error)
        case decodeError(error: Error)
        case httpError(code: Int)
    }
    
}

private extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
