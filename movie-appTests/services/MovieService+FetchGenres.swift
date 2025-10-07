//
//  MovieService+FetchGenres.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 22..
//

@testable import movie_app
import Nimble
import Quick
import Moya
import Foundation
import Swinject
import InjectPropertyWrapper

private var fetchMoviesParameters: FetchMoviesRequest?
private var expectedFetchMoviesResponse: EndpointSampleResponse =
    .networkResponse(502, Data())

class MovieService_FetchGenres: AsyncSpec {
    
    override class func spec() {
        xdescribe("MovieService") {
            var sut: MovieService!
            var assembler: MainAssembler!
            var emittedResult: [[Genre]]?
            
            beforeEach {
                assembler = MainAssembler.create(withAssemblies: [TestAssembly()])
                InjectSettings.resolver = assembler.container
                
                sut = assembler.resolver.resolve(MovieService.self)
            }
            
            afterEach {
                sut = nil
                assembler.dispose()
                emittedResult = nil
            }
            
            context("fetchGenres") {
                context("on success") {
                    var resultFromServer = [Genre]()
                    beforeEach {
                        emittedResult = [[Genre]]()
                        
                        resultFromServer = [
                            Genre(id: 28, name: "Action"),
                            Genre(id: 12, name: "Adventure"),
                        ]
//                        let responseFromServer = try! JSONDecoder().decode(GenreListResponse.self,
//                                                                     from: fetchGenresSuccessResponseData)
//
//                        resultFromServer = responseFromServer.genres.map { genreResponse in
//                            Genre(dto: genreResponse)
//                        }
                        expectedFetchMoviesResponse =
                            .networkResponse(200, fetchGenresSuccessResponseData)
                        
                        let result = try await sut.fetchGenres(req: FetchGenreRequest())
                        
                        emittedResult?.append(result)
                    }
                    
                    it("emits the correct genres") {
                        expect(emittedResult).to(equal([resultFromServer]))
                    }
                }
            }
        }
    }
}

extension MovieService_FetchGenres {
    
    class TestAssembly: TestServiceAssembly {
        override func assemble(container: Container) {
            super.assemble(container: container)
            container.register(MovieService.self) { _ in
                let instance = MovieService()
                return instance
            }.inObjectScope(.transient)
        }
        
        override func createStubEndpoint(withMultiTarget multiTarget: MultiTarget) -> Endpoint {
            guard let target = multiTarget.target as? MoviesApi else {
                preconditionFailure("Target is not \(String(describing: MoviesApi.self))")
            }
            
            var sampleResponseClosure: Endpoint.SampleResponseClosure
            switch target {
            case let .fetchMovies(req):
                fetchMoviesParameters = req
                sampleResponseClosure = { expectedFetchMoviesResponse }
            default:
                sampleResponseClosure = { .networkResponse(502, Data()) }
            }
            return Endpoint(
                url: url(target),
                sampleResponseClosure: sampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers)
        }
        
    }
}

private let fetchGenresSuccessResponseData =
"""
{
  "genres": [
    {
      "id": 28,
      "name": "Action"
    },
    {
      "id": 12,
      "name": "Adventure"
    }
  ]
}
""".data(using: String.Encoding.utf8)!

class TestServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MoyaProvider<MultiTarget>.self) { _ in
            return MoyaProvider<MultiTarget>(
                endpointClosure: self.createStubEndpoint,
                stubClosure: MoyaProvider.immediatelyStub,
                plugins: [NetworkLoggerPlugin(
                    configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
        }.inObjectScope(.container)
    }

    func createStubEndpoint(withMultiTarget multiTarget: MultiTarget) -> Endpoint {
        fatalError("Need to override")
    }

    func url(_ target: TargetType) -> String {
        return target.baseURL.appendingPathComponent(target.path).absoluteString
    }

}
