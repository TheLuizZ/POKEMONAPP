import SwiftUI

struct StatRowView: View {
    let stat: Stat
    let barColor: Color
    
    var body: some View {
        HStack {
            Text(stat.displayName)
                .frame(width: 130, alignment: .leading)
                .font(.subheadline)
                .foregroundStyle(Color.black)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: geometry.size.width, height: 15)
                        .foregroundStyle(barColor)
                        .opacity(0.50)
                    
                    Capsule()
                        .frame(width: geometry.size.width * stat.normalizedValue, height: 15)
                        .foregroundStyle(barColor)
                }
                .padding(.top, 3)
            }
            
            Text(stat.formattedStat)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
