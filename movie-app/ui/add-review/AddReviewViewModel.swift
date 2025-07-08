import Foundation
import InjectPropertyWrapper
import Combine

class AddReviewViewModel: ObservableObject, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var selectedRating: Int = -1
    @Published var success: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    let ratingButtonSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        mediaDetailSubject
            .sink { [weak self]detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
        
        ratingButtonSubject
            .flatMap { [weak self] _ -> AnyPublisher<ModifyMediaResult, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let rating: Double = Double(self.selectedRating)
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, rating: rating)
                
                return repository.addReview(req: request)
            }
            .sink{completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]result in
                self?.success = true
            }
            .store(in: &cancellables)
    }
}
