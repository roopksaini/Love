import Foundation
import os.log
import WatchKit

// MARK: - 123Interface
// This component handles server integration and global consciousness tracking
// It connects individual consciousness transformations to the global network
// Every transformation contributes to the collective elevation of human consciousness

// MARK: - Notification Names
// Defines notification names for authentication events

extension Notification.Name {
    static let fluteSignOutRequired = Notification.Name("fluteSignOutRequired")
}

// MARK: - Request Types
// Defines different types of data requests for consciousness tracking

enum RequestType {
    case queuedData    // Use queued data for offline updates
    case freshData     // Fetch fresh data from server
}

// MARK: - Main Interface Class
// Manages all server communication and consciousness tracking

class 123Interface {
    // MARK: - Singleton Pattern
    // Shared instance for global access to consciousness network
    
    static let shared = 123Interface()
    
    // MARK: - Server Configuration
    // Base URL and authentication for consciousness network
    
    private let baseURL = "https://playing.love"
    var authToken: String?
    
    // MARK: - Data Queuing
    // In-memory queue for pending consciousness updates when offline
    
    private var queuedReceiving123s: Int = 0
    private var queuedPlaying123s: Int = 0
    
    // MARK: - Thread Safety
    // Simple lock for thread safety during authentication
    
    private let lock = NSLock()
    private var isRefreshing = false
    
    // MARK: - Initialization
    // Loads queued data and authentication from persistent storage
    
    private init() {
        // Load any previously queued values from UserDefaults
        queuedReceiving123s = UserDefaults.standard.integer(forKey: UserDefaultsKeys.queuedReceiving123s)
        queuedPlaying123s = UserDefaults.standard.integer(forKey: UserDefaultsKeys.queuedPlaying123s)
        authToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.authToken)
        
        print("🔌 Interface initialized - Queue: R:\(queuedReceiving123s) P:\(queuedPlaying123s) Auth:\(authToken != nil)")
    }

    // MARK: - Credential Management
    // Stores and manages user credentials for automatic authentication
    
    /// Stores user credentials for automatic login
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    private func storeCredentials(email: String, password: String) {
        print("🔐 Storing credentials for: \(email)")
        
        UserDefaults.standard.set(email, forKey: UserDefaultsKeys.userEmail)
        UserDefaults.standard.set(password, forKey: UserDefaultsKeys.password)
    }

    // MARK: - Authentication Refresh
    // Refreshes authentication when tokens expire
    
    /// Refreshes authentication using stored credentials
    /// - Parameter completion: Callback with success/failure result
    private func refreshAuth(completion: @escaping (Bool) -> Void) {
        print("🔄 Starting auth refresh")
        lock.lock()
        
        guard !isRefreshing else {
            print("⚠️ Auth refresh already in progress")
            lock.unlock()
            completion(false)
            return
        }
        
        guard let email = UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail),
              let password = UserDefaults.standard.string(forKey: UserDefaultsKeys.password) else {
            print("❌ No stored credentials found")
            lock.unlock()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .fluteSignOutRequired, object: nil)
            }
            completion(false)
            return
        }
        
        isRefreshing = true
        lock.unlock()
        
        print("🔄 Attempting auth refresh for: \(email)")
        
        login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            self.lock.lock()
            self.isRefreshing = false
            self.lock.unlock()
            
            switch result {
            case .success:
                print("✅ Auth refresh successful")
                completion(true)
            case .failure(let error):
                print("❌ Auth refresh failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    // MARK: - User Sign Out
    // Clears all user data and authentication
    
    /// Signs out the current user and clears all data
    func signOut() {
        print("🚪 User signing out")
        authToken = nil
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.authToken)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.password)
        
        NotificationCenter.default.post(name: .fluteSignOutRequired, object: nil)
    }

    // MARK: - Consciousness Points Update
    // Main function for updating consciousness transformation data
    
    /// Updates consciousness points on the global server
    /// - Parameters:
    ///   - receiving123sIncrement: Love downloaded from cosmos
    ///   - playing123sIncrement: Love consumed for transformation
    ///   - completion: Callback with result
    func updateFlutePoints(receiving123sIncrement: Int, playing123sIncrement: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        print("📡 Updating points - New: R:\(receiving123sIncrement) P:\(playing123sIncrement), Queued: R:\(queuedReceiving123s) P:\(queuedPlaying123s)")
        
        // On error, we'll only queue the new increments, not the totals
        let totalReceiving = queuedReceiving123s + receiving123sIncrement
        let totalPlaying = queuedPlaying123s + playing123sIncrement
        
        sendUpdate(receiving123sIncrement: totalReceiving, playing123sIncrement: totalPlaying) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("✅ Points update successful")
                // Clear the queue on success
                if self.queuedReceiving123s > 0 || self.queuedPlaying123s > 0 {
                    print("🧹 Clearing points queue")
                }
                self.queuedReceiving123s = 0
                self.queuedPlaying123s = 0
                UserDefaults.standard.set(0, forKey: UserDefaultsKeys.queuedReceiving123s)
                UserDefaults.standard.set(0, forKey: UserDefaultsKeys.queuedPlaying123s)
                completion(.success(()))
                
            case .failure(let error):
                if self.isAuthError(error) {
                    print("⚠️ Auth error detected during points update")
                    self.refreshAuth { success in
                        if success {
                            print("🔄 Auth refreshed, retrying points update")
                            // Retry the update with new token
                            self.sendUpdate(
                                receiving123sIncrement: totalReceiving,
                                playing123sIncrement: totalPlaying,
                                completion: completion
                            )
                        } else {
                            print("❌ Points update failed after auth refresh")
                            // Only queue the new increments, not the totals
                            self.queuePoints(receiving: receiving123sIncrement, playing: playing123sIncrement)
                            completion(.failure(error))
                        }
                    }
                } else {
                    print("❌ Points update failed")
                    // Only queue the new increments, not the totals
                    self.queuePoints(receiving: receiving123sIncrement, playing: playing123sIncrement)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Points Queuing
    // Queues consciousness updates when offline or server unavailable
    
    /// Queues consciousness points for later transmission
    /// - Parameters:
    ///   - receiving: Love downloaded increment
    ///   - playing: Love consumed increment
    private func queuePoints(receiving: Int, playing: Int) {
        print("📦 Queuing points update - Adding R:\(receiving) P:\(playing) to existing queue R:\(queuedReceiving123s) P:\(queuedPlaying123s)")
        
        // Add to existing queued points instead of overwriting
        queuedReceiving123s += receiving
        queuedPlaying123s += playing
        
        print("📦 Updated queue totals - R:\(queuedReceiving123s) P:\(queuedPlaying123s)")
        
        UserDefaults.standard.set(queuedReceiving123s, forKey: UserDefaultsKeys.queuedReceiving123s)
        UserDefaults.standard.set(queuedPlaying123s, forKey: UserDefaultsKeys.queuedPlaying123s)
    }
    
    // MARK: - Error Detection
    // Identifies authentication errors for automatic refresh
    
    /// Determines if an error is authentication-related
    /// - Parameter error: The error to check
    /// - Returns: True if the error is authentication-related
    private func isAuthError(_ error: Error) -> Bool {
        let errorMessage = error.localizedDescription.lowercased()
        return errorMessage.contains("token") ||
               errorMessage.contains("auth") ||
               errorMessage.contains("session") ||
               errorMessage.contains("unauthorized") ||
               errorMessage.contains("unauthenticated")
    }

    // MARK: - Server Communication
    // Sends consciousness updates to the global server
    
    /// Sends consciousness update to the server
    /// - Parameters:
    ///   - receiving123sIncrement: Total love downloaded
    ///   - playing123sIncrement: Total love consumed
    ///   - completion: Callback with result
    private func sendUpdate(receiving123sIncrement: Int, playing123sIncrement: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/heaven/123s")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 Using auth token for request")
        } else {
            print("⚠️ No auth token available")
        }

        let body: [String: Any] = [
            "receiving123s": receiving123sIncrement,
            "playing123s": playing123sIncrement,
            "singing123s": 0,
            "milestoning123s": 0,
            "timeZone": TimeZone.current.identifier
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ Network error during points update: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response Status: \(httpResponse.statusCode)")
                print("🔑 Auth Token: \(self?.authToken?.prefix(10) ?? "none")...")
                
                if let data = data, let str = String(data: data, encoding: .utf8) {
                    print("📝 Response Body: \(str)")
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Points update request successful")
                    completion(.success(()))
                    return
                }
                
                // For any server error, try refreshing auth first
                print("⚠️ Server error: Status \(httpResponse.statusCode)")
                print("📍 Current Auth State:")
                print("  - Token exists: \(self?.authToken != nil)")
                print("  - Email stored: \(UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) != nil)")
                
                // Try refreshing auth for any error
                self?.refreshAuth { success in
                    if success {
                        print("🔄 Auth refreshed, retrying request")
                        // Retry the request with new token
                        self?.sendUpdate(
                            receiving123sIncrement: receiving123sIncrement,
                            playing123sIncrement: playing123sIncrement,
                            completion: completion
                        )
                    } else {                      
                        let error = NSError(
                            domain: "123Interface",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"]
                        )
                        print("❌ Server error during points update")
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }

    // MARK: - User Authentication
    // Handles user login and token management
    
    /// Authenticates user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - completion: Callback with token or error
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("🔐 Login attempt for: \(email)")
        storeCredentials(email: email, password: password)
        
        let url = URL(string: "\(baseURL)/api/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ Network error during login: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ Server error during login")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let session = json["session"] as? [String: Any],
                   let accessToken = session["access_token"] as? String {
                    print("✅ Login successful")
                    self?.authToken = accessToken
                    UserDefaults.standard.set(accessToken, forKey: UserDefaultsKeys.authToken)
                    completion(.success(accessToken))
                } else {
                    print("❌ Invalid login response format")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                print("❌ Login response parsing error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - UserDefaults Keys
// Defines keys for persistent storage of consciousness data

struct UserDefaultsKeys {
    static let queuedReceiving123s = "queuedReceiving123s"
    static let queuedPlaying123s = "queuedPlaying123s"
    static let authToken = "authToken"
    static let userEmail = "userEmail"
    static let password = "password"
}

// MARK: - Preview Helper
// Helper class for SwiftUI previews

class Preview123Interface: 123Interface {
    override init() {
        super.init()
        // Set up preview data
    }
}

// MARK: - Preview
// Shows the 123Interface in action

#Preview {
    VStack(spacing: 20) {
        Text("123 Interface Demo")
            .font(.title)
            .foregroundStyle(.golden)

        Text("Ready to connect to consciousness network!")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.8))
    }
    .padding()
    .background(Color.black)
}
