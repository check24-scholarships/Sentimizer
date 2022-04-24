//
//  AddActivitySheet.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 24.04.22.
//

import SwiftUI

struct AddActivitySheet: View {
    
    @Binding var presented: Bool
    @State var description = ""
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .leading) {
                Button {
                    presented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding([.top, .bottom])
                }
                
                HStack {
                    Spacer()
                    Text("Add Activity")
                        .font(.senti(size: 35))
                    Spacer()
                }
                
                NavigationLink {
                    MainActivityView()
                } label: {
                    SentiButton(icon: nil, title: "Choose Activity", style: .outlined, fontSize: 20, textColor: .gray)
                }
                .padding(.top, 60)
                
                Text("How do you feel?")
                    .font(.senti(size: 25))
                    .padding(.top, 30)
                    .padding(.leading)
                
                HStack {
                    Spacer()
                    ForEach(K.sentiments, id: \.self) { sent in
                        HStack(spacing: 0) {
                            if sent != K.sentiments[0] {
                                Divider()
                                    .frame(height: g.size.width/5 - 10)
                                    .padding(.trailing, 12)
                            }
                            Image(sent)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width/5 - 40)
                                .padding(.trailing, 7)
                                .padding([.top, .bottom])
                        }
                        
                    }
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 25).gradientForeground(.leading, .trailing))
                
                
                Text("What's happening?")
                    .font(.senti(size: 25))
                    .padding(.top, 30)
                    .padding(.leading)
                
                ZStack(alignment: .topLeading) {
                    if description.isEmpty {
                        Text("Describe what's going on...")
                            .font(.senti(size: 15))
                            .opacity(0.5)
                            .padding(7)
                    }
                    
                    TextEditor(text: $description)
                        .frame(height: 150)
                        .font(.senti(size: 15))
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray.opacity(0.3)))
                
                Spacer()
            }
            .foregroundColor(K.textColor)
            .padding([.leading, .trailing], 20)
        }
    }
}

struct AddActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddActivitySheet(presented: .constant(true))
    }
}
