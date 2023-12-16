//
//  UserAccountManagementView.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI

struct UserAccountManagementView: View {
    @State private var employees = Employee.sampleUsers // Using sample data
    @State private var showAddEmployeeView = false

    var body: some View {
        VStack {
            List(employees) { employee in
                HStack {
                    Text(employee.employeeId)
                    Spacer()
                    Text("\(employee.yearsOfWorking) years")
                    Text(employee.role.rawValue)
                }
            }

            Button(action: {
                showAddEmployeeView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Employee")
                    }
                    .padding()
                    .cornerRadius(10)
        }
        .sheet(isPresented: $showAddEmployeeView) {
            // Replace with your actual AddEmployeeView
            AddEmployeeView(isPresented: $showAddEmployeeView)
        }
    }
}

struct AddEmployeeView: View {
    @Binding var isPresented: Bool

    @State private var storeId: String = ""
    @State private var employeeId: String = ""
    @State private var startDate: Date = Date()
    @State private var role: Role = .partTime
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Add New Employee")
                .font(.headline)
                .padding()

            VStack {
                TextField("Store ID", text: $storeId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Employee ID", text: $employeeId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                Picker("Role", selection: $role) {
                    ForEach(Role.allCases, id: \.self) { role in
                        Text(role.rawValue).tag(role)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()

            HStack {
                Button("Cancel") {
                    isPresented = false
                }

                Button("Add Employee") {
                    addEmployee()
                }
            }
            .padding()
        }
        .frame(width: 400, height: 400)
    }

    func addEmployee() {
        // Implement the logic to add an employee
        print("Adding Employee: \(employeeId)")
        isPresented = false
    }
}



#Preview {
    UserAccountManagementView()
}
