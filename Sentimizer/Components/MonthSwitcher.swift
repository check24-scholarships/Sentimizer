//
//  MonthSwitcher.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.05.22.
//

import SwiftUI

struct MonthSwitcher: View {
    @Binding var selectedMonth: Date
    
    var body: some View {
        HStack {
            Button {
                var dateComponent = DateComponents()
                dateComponent.month = -1
                selectedMonth = Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!
            } label: {
                Image(systemName: "arrow.left.circle")
                    .standardIcon(width: 30)
                    .padding(.leading)
            }
            Spacer()
            Text(Calendar.current.monthSymbols[Calendar.current.component(.month, from: selectedMonth)-1] + " \(Calendar.current.component(.year, from: selectedMonth))")
                .font(.senti(size: 25))
                .minimumScaleFactor(0.8)
                .padding()
            Spacer()
            Button {
                var dateComponent = DateComponents()
                dateComponent.month = 1
                selectedMonth = Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!
            } label: {
                Image(systemName: "arrow.right.circle")
                    .standardIcon(width: 30)
                    .padding(.trailing)
            }
        }
    }
}

struct MonthChooser_Previews: PreviewProvider {
    static var previews: some View {
        MonthSwitcher(selectedMonth: .constant(Date()))
    }
}
