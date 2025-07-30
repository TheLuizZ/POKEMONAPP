import SwiftUI

struct TitlePillView: View {
    let type: TypeInfo
    
    var body: some View {
        Text(type.displayName)
            .foregroundStyle(type.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.white)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth:1.5))
    }
}
