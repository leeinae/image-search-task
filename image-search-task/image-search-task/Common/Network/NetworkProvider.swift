//
//  NetworkProvider.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/01.
//

import Alamofire
import Foundation
import RxSwift

final class NetworkProvider {
    static let shared = NetworkProvider()

    private init() {}

    func request<T: Decodable>(
        _ api: NetworkRequestable,
        _ model: T.Type
    ) -> Single<ResponseModel<T>> {
        Single<ResponseModel<T>>.create { single -> Disposable in
            do {
                let endpoint = try api.endpoint()
                let parameters = api.parameters ?? [:]

                AF.request(
                    endpoint,
                    method: api.method,
                    parameters: parameters,
                    headers: api.headers
                )
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: ResponseModel<T>.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case let .success(data):
                        single(.success(data))
                    case let .failure(error):
                        switch response.response?.statusCode {
                        case 200:
                            single(.failure(NetworkError.parsingError))
                        case 401, 402:
                            single(.failure(NetworkError.apiTokenError))
                        default:
                            single(.failure(NetworkError.responseError(error)))
                        }
                    }
                }
                return Disposables.create()
            } catch {
                single(.failure(NetworkError.wrongRequest))
                return Disposables.create()
            }
        }
    }
}
