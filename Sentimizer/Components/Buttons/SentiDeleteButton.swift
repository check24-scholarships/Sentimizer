//
//  SentiDeleteButton.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct SentiDeleteButton: View {
    let label: LocalizedStringKey
    let delete: () -> Void
    
    @State private var isPresentingConfirm = false
    
    var body: some View {
        Button {
            isPresentingConfirm = true
        } label: {
            Text(label)
                .font(.senti(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.brandColor1).opacity(0.1))
                .padding()
                .padding(.top)
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
            Button(label, role: .destructive) {
                delete()
            }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

struct SentiDeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        SentiDeleteButton(label: "Delete activity", delete: {})
    }
}
