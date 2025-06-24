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

class MovieService_FetchMovies: AsyncSpec {
    
    override class func spec() {
        xdescribe("MovieService") {
            var sut: MovieService!
            var assembler: MainAssembler!
            var emittedResult: [[Movie]]?
            
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
                    var resultFromServer = [Movie]()
                    beforeEach {
                        emittedResult = [[Movie]]()
                        
                        resultFromServer = [
                            Movie(id: 550,
                                  title: "Fight Club",
                                  year: "1999",
                                  duration: "1h 25min",
                                  imageUrl: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
                                  rating: 8.439,
                                  voteCount: 30180,
                                  popularity: 40.2077)
                        ]
                        expectedFetchMoviesResponse =
                            .networkResponse(200, fetchMoviesSuccessResponseData)
                        
                        let result = try await sut.fetchMovies(req: FetchMoviesRequest(genreId: 18))
                        
                        emittedResult?.append(result)
                    }
                    
                    it("emits the correct movies") {
                        expect(emittedResult).to(equal([resultFromServer]))
                    }
                }
            }
        }
    }
}

extension MovieService_FetchMovies {
    
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

private let fetchMoviesSuccessResponseData =
"""
{
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg",
      "genre_ids": [
        18
      ],
      "id": 550,
      "original_language": "en",
      "original_title": "Fight Club",
      "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
      "popularity": 40.2077,
      "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
      "release_date": "1999-10-15",
      "title": "Fight Club",
      "video": false,
      "vote_average": 8.439,
      "vote_count": 30180
    }
]
}
""".data(using: String.Encoding.utf8)!
