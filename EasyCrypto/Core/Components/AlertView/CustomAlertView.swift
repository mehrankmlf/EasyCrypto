import SwiftUI

struct CustomAlertView: View {
    var title: String?
    var message: String?
    var primaryButtonLabel: String
    var primaryButtonAction: () -> Void
    var secondaryButtonLabel: String?
    var secondaryButtonAction: (() -> Void)?
    var image: Image?
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } else if let title = title{
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    self.primaryButtonAction()
                }, label: {
                    Text(primaryButtonLabel)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(12)
                })
                if let secondaryButtonLabel = secondaryButtonLabel {
                    Button(action: {
                        self.secondaryButtonAction?()
                    }, label: {
                        Text(secondaryButtonLabel)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    })
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
