import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    let onTap: () -> Void

    var body: some View {
        Image(isFilled ? .starFilled : .starUnfilled)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 46, height: 46)
            .onTapGesture {
                onTap()
            }
    }
}
