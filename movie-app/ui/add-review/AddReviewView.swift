import SwiftUI

struct AddReviewView: View {
    
    let mediaItemDetail: MediaItemDetail
    
    @StateObject private var viewModel = AddReviewViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                MediaItemHeaderView(title: viewModel.mediaItemDetail.title,
                                    year: viewModel.mediaItemDetail.year,
                                    runtime: "\(viewModel.mediaItemDetail.runtime)",
                                    spokenLanguages: viewModel.mediaItemDetail.langList)
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                Text(LocalizedStringKey("addReview.subTitle"))
                    .font(Fonts.detailsTitle)
                HStack{
                    
                }
                HStack{
                    Spacer()
                    VStack{
                        StarRatingView(rating: $viewModel.selectedRating)
                            .padding(.bottom, 72)
                        StyledButton(style: .filled, action: .simple, title: "addReview.buttonTitle")
                            .onTapGesture {
                                viewModel.ratingButtonSubject.send(())
                            }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .padding(.horizontal, LayoutConst.largePadding)
        .onAppear {
            viewModel.mediaDetailSubject.send(mediaItemDetail)
        }
        
    }
}
