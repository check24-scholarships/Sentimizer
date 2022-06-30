//
//  MonthSwitcher.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.05.22.
//

import SwiftUI

struct MonthSwitcher: View {
    @Binding var selectedMonth: Date
    var allowFuture = true
    
    let calendar = Calendar.current
    
    var disabled: Bool {
        !allowFuture
        && calendar.compare(selectedMonth, to: Date(), toGranularity: .month) == .orderedSame
        && calendar.compare(selectedMonth, to: Date(), toGranularity: .year) == .orderedSame
    }
    
    var body: some View {
        HStack {
            Button {
                selectedMonth = Date.appendMonths(to: selectedMonth, count: -1)
            } label: {
                Image(systemName: "arrow.left.circle")
                    .standardIcon(width: 30)
                    .padding(.leading)
            }
            Spacer()
            Text(calendar.monthSymbols[calendar.component(.month, from: selectedMonth)-1] + " \(calendar.component(.year, from: selectedMonth))")
                .font(.senti(size: 25))
                .minimumScaleFactor(0.8)
                .padding()
            Spacer()
            Button {
                selectedMonth = Date.appendMonths(to: selectedMonth, count: 1)
            } label: {
                Image(systemName: "arrow.right.circle")
                    .standardIcon(width: 30)
                    .padding(.trailing)
            }
            .disabled(disabled)
            .opacity(disabled ? 0.3 : 1)
        }
    }
}

struct MonthChooser_Previews: PreviewProvider {
    static var previews: some View {
        MonthSwitcher(selectedMonth: .constant(Date()))
    }
}
