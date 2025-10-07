import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    let onTap: () -> Void
    var size: CGFloat = 40.0

    var body: some View {
        Image(isFilled ? .starFilled : .starUnfilled)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .onTapGesture {
                onTap()
            }
    }
}
