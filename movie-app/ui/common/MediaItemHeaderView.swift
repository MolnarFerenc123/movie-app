import SwiftUI

struct MediaItemHeaderView: View {
    
    let title: String
    let year: String
    let runtime: String
    let spokenLanguages: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
            Text(title)
                .font(Fonts.detailsTitle)
            
            HStack(spacing: LayoutConst.normalPadding) {
                DetailLabel(title: "release.date", value: year)
                DetailLabel(title: "runtime", value: "\(runtime)")
                DetailLabel(title: "language", value: spokenLanguages)
            }
        }
    }
}
