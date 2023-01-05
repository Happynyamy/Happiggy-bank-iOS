//
//  NetworkManager.swift
//  Happiggy-bank
//
//  Created by sun on 2022/12/29.
//

import Foundation

/// 네트워크 통신 객체
struct NetworkManager: NetworkServiceable {

    // MARK: - Properties

    private let session = URLSession.shared


    // MARK: - Functions

    func resume<T: Decodable>(for endpoint: Requestable) async throws -> T {
        let request = try self.makeRequest(for: endpoint)
        let data = try await self.fetchData(for: request)

        return try self.decodeData(data)
    }

    private func makeRequest(for endpoint: Requestable) throws -> URLRequest {
        guard let url = URL(string: endpoint.urlString)
        else {
            throw NetworkError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = endpoint.httpMethod.rawValue
        request.httpBody = endpoint.httpBody

        return request
    }

    private func fetchData(for request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode,
                  Metric.validStatusCodeRange ~= statusCode
            else {
                throw NetworkError.serverSideError(statusCode: statusCode)
            }
            return data
        } catch {
            throw NetworkError.transportError
        }
    }

    private func decodeData<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailure
        }
    }
}


// MARK: - Constants
fileprivate extension NetworkManager {

    enum Metric {
        static let validStatusCodeRange = 200..<300
    }
}
