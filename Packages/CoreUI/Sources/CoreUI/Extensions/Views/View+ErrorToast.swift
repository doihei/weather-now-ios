import SwiftUI

public extension View {
    func errorToast(message: String?) -> some View {
        overlay {
            if let message {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(Spacing.md)
                        .background(Color.red.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                        .padding()
                }
            }
        }
    }
}
