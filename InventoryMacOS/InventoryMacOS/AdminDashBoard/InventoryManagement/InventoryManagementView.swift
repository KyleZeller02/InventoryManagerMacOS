//
//  InventoryManagementView.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI

struct InventoryManagementView: View {
    @State private var searchText: String = ""
    @State private var showingScanner = false  // To show/hide barcode scanner
    @State private var filterByPrice: Double?  // Optional filter by price
    @State private var filterByStoreId: String = ""
    @State private var filterByQuantity: Int?  // Optional filter by quantity

    var body: some View {
        VStack {
            HStack {
                TextField("Search Items", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                
            }
            .padding()

            Divider()

            VStack {
                // Filter controls
                HStack {
                    // Price filter
                    TextField("Filter by Price", value: $filterByPrice, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Store ID filter
                    TextField("Filter by Store ID", text: $filterByStoreId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Quantity filter
                    TextField("Filter by Quantity", value: $filterByQuantity, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                List(InventoryItem.sampleItems) { item in
                    HStack {
                        item.image
                            .resizable()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.description).font(.subheadline)
                            Text("Available at: \(item.storeIds.joined(separator: ", "))").font(.subheadline)// Display store IDs
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("$\(item.price, specifier: "%.2f")")
                            Text("Count: \(item.count)")
                        }
                    }
                }
            }

            // Show barcode scanner
            .sheet(isPresented: $showingScanner) {
                AddInventoryItemView(isPresented: $showingScanner,storeIds: ["Store 1", "Store 2", "Store 3"])
            }
            Button(action: {
                showingScanner = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Item")
                    }
                    .padding()
                    .cornerRadius(10)
        }
    }
}

struct AddInventoryItemView: View {
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double = 0.0
    @State private var count: Int = 0
    @State private var selectedStoreIds: Set<String> = []
    let storeIds: [String] // Assuming this is passed in or fetched

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Add Inventory Item").font(.headline)
           

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Text("Price:")
                Spacer()
                TextField("0.0", value: $price, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Text("Count: \(count)")
                Spacer()
                Stepper("", value: $count, in: 0...1000)
            }

            Text("Select Stores:")
                .font(.headline)

            List(storeIds, id: \.self, selection: $selectedStoreIds) { storeId in
                Text(storeId)
            }
            .listStyle(InsetListStyle())

           
            Spacer()
        }
        .padding()
        .frame(minWidth: 300, minHeight: 400)
        .toolbar {
            // Add close button to the toolbar
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    isPresented = false // Dismiss the view when the close button is tapped
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    isPresented = false // Dismiss the view when the close button is tapped
                }) {
                    Button("Add Item") {
                        addItem()
                    }
                    
                }
            }
        }
    }

    private func addItem() {
        // Implement the logic to add the item to the selected stores
        print("Adding item: \(name) to stores: \(selectedStoreIds)")
    }
}



#Preview {
    InventoryManagementView()
}
