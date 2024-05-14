//
//  NutrientsView.swift
//  Nutrition
//
//  Created by Robert Nash on 13/05/2024.
//

import SwiftUI
import Networking

struct NutrientsView: View {
    
    @State private var searchText = ""
    
    @StateObject private var model = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(model.foodItems) { item in
                        FoodCell(item: item)
                    }
                }
                .listStyle(PlainListStyle())
                Text("Total Calories: \(model.totalCalories.formatted(.number))")
                    .font(.headline)
                    .padding()
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(10)
                    .padding()
            }
            .onAppear(perform: {
                model.onAppear()
            })
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onChange(of: searchText, { _, newValue in
                model.textChanged(newValue)
            })
            .navigationTitle("Foods")
        }
    }
}

extension NutrientsView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        private(set) var foodItems: [Food] = []
        private(set) var totalCalories: Double = 0
        
        private static let threshold: Int = 3
        
        private let arbitrator = Arbitrator<String>(debounceInterval: 0.3)
        
        func onAppear() {
            arbitrator.ruling = { [weak self] text in
                if text.count >= Self.threshold {
                    self?.loadFoodItems(text: text)
                }
            }
        }
        
        func textChanged(_ text: String) {
            if text.count < Self.threshold {
                clear()
                objectWillChange.send()
            }
            arbitrator.disclose(text)
        }
        
        private func loadFoodItems(text: String) {
            Task {
                let service = try? NutrientsService(searchTerm: text)
                let items = (try? await service?.foodItems()) ?? []
                let foodItems = items.compactMap(Food.init(item:))
                self.foodItems = foodItems
                self.totalCalories = foodItems.reduce(0, { partialResult, item in
                    partialResult + item.nutrients.calories
                })
                objectWillChange.send()
            }
        }
        
        private func clear() {
            foodItems.removeAll()
            totalCalories = 0
        }
    }
}
