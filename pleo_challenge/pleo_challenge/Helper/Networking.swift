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
        let url = makeURL(query: "/expenses?limit=\(limit)&offset=\(offset)")
        let request = Networking.bodyRequest(url: url, method: "GET")
        let result: Single<ExpensesResponse> = Networking.run(request: request)
        return result.map { $0.expenses }
    }
    
    func getExpense(id: String) -> Single<Expense> {
        let url = makeURL(query: "/expenses/\(id)")
        let request = Networking.bodyRequest(url: url, method: "GET")
        return Networking.run(request: request)
    }
    
    func postExpenseComment(id: String, comment: String) -> Single<Expense> {
        let url = makeURL(query: "/expenses/\(id)")
        let request = Networking.bodyRequest(url: url, method: "POST", body: ["comment": comment])
        return Networking.run(request: request)
    }
    
    func postExpenseReceiptImage(id: String, image: UIImage) -> Single<Expense> {
        let url = makeURL(query: "/expenses/\(id)/receipts")
        let request = Networking.formRequest(url: url, image: image)
        return Networking.run(request: request)
    }
    
    // MARK: - Generic Helper
    
    private static func run<T: Codable>(request: URLRequest) -> Single<T> {
        return Single<T>.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                switch Networking.parseResult(data: data, response: response, error: error) {
                case .failure(let error):
                    observer(.error(error))
                    
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601)
                        let result = try decoder.decode(T.self, from: data)
                        observer(.success(result))
                    } catch let error {
                        observer(.error(NetworkingError.decodeError(error: error)))
                    }
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: - Request
    
    private func makeURL(query: String) -> URL {
        guard let url = URL(string: Networking.baseUrlString + query) else { fatalError("Failed to make URL from query") }
        return url
    }
    
    private static func bodyRequest(url: URL, method: String, body: [String: Any]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body, let jsonBody = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = jsonBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private static func formRequest(url: URL, image: UIImage) -> URLRequest {
        guard let data = image.jpegData(compressionQuality: 0.1) else { fatalError("Expected to be able to convert image to data") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0

        let uuid = UUID().uuidString
        let CRLF = "\r\n"
        let type = "image/jpeg"
        let boundary = "----Boundary.\(uuid)"
        var body = Data()

        // file data //
        body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"receipt\"; filename=\"file.jpg\"\r\n".data(using: .utf8)!)
        body.append(("Content-Type: \(type)" + CRLF + CRLF).data(using: .utf8)!)
        body.append(data)
        body.append(CRLF.data(using: .utf8)!)

        // footer //
        body.append(("--\(boundary)--" + CRLF).data(using: .utf8)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = body
        return request
    }
    
    // MARK: - Error
    
    private static func parseResult(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, NetworkingError> {
        guard let data = data,
            let response = response,
            let httpResponse = response as? HTTPURLResponse
            else { return .failure(.noData) }
        
        if let error = error {
            return .failure(.underlyingError(error: error))
        }
        if httpResponse.statusCode == 200 {
            return .success(data)
        } else {
            return .failure(.httpError(code: httpResponse.statusCode))
        }
    }
    
    enum NetworkingError: Error {
        case underlyingError(error: Error)
        case decodeError(error: Error)
        case httpError(code: Int)
        case noData
    }
    
}

private extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
