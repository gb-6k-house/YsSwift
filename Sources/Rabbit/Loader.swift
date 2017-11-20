//
//  Loader.swift
//  Rabbit
//
//  Created by niupark on 2017/10/16.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import Foundation
import YsSwift
import Result


public protocol Loading {
    func loadImage(with request: Request, token: CancellationToken?, completion: @escaping (Result<Image, YsSwift.RequestError>) -> Void)
}


public final class Loader: Loading {
    private let loader: DataLoading
    private let decoder: DataDecoding
    //单例对象
    public static let shared: Loading = Loader(loader: LoaderDeduplicator(loader:  DataLoader()))

    public init(loader: DataLoading, decoder: DataDecoding = DataDecoder()) {
        self.loader = loader
        self.decoder = decoder

    }
 
    public func  loadImage(with request: Request, token: CancellationToken?, completion: @escaping (Result<Image, YsSwift.RequestError>) -> Void) {
        if token?.isCancelling == true { return } // Fast preflight check
        self.loadImage(with: Context(request: request, token: token, completion: completion))

    }
    
    private func loadImage(with ctx: Context) {
        self.loader.loadData(with: ctx.request, token: ctx.token) { [weak self] in
            switch $0 {
            case let .success(val): self?.decode(response: val, context: ctx)
            case let .failure(err): ctx.completion(.failure(err))
            }
        }
    }
    
    private func decode(response: (Data, URLResponse), context ctx: Context) {
        if let image = self.decoder.decode(data: response.0, response: response.1) {
            ctx.completion(.success(image))
        } else {
            ctx.completion(.failure(.decodingFailed))
        }

    }
    
    private struct Context {
        let request: Request
        let token: CancellationToken?
        let completion: (Result<Image, YsSwift.RequestError>) -> Void
    }
    
    /// Error returns by `Loader` class itself. `Loader` might also return
    /// errors from underlying `DataLoading` object.
    public enum Error: Swift.Error {
        case decodingFailed
        case processingFailed
    }
}
