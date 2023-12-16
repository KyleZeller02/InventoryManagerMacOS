//
//  AdminOnboardingFirebaseManager.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//


import Firebase

/// `AdminOnboardingFirebaseManager` is responsible for handling the onboarding-related Firebase operations for administrators in the Inventory Management application. This class primarily deals with authentication tasks using Firebase Authentication.
///
/// Singleton Implementation:
/// - This class is implemented as a singleton, ensuring a single, consistent instance is used throughout the application for Firebase operations.
/// - `shared`: A static property providing access to the singleton instance.
///
/// Primary Functionality:
/// - `login`: Asynchronously handles administrator login using Firebase Authentication.
///   - Parameters: Email and password of the administrator.
///   - Returns: An `AuthDataResult` object containing authenticated user information.
///   - Throws: An error if the login operation fails.
///
/// Alternative Authentication Method:
/// - For scenarios where Firebase authentication is not desired or feasible, this class can be adjusted or removed.
/// - A hardcoded authentication check can be implemented using predefined credentials:
///   - Email: `admin@storemaster.com`
///   - Password: `123456`
/// - In such a case, the `login` method can be modified to compare the input credentials against these hardcoded values instead of using Firebase.
///
/// Note:
/// - If the application's requirements change and Firebase authentication is no longer needed, this class can be safely removed or replaced with an alternative authentication mechanism.
///
/// Example Usage:
/// ```
/// let firebaseManager = AdminOnboardingFirebaseManager.shared
/// do {
///     let authResult = try await firebaseManager.login(email: "user@example.com", password: "password123")
///     // Handle successful authentication
/// } catch {
///     // Handle authentication error
/// }
/// ```
class AdminOnboardingFirebaseManager {
    static let shared = AdminOnboardingFirebaseManager()
    
    /// Performs a login operation for an administrator using Firebase Authentication.
    /// - Parameters:
    ///   - email: The email address of the administrator.
    ///   - password: The password of the administrator.
    /// - Returns: An `AuthDataResult` object containing information about the authenticated user.
    /// - Throws: An error if the login operation fails.
    func login(email: String, password: String) async throws -> AuthDataResult {
        // Perform the login operation using Firebase Authentication
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult
    }
}

