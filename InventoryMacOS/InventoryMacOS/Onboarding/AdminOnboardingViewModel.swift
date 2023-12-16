//
//  AdminOnboardingViewModel.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//


import FirebaseAuth // needed for AuthErrorCode in func handleLogin(email: String, password: String) async


/// `AdminOnboardingViewModel` is a view model class designed to handle the onboarding process for administrators in the InventoryMacOS application.
///  It provides functionality for admin login and logout, managing the authentication state, and handling input validation and error messages.
/// LIFECYCLE AND USAGE:
/// - This view model (`AdminOnboardingViewModel`) is instantiated within the `InventoryMacOSApp` as an `@StateObject`.
///   It's declared as a private variable to encapsulate its state within the app's lifecycle.
/// - It is then passed down to the `AdminOnboardingView` as an `@EnvironmentObject`.
///   This approach facilitates a shared state across the view hierarchy that uses this view model.
/// - The primary purpose of this architecture is to leverage the `isAuthenticated` property of the view model.
///   This property acts as a trigger within the `InventoryMacOSApp`'s main program file, allowing the application to transition from
///   the onboarding view (`AdminOnboardingView`) to the main dashboard view upon successful authentication.
/// - By using `@StateObject` and `@EnvironmentObject`, the view model maintains its state across the app's views, ensuring that
///   the authentication state is synchronized and accessible wherever needed.

class AdminOnboardingViewModel: ObservableObject {
    
    /// The email address entered by the user.
    @Published var email: String = ""
    
    /// The password entered by the user.
    @Published var password: String = ""
    
    /// An error message reflecting the state of the last operation (login or validation failure).
    @Published var errorMessage: String?
    
    /// A flag indicating whether the user is authenticated.
    /// since this view model is defined in the InventoryMacOSApp file, we use this variable to transition to the dashbaord view if/ when it is set to true.
    ///
    @Published var isAuthenticated: Bool = false

    /// A reference to the Firebase manager handling the actual authentication with Firebase.
    private let onboardingFirebase = AdminOnboardingFirebaseManager.shared

    /// Attempts to log in an admin user with the provided email and password.
    /// This method first validates the input and then tries to authenticate the user using Firebase.
    /// - Parameters:
    ///   - email: The email address of the admin user.
    ///   - password: The password of the admin user.
    /// - Precondition: `email` and `password` should not be empty.
    /// - Postcondition: If the login is successful, `isAuthenticated` is set to `true`. Otherwise, an error message is set, and `isAuthenticated` is `false`.
    func handleLogin(email: String, password: String) async {
        // Reset error message on the main thread, all UI updates done on main thread
        DispatchQueue.main.async {
            self.errorMessage = nil
        }

        // Ensure input neither email or password are empty strings
        guard validateInput() else { return }

        do {
            // Attempt to login, disregard the AuthDataResult we get back
            _ = try await onboardingFirebase.login(email: email, password: password)

            // Update authentication state on successful login
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        } catch {
            DispatchQueue.main.async {
                // Default error message
                var message = "Failed to login due to an unexpected error."

                if let nsError = error as NSError? {
                    switch nsError.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        message = "Incorrect password. Please try again."
                    case AuthErrorCode.invalidEmail.rawValue:
                        message = "Invalid email format. Please enter a correct email."
                    case AuthErrorCode.userNotFound.rawValue:
                        message = "No user found with this email. Please sign up."
                    case AuthErrorCode.userDisabled.rawValue:
                        message = "This user account has been disabled. Please contact support."
                    case AuthErrorCode.networkError.rawValue:
                        message = "Network error. Please check your internet connection."
                    // Add more cases for specific errors you want to handle
                    default:
                        message = nsError.localizedDescription
                    }
                }

                self.errorMessage = message
                self.isAuthenticated = false
            }
        }

    }

    /// Validates the input email and password.
    /// - Returns: `true` if the input is valid, `false` otherwise.
    /// - Postcondition: If invalid, `errorMessage` is set with a relevant message.
    ///
    /// This method performs detailed validation of the email and password. The email validation is divided into two parts: the local part (before the '@') and the domain part (including domain labels and the top-level domain). The local part is validated to ensure it contains only letters and digits. The domain part is further split into domain labels and the top-level domain, with validations to ensure each label contains only letters and digits, and the top-level domain is one of the predefined allowed domains.
    ///
    /// The validation process is as follows:
    /// 1. The email is split into its local and domain parts at the '@' symbol. The local part is validated using a regular expression that permits only letters and digits.
    /// 2. The domain part is split at each period ('.'). The domain labels (all parts before the final period) are validated to ensure they contain only letters and digits. The top-level domain (the part after the final period) is checked against a set of allowed domains (like 'com', 'net', 'co.uk', etc.).
    /// 3. The password is checked to ensure it is not empty and is at least 6 characters long, providing basic password strength validation.
    ///
    /// If any of these validations fail, an appropriate error message is set, guiding the user to correct the input. This method ensures both the email and password meet specific criteria for format and security, thereby maintaining data integrity and standardizing user input.

    private func validateInput() -> Bool {
        // Check if email or password is empty
        if email.isEmpty || password.isEmpty {
            DispatchQueue.main.async{
                self.errorMessage = "Email and password must not be empty."
            }
            
            return false
        }

        // Split the email into local part and domain part
        let emailParts = email.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: true)
        guard emailParts.count == 2 else {
            DispatchQueue.main.async{
                self.errorMessage = "Invalid email format."
            }
            return false
        }
        let localPart = emailParts[0]
        let domainParts = emailParts[1].split(separator: ".", omittingEmptySubsequences: true)

        // Validate the local part (only letters and digits)
        let localPartRegex = "^[A-Za-z0-9]+$"
        let localPartTest = NSPredicate(format: "SELF MATCHES %@", localPartRegex)

        // Validate the domain part (letters and digits for domain labels)
        let domainLabelRegex = "^[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*$"
        let domainLabelTest = NSPredicate(format: "SELF MATCHES %@", domainLabelRegex)

        // Set of allowed top-level domains, change as needed to allow for more domains
        let allowedTopLevelDomains: Set = ["com", "net", "co.uk", "org", "edu"]

        // Perform validations
        if !localPartTest.evaluate(with: String(localPart)) {
            errorMessage = "Email's local part must only contain letters and digits."
            return false
        }

        if !domainLabelTest.evaluate(with: String(domainParts.dropLast().joined(separator: "."))) ||
            !allowedTopLevelDomains.contains(String(domainParts.last ?? "")) {
            errorMessage = "Email's domain must be valid and its top-level domain must be one of the allowed domains: \(allowedTopLevelDomains.joined(separator: ", "))."
            return false
        }

        // Check for password length
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }

        return true
    }

    /// Logs out the currently authenticated admin user.
    /// - Postcondition: `isAuthenticated` is set to `false`.
    func logout() {
        // Implement logout logic
        isAuthenticated = false
    }
}
