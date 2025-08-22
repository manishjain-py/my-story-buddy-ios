import SwiftUI

@main
struct MyStoryBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Theme System for Dark Mode Support

struct AppTheme {
    // Background colors
    static var primaryBackground: Color {
        Color(UIColor.systemBackground)
    }
    
    static var secondaryBackground: Color {
        Color(UIColor.secondarySystemBackground)
    }
    
    static var tertiaryBackground: Color {
        Color(UIColor.tertiarySystemBackground)
    }
    
    static var cardBackground: Color {
        Color(UIColor.systemBackground)
    }
    
    // Text colors
    static var primaryText: Color {
        Color(UIColor.label)
    }
    
    static var secondaryText: Color {
        Color(UIColor.secondaryLabel)
    }
    
    static var tertiaryText: Color {
        Color(UIColor.tertiaryLabel)
    }
    
    // Border and separator colors
    static var separator: Color {
        Color(UIColor.separator)
    }
    
    static var border: Color {
        Color(UIColor.separator)
    }
    
    // Button and interactive colors
    static var accentColor: Color {
        Color.accentColor
    }
    
    static var buttonBackground: Color {
        Color(UIColor.systemFill)
    }
    
    static var destructiveColor: Color {
        Color(UIColor.systemRed)
    }
    
    static var successColor: Color {
        Color(UIColor.systemGreen)
    }
    
    static var warningColor: Color {
        Color(UIColor.systemOrange)
    }
    
    // Input field colors
    static var inputBackground: Color {
        Color(UIColor.systemGray6)
    }
    
    static var inputBorder: Color {
        Color(UIColor.systemGray4)
    }
    
    // Modal and overlay colors
    static var overlayBackground: Color {
        Color.black.opacity(0.5)
    }
    
    static var modalBackground: Color {
        Color(UIColor.systemBackground)
    }
}

// MARK: - Auth Models

struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct SignupRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct AuthResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case user
    }
}


// MARK: - Story Models

struct Story: Codable {
    let title: String
    let story: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case story
        case imageUrl = "image_url"
    }
}

struct MyStoriesResponse: Codable {
    let stories: [MyStory]
    let newStoriesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case stories
        case newStoriesCount = "new_stories_count"
    }
}

struct MyStory: Codable, Identifiable {
    let id: Int
    let title: String
    let prompt: String
    let storyContent: String
    let imageUrls: [String]?
    let formats: [String]?
    let status: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case prompt
        case storyContent = "story_content"
        case imageUrls = "image_urls"
        case formats
        case status
        case createdAt = "created_at"
    }
    
    // For compatibility with story viewer navigation
    var source: String { return "user" }
}

struct PublicStory: Codable, Identifiable {
    let id: Int
    let title: String
    let storyContent: String
    let prompt: String
    let imageUrls: [String]?
    let formats: [String]?
    let category: String
    let ageGroup: String
    let featured: Int
    let tags: [String]?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case storyContent = "story_content"
        case prompt
        case imageUrls = "image_urls"
        case formats
        case category
        case ageGroup = "age_group"
        case featured
        case tags
        case createdAt = "created_at"
    }
    
    // For compatibility with story viewer
    var source: String { return "public" }
    var status: String { return "NEW" }
}

struct Avatar: Codable {
    let avatarName: String
    let traitsDescription: String
    let s3ImageUrl: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case avatarName = "avatar_name"
        case traitsDescription = "traits_description"
        case s3ImageUrl = "s3_image_url"
        case createdAt = "created_at"
    }
}

struct CompletedAvatarsCountResponse: Codable {
    let completedAvatarsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case completedAvatarsCount = "completed_avatars_count"
    }
}

struct StoryRequest: Codable {
    let prompt: String
    let formats: [String]
}

struct StorySubmissionResponse: Codable {
    let storyId: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case storyId = "story_id"
        case status
    }
}

struct StoryStatusResponse: Codable {
    let status: String
    let title: String?
    let story: String?
    let imageUrls: [String]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case title
        case story = "story"
        case imageUrls = "image_urls"
    }
}

struct FunFact: Codable {
    let question: String
    let answer: String
}

struct FunFactsResponse: Codable {
    let facts: [FunFact]
}

enum StoryFormat: String, CaseIterable {
    case comicBook = "Comic Book"
    case textStory = "Text Story"
    case animatedVideo = "Animated Video"
    case audioStory = "Audio Story"
    
    var icon: String {
        switch self {
        case .comicBook: return "📚"
        case .textStory: return "📄"
        case .animatedVideo: return "🎬"
        case .audioStory: return "🎧"
        }
    }
    
    var isAvailable: Bool {
        switch self {
        case .comicBook, .textStory: return true
        case .animatedVideo, .audioStory: return false
        }
    }
}

// MARK: - Auth Service

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    private let baseURL = "https://www.mystorybuddy.com/api"
    private let session = URLSession.shared
    
    private init() {}
    
    enum AuthError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(String)
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            throw AuthError.networkError("Failed to encode request: \(error.localizedDescription)")
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw AuthError.networkError("Network request failed: \(error.localizedDescription)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AuthError.networkError("Server error (\(httpResponse.statusCode)): \(errorMessage)")
        }
        
        do {
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            return authResponse
        } catch {
            print("Decoding error: \(error)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
            throw AuthError.decodingError
        }
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let signupRequest = SignupRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        request.httpBody = try JSONEncoder().encode(signupRequest)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw AuthError.invalidResponse
        }
        
        do {
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            return authResponse
        } catch {
            print("Decoding error: \(error)")
            throw AuthError.decodingError
        }
    }
    
    func checkAuth(token: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/auth/me") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.invalidResponse
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            print("Decoding error: \(error)")
            throw AuthError.decodingError
        }
    }
    
    func logout(token: String) async throws {
        guard let url = URL(string: "\(baseURL)/auth/logout") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.invalidResponse
        }
    }
    
    func deleteAccount(token: String) async throws {
        guard let url = URL(string: "\(baseURL)/auth/delete-account") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AuthError.networkError("Account deletion failed (\(httpResponse.statusCode)): \(errorMessage)")
        }
    }
    
}

// MARK: - Story Service

class StoryService: ObservableObject {
    static let shared = StoryService()
    
    private let baseURL = "https://www.mystorybuddy.com/api"
    private let session = URLSession.shared
    
    private init() {}
    
    enum StoryError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(String)
    }
    
    func generateStory(prompt: String, formats: [String], token: String?) async throws -> StorySubmissionResponse {
        guard let url = URL(string: "\(baseURL)/generateStory") else {
            throw StoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add authentication header if available
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let storyRequest = StoryRequest(prompt: prompt, formats: formats)
        
        do {
            request.httpBody = try JSONEncoder().encode(storyRequest)
        } catch {
            throw StoryError.networkError("Failed to encode request: \(error.localizedDescription)")
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw StoryError.networkError("Network request failed: \(error.localizedDescription)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StoryError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw StoryError.networkError("Server error (\(httpResponse.statusCode)): \(errorMessage)")
        }
        
        do {
            let submissionResponse = try JSONDecoder().decode(StorySubmissionResponse.self, from: data)
            return submissionResponse
        } catch {
            print("Decoding error: \(error)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
            throw StoryError.decodingError
        }
    }
    
    func checkStoryStatus(storyId: Int, token: String?) async throws -> StoryStatusResponse {
        guard let url = URL(string: "\(baseURL)/story/\(storyId)/status") else {
            throw StoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add authorization header if token is provided
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw StoryError.invalidResponse
        }
        
        do {
            let statusResponse = try JSONDecoder().decode(StoryStatusResponse.self, from: data)
            return statusResponse
        } catch {
            print("Decoding error: \(error)")
            throw StoryError.decodingError
        }
    }
    
    func fetchFunFacts(prompt: String, token: String?) async throws -> [FunFact] {
        guard let url = URL(string: "\(baseURL)/generateFunFacts") else {
            throw StoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add authorization header if token is provided
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body = ["prompt": prompt]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw StoryError.invalidResponse
        }
        
        do {
            let funFactsResponse = try JSONDecoder().decode(FunFactsResponse.self, from: data)
            return funFactsResponse.facts
        } catch {
            print("Decoding error: \(error)")
            // Return default fun facts if API fails
            return [
                FunFact(question: "Did you know stories can take you anywhere?",
                       answer: "Yes! With your imagination, you can visit magical worlds."),
                FunFact(question: "Did you know reading helps your brain grow?",
                       answer: "Amazing! Every story makes your mind stronger and smarter.")
            ]
        }
    }
}

// MARK: - My Stories Service

class MyStoriesService: ObservableObject {
    static let shared = MyStoriesService()
    
    private let baseURL = "https://www.mystorybuddy.com/api"
    private let session = URLSession.shared
    
    private init() {}
    
    enum MyStoriesError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(String)
    }
    
    func fetchMyStories(token: String) async throws -> MyStoriesResponse {
        guard let url = URL(string: "\(baseURL)/my-stories") else {
            throw MyStoriesError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MyStoriesError.invalidResponse
        }
        
        do {
            let myStoriesResponse = try JSONDecoder().decode(MyStoriesResponse.self, from: data)
            return myStoriesResponse
        } catch {
            print("Decoding error: \(error)")
            throw MyStoriesError.decodingError
        }
    }
    
    func markStoryAsViewed(storyId: Int, token: String) async throws {
        guard let url = URL(string: "\(baseURL)/story/\(storyId)/viewed") else {
            throw MyStoriesError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MyStoriesError.invalidResponse
        }
    }
}

// MARK: - Personalization Service

class PersonalizationService: ObservableObject {
    static let shared = PersonalizationService()
    
    private let baseURL = "https://www.mystorybuddy.com/api"
    private let session = URLSession.shared
    
    private init() {}
    
    enum PersonalizationError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(String)
    }
    
    func fetchAvatar(token: String) async throws -> Avatar? {
        guard let url = URL(string: "\(baseURL)/personalization/avatar") else {
            throw PersonalizationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PersonalizationError.invalidResponse
        }
        
        if httpResponse.statusCode == 404 {
            return nil // No avatar exists
        }
        
        guard httpResponse.statusCode == 200 else {
            throw PersonalizationError.invalidResponse
        }
        
        do {
            let avatar = try JSONDecoder().decode(Avatar.self, from: data)
            return avatar
        } catch {
            print("Decoding error: \(error)")
            throw PersonalizationError.decodingError
        }
    }
    
    func createAvatar(avatarName: String, traitsDescription: String, imageData: Data, token: String) async throws {
        guard let url = URL(string: "\(baseURL)/personalization/avatar/async") else {
            throw PersonalizationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add avatar_name field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"avatar_name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(avatarName)\r\n".data(using: .utf8)!)
        
        // Add traits_description field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"traits_description\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(traitsDescription)\r\n".data(using: .utf8)!)
        
        // Add image field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PersonalizationError.invalidResponse
        }
    }
    
    func updateAvatar(avatarName: String, traitsDescription: String, token: String) async throws -> Avatar {
        guard let url = URL(string: "\(baseURL)/personalization/avatar") else {
            throw PersonalizationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = [
            "avatar_name": avatarName,
            "traits_description": traitsDescription
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PersonalizationError.invalidResponse
        }
        
        do {
            let avatar = try JSONDecoder().decode(Avatar.self, from: data)
            return avatar
        } catch {
            print("Decoding error: \(error)")
            throw PersonalizationError.decodingError
        }
    }
    
    func fetchCompletedAvatarsCount(token: String) async throws -> Int {
        guard let url = URL(string: "\(baseURL)/personalization/completed-count") else {
            throw PersonalizationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PersonalizationError.invalidResponse
        }
        
        do {
            let countResponse = try JSONDecoder().decode(CompletedAvatarsCountResponse.self, from: data)
            return countResponse.completedAvatarsCount
        } catch {
            print("Decoding error: \(error)")
            return 0
        }
    }
}

// MARK: - Navigation Manager

enum AppPage: String, CaseIterable {
    case home = "home"
    case publicStories = "public-stories"
    case myStories = "my-stories"
    case storyViewer = "story-viewer"
    case personalization = "personalization"
    
    var title: String {
        switch self {
        case .home: return "Storytime"
        case .publicStories: return "Public Stories"
        case .myStories: return "My Stories"
        case .storyViewer: return "Story"
        case .personalization: return "Personalization"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "🏠"
        case .publicStories: return "🌟"
        case .myStories: return "📖"
        case .storyViewer: return "📚"
        case .personalization: return "🎭"
        }
    }
}

@MainActor
class NavigationManager: ObservableObject {
    @Published var currentPage: AppPage = .home
    @Published var selectedStory: MyStory?
    @Published var newStoriesCount: Int = 0
    @Published var completedAvatarsCount: Int = 0
    
    func goToPage(_ page: AppPage) {
        currentPage = page
        if page != .storyViewer {
            selectedStory = nil
        }
    }
    
    func goToStoryViewer(story: MyStory) {
        selectedStory = story
        currentPage = .storyViewer
    }
    
    func goBack() {
        switch currentPage {
        case .storyViewer:
            // Go back to the page where the story was selected from
            currentPage = selectedStory?.source == "public" ? .publicStories : .myStories
            selectedStory = nil
        case .publicStories, .myStories, .personalization:
            currentPage = .home
        case .home:
            break
        }
    }
    
    func updateNewStoriesCount(_ count: Int) {
        newStoriesCount = count
    }
    
    func updateCompletedAvatarsCount(_ count: Int) {
        completedAvatarsCount = count
    }
}

// MARK: - Auth View Model

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var token: String?
    @Published var isAuthenticated = false
    @Published var loading = false
    @Published var error = ""
    
    private let authService = AuthService.shared
    private let userDefaultsKey = "auth_token"
    
    init() {
        checkStoredAuth()
    }
    
    private func checkStoredAuth() {
        if let storedToken = UserDefaults.standard.string(forKey: userDefaultsKey) {
            token = storedToken
            Task {
                await validateToken(storedToken)
            }
        }
    }
    
    private func validateToken(_ token: String) async {
        do {
            let user = try await authService.checkAuth(token: token)
            self.user = user
            self.isAuthenticated = true
        } catch {
            // Token is invalid, clear it
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            self.token = nil
            self.user = nil
            self.isAuthenticated = false
        }
    }
    
    func login(email: String, password: String) async {
        loading = true
        error = ""
        
        do {
            let response = try await authService.login(email: email, password: password)
            self.token = response.accessToken
            self.user = response.user
            self.isAuthenticated = true
            
            // Store token
            UserDefaults.standard.set(response.accessToken, forKey: userDefaultsKey)
        } catch {
            self.error = "Login failed: \(error.localizedDescription)"
        }
        
        loading = false
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String) async {
        loading = true
        error = ""
        
        do {
            let response = try await authService.signup(email: email, password: password, firstName: firstName, lastName: lastName)
            self.token = response.accessToken
            self.user = response.user
            self.isAuthenticated = true
            
            // Store token
            UserDefaults.standard.set(response.accessToken, forKey: userDefaultsKey)
        } catch {
            self.error = "Signup failed: \(error.localizedDescription)"
        }
        
        loading = false
    }
    
    func logout() async {
        if let token = token {
            do {
                try await authService.logout(token: token)
            } catch {
                print("Logout error: \(error)")
            }
        }
        
        // Clear local state
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        self.token = nil
        self.user = nil
        self.isAuthenticated = false
    }
}

// MARK: - Story View Model

@MainActor
class StoryViewModel: ObservableObject {
    @Published var description = ""
    @Published var story = ""
    @Published var title = ""
    @Published var imageUrls: [String] = []
    @Published var loading = false
    @Published var error = ""
    @Published var funFacts: [FunFact] = []
    @Published var currentFactIndex = 0
    @Published var showFunFactsModal = false
    @Published var selectedFormats: Set<String> = ["Comic Book", "Text Story"]
    @Published var pendingStoryId: Int?
    @Published var isCompletingStory = false  // Flag to prevent interference during completion
    
    private let storyService = StoryService.shared
    private var navigationManager: NavigationManager?
    private var pollingTask: Task<Void, Never>?
    private var factRotationTask: Task<Void, Never>?
    
    func setNavigationManager(_ navigationManager: NavigationManager) {
        self.navigationManager = navigationManager
    }
    
    func toggleFormat(_ format: String) {
        if selectedFormats.contains(format) {
            selectedFormats.remove(format)
        } else {
            selectedFormats.insert(format)
        }
    }
    
    func generateStory(authViewModel: AuthViewModel) async {
        loading = true
        error = ""
        funFacts = []
        currentFactIndex = 0
        showFunFactsModal = true
        
        // Start fun facts fetch
        Task {
            do {
                let facts = try await storyService.fetchFunFacts(prompt: description, token: authViewModel.token)
                self.funFacts = facts
                self.startFactRotation()
            } catch {
                print("Failed to fetch fun facts: \(error)")
            }
        }
        
        do {
            // Submit story generation request
            let formats = Array(selectedFormats)
            let response = try await storyService.generateStory(prompt: description, formats: formats, token: authViewModel.token)
            
            if response.storyId > 0 && response.status == "IN_PROGRESS" {
                pendingStoryId = response.storyId
                startPolling(storyId: response.storyId, authToken: authViewModel.token)
            } else {
                throw StoryService.StoryError.invalidResponse
            }
        } catch {
            self.error = "Error submitting story request: \(error.localizedDescription)"
            self.loading = false
            self.showFunFactsModal = false
            self.title = ""
            self.story = ""
            self.imageUrls = []
            self.pendingStoryId = nil
        }
    }
    
    private func startPolling(storyId: Int, authToken: String?) {
        pollingTask?.cancel()
        
        pollingTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
                
                // Only check status if not already completing to prevent race conditions
                await MainActor.run {
                    if !self.isCompletingStory {
                        Task {
                            await checkStoryStatus(storyId: storyId, authToken: authToken)
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    private func checkStoryStatus(storyId: Int, authToken: String?) async {
        do {
            let statusResponse = try await storyService.checkStoryStatus(storyId: storyId, token: authToken)
            
            if statusResponse.status == "NEW" {
                // Set completion flag to prevent interference
                self.isCompletingStory = true
                
                // Story is complete! Update all state atomically
                self.title = statusResponse.title ?? ""
                self.story = statusResponse.story ?? ""
                self.imageUrls = statusResponse.imageUrls ?? []
                self.showFunFactsModal = false
                self.loading = false
                self.pendingStoryId = nil
                
                // Stop polling before navigation
                pollingTask?.cancel()
                pollingTask = nil
                factRotationTask?.cancel()
                factRotationTask = nil
                
                // Small delay to ensure state is fully updated before navigation
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                
                // Navigate to home to show results (this ensures currentPage is .home)
                navigationManager?.goToPage(.home)
                
                // Clear completion flag after navigation completes
                self.isCompletingStory = false
            }
        } catch {
            await MainActor.run {
                print("Error checking story status: \(error)")
                self.error = "Failed to check story status. Please refresh and try again."
                self.loading = false
                self.showFunFactsModal = false
                self.isCompletingStory = false
                
                // Stop polling on error
                pollingTask?.cancel()
                pollingTask = nil
                factRotationTask?.cancel()
                factRotationTask = nil
            }
        }
    }
    
    private func startFactRotation() {
        factRotationTask?.cancel()
        
        guard funFacts.count > 0 else { return }
        
        factRotationTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 5_500_000_000) // 5.5 seconds
                withAnimation {
                    self.currentFactIndex = (self.currentFactIndex + 1) % self.funFacts.count
                }
            }
        }
    }
    
    func reset() {
        // Don't reset if story completion is in progress
        guard !isCompletingStory else {
            print("Story completion in progress - preventing reset")
            return
        }
        
        story = ""
        title = ""
        imageUrls = []
        error = ""
        pollingTask?.cancel()
        pollingTask = nil
        factRotationTask?.cancel()
        factRotationTask = nil
    }
    
    deinit {
        pollingTask?.cancel()
        factRotationTask?.cancel()
    }
}

// MARK: - Public Stories Service

class PublicStoriesService: ObservableObject {
    static let shared = PublicStoriesService()
    
    private let baseURL = "https://www.mystorybuddy.com/api"
    private let session = URLSession.shared
    
    private init() {}
    
    enum PublicStoriesError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(String)
    }
    
    func fetchPublicStories(page: Int = 1, limit: Int = 20, category: String? = nil, featured: Bool? = nil) async throws -> PublicStoriesResponse {
        var urlComponents = URLComponents(string: "\(baseURL)/public-stories")!
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "page", value: String(page)))
        queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        
        if let featured = featured {
            queryItems.append(URLQueryItem(name: "featured", value: String(featured)))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw PublicStoriesError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("PublicStoriesService: Invalid response type")
            throw PublicStoriesError.invalidResponse
        }
        
        print("PublicStoriesService: Response status code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode response"
            print("PublicStoriesService: HTTP error \(httpResponse.statusCode): \(responseString)")
            throw PublicStoriesError.invalidResponse
        }
        
        do {
            // Print raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("PublicStoriesService: Raw response: \(responseString.prefix(500))")
            }
            
            let publicStoriesResponse = try JSONDecoder().decode(PublicStoriesResponse.self, from: data)
            print("PublicStoriesService: Successfully decoded \(publicStoriesResponse.stories.count) stories")
            return publicStoriesResponse
        } catch {
            print("PublicStoriesService: Decoding error: \(error)")
            if let decodingError = error as? DecodingError {
                print("PublicStoriesService: Detailed decoding error: \(decodingError)")
            }
            throw PublicStoriesError.decodingError
        }
    }
}

struct PublicStoriesResponse: Codable {
    let stories: [PublicStory]
    let totalCount: Int
    let categories: [String]
    
    enum CodingKeys: String, CodingKey {
        case stories
        case totalCount = "total_count"
        case categories
    }
}

// MARK: - Public Stories View Model

@MainActor
class PublicStoriesViewModel: ObservableObject {
    @Published var stories: [PublicStory] = []
    @Published var loading = false
    @Published var error = ""
    @Published var categories: [String] = []
    @Published var selectedCategory: String? = nil
    @Published var showOnlyFeatured = false
    @Published var currentPage = 1
    
    private let publicStoriesService = PublicStoriesService.shared
    
    func fetchPublicStories() async {
        print("PublicStoriesViewModel: Starting to fetch stories...")
        loading = true
        error = ""
        
        do {
            print("PublicStoriesViewModel: Calling service with page=\(currentPage), category=\(selectedCategory ?? "nil"), featured=\(showOnlyFeatured ? "true" : "nil")")
            let response = try await publicStoriesService.fetchPublicStories(
                page: currentPage,
                category: selectedCategory,
                featured: showOnlyFeatured ? true : nil
            )
            print("PublicStoriesViewModel: Received \(response.stories.count) stories and \(response.categories.count) categories")
            self.stories = response.stories
            self.categories = response.categories
        } catch {
            print("PublicStoriesViewModel: Error fetching stories: \(error)")
            self.error = "Failed to fetch public stories: \(error.localizedDescription)"
        }
        
        loading = false
        print("PublicStoriesViewModel: Finished fetching, loading=\(loading), storiesCount=\(stories.count)")
    }
    
    func selectCategory(_ category: String?) {
        selectedCategory = category
        currentPage = 1
        Task {
            await fetchPublicStories()
        }
    }
    
    func toggleFeatured() {
        showOnlyFeatured.toggle()
        currentPage = 1
        Task {
            await fetchPublicStories()
        }
    }
}

// MARK: - My Stories View Model

@MainActor
class MyStoriesViewModel: ObservableObject {
    @Published var stories: [MyStory] = []
    @Published var loading = false
    @Published var error = ""
    @Published var newStoriesCount = 0
    
    private let myStoriesService = MyStoriesService.shared
    
    func fetchMyStories(token: String) async {
        loading = true
        error = ""
        
        do {
            let response = try await myStoriesService.fetchMyStories(token: token)
            self.stories = response.stories
            self.newStoriesCount = response.newStoriesCount
        } catch {
            self.error = "Failed to fetch stories: \(error.localizedDescription)"
        }
        
        loading = false
    }
    
    func markStoryAsViewed(storyId: Int, token: String) async {
        do {
            try await myStoriesService.markStoryAsViewed(storyId: storyId, token: token)
            
            // Update local state
            if let index = stories.firstIndex(where: { $0.id == storyId }) {
                stories[index] = MyStory(
                    id: stories[index].id,
                    title: stories[index].title,
                    prompt: stories[index].prompt,
                    storyContent: stories[index].storyContent,
                    imageUrls: stories[index].imageUrls,
                    formats: stories[index].formats,
                    status: "VIEWED",
                    createdAt: stories[index].createdAt
                )
            }
            
            // Update new stories count
            newStoriesCount = max(0, newStoriesCount - 1)
        } catch {
            print("Failed to mark story as viewed: \(error)")
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        guard let date = formatter.date(from: dateString) else {
            return "Unknown date"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        return displayFormatter.string(from: date)
    }
}

// MARK: - Personalization View Model

@MainActor
class PersonalizationViewModel: ObservableObject {
    @Published var avatar: Avatar?
    @Published var loading = false
    @Published var error = ""
    @Published var success = ""
    @Published var avatarName = ""
    @Published var traitsDescription = ""
    @Published var selectedImage: UIImage?
    @Published var isEditing = false
    @Published var isCreatingNew = false
    @Published var showAvatarModal = false
    
    private let personalizationService = PersonalizationService.shared
    
    func fetchAvatar(token: String) async {
        do {
            let fetchedAvatar = try await personalizationService.fetchAvatar(token: token)
            self.avatar = fetchedAvatar
            
            if let fetchedAvatar = fetchedAvatar {
                self.avatarName = fetchedAvatar.avatarName
                self.traitsDescription = fetchedAvatar.traitsDescription
            }
        } catch {
            self.error = "Failed to load avatar data: \(error.localizedDescription)"
        }
    }
    
    func createAvatar(token: String) async {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            error = "Please select an image"
            return
        }
        
        loading = true
        error = ""
        success = ""
        
        do {
            try await personalizationService.createAvatar(
                avatarName: avatarName.trimmingCharacters(in: .whitespacesAndNewlines),
                traitsDescription: traitsDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                imageData: imageData,
                token: token
            )
            
            success = "Avatar generation started! Check back in a few minutes. You can continue using the app in the meantime."
            self.selectedImage = nil
            resetForm()
            await fetchAvatar(token: token)
        } catch {
            self.error = "Failed to create avatar: \(error.localizedDescription)"
        }
        
        loading = false
    }
    
    func updateAvatar(token: String) async {
        loading = true
        error = ""
        success = ""
        
        do {
            let updatedAvatar = try await personalizationService.updateAvatar(
                avatarName: avatarName.trimmingCharacters(in: .whitespacesAndNewlines),
                traitsDescription: traitsDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                token: token
            )
            
            self.avatar = updatedAvatar
            success = "Avatar updated successfully!"
            isEditing = false
        } catch {
            self.error = "Failed to update avatar: \(error.localizedDescription)"
        }
        
        loading = false
    }
    
    func startEditing() {
        isEditing = true
        isCreatingNew = false
        error = ""
        success = ""
    }
    
    func startCreatingNew() {
        isEditing = true
        isCreatingNew = true
        resetForm()
    }
    
    func cancelEditing() {
        isEditing = false
        isCreatingNew = false
        error = ""
        success = ""
        selectedImage = nil
        
        if let avatar = avatar {
            avatarName = avatar.avatarName
            traitsDescription = avatar.traitsDescription
        }
    }
    
    func resetForm() {
        avatarName = ""
        traitsDescription = ""
        selectedImage = nil
        error = ""
        success = ""
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        guard let date = formatter.date(from: dateString) else {
            return "Unknown date"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .long
        return displayFormatter.string(from: date)
    }
}

// MARK: - Views

struct ContentView: View {
    @StateObject private var viewModel = StoryViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var myStoriesViewModel = MyStoriesViewModel()
    @StateObject private var publicStoriesViewModel = PublicStoriesViewModel()
    @StateObject private var personalizationViewModel = PersonalizationViewModel()
    @State private var showTextModal = false
    @State private var showComicModal = false
    @State private var currentComicPage = 0
    @State private var showHamburgerMenu = false
    @State private var showLoginModal = false
    @State private var showSignupModal = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { showHamburgerMenu = true }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text(navigationManager.currentPage.title)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    Button(action: handleBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                    .opacity(shouldShowBackButton ? 1 : 0.3)
                    .disabled(!shouldShowBackButton)
                }
                .padding()
                .background(AppTheme.primaryBackground)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AppTheme.separator),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        switch navigationManager.currentPage {
                        case .home:
                            HomePageView(
                                viewModel: viewModel, 
                                authViewModel: authViewModel, 
                                navigationManager: navigationManager,
                                onShowTextModal: {
                                    showTextModal = true
                                },
                                onShowComicModal: {
                                    showComicModal = true
                                    currentComicPage = 0
                                },
                                onShowComingSoon: { format in
                                    showComingSoon(format: format)
                                }
                            )
                        case .publicStories:
                            PublicStoriesPageView(viewModel: publicStoriesViewModel, navigationManager: navigationManager)
                        case .myStories:
                            MyStoriesPageView(viewModel: myStoriesViewModel, authViewModel: authViewModel, navigationManager: navigationManager)
                        case .storyViewer:
                            if let story = navigationManager.selectedStory {
                                StoryViewerPageView(story: story, navigationManager: navigationManager, onShowTextModal: {
                                    viewModel.story = story.storyContent
                                    viewModel.title = story.title
                                    showTextModal = true
                                }, onShowComicModal: {
                                    viewModel.story = story.storyContent
                                    viewModel.title = story.title
                                    viewModel.imageUrls = story.imageUrls ?? []
                                    showComicModal = true
                                    currentComicPage = 0
                                })
                            }
                        case .personalization:
                            PersonalizationPageView(viewModel: personalizationViewModel, authViewModel: authViewModel, navigationManager: navigationManager)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(AppTheme.primaryBackground)
        }
        .onAppear {
            viewModel.setNavigationManager(navigationManager)
        }
        .sheet(isPresented: $showHamburgerMenu) {
            HamburgerMenuView(
                authViewModel: authViewModel,
                navigationManager: navigationManager,
                viewModel: viewModel,
                showLoginModal: $showLoginModal,
                showSignupModal: $showSignupModal,
                showTextModal: $showTextModal,
                showComicModal: $showComicModal,
                isPresented: $showHamburgerMenu
            )
        }
        
        // Add authentication and modal sheets
        .sheet(isPresented: $showLoginModal) {
            LoginModalView(
                authViewModel: authViewModel,
                showSignupModal: $showSignupModal,
                isPresented: $showLoginModal
            )
        }
        .sheet(isPresented: $showSignupModal) {
            SignupModalView(
                authViewModel: authViewModel,
                showLoginModal: $showLoginModal,
                isPresented: $showSignupModal
            )
        }
        .sheet(isPresented: $viewModel.showFunFactsModal) {
            LoadingView(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $showTextModal) {
            TextStoryView(story: viewModel.story, title: viewModel.title, isPresented: $showTextModal)
        }
        .fullScreenCover(isPresented: $showComicModal) {
            ComicStoryView(
                imageUrls: viewModel.imageUrls,
                title: viewModel.title,
                isPresented: $showComicModal
            )
        }
        .onAppear {
            // Fetch notification counts when authenticated
            if authViewModel.isAuthenticated, let token = authViewModel.token {
                Task {
                    await fetchNotificationCounts(token: token)
                }
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated, let token = authViewModel.token {
                Task {
                    await fetchNotificationCounts(token: token)
                }
            }
        }
    }
    
    // MARK: - Helper Properties and Methods
    
    private var shouldShowBackButton: Bool {
        return navigationManager.currentPage != .home || (!viewModel.story.isEmpty || viewModel.isCompletingStory)
    }
    
    private func handleBack() {
        // If we're on the Home page and there's a story, user wants to go back to input form
        // But don't reset if story completion is in progress
        if navigationManager.currentPage == .home && !viewModel.story.isEmpty && !viewModel.isCompletingStory {
            viewModel.reset()
        } else {
            navigationManager.goBack()
        }
    }
    
    private func showComingSoon(format: String) {
        // In a real app, this would show an alert
        print("\(format) feature is coming soon!")
    }
    
    private func fetchNotificationCounts(token: String) async {
        // Fetch new stories count
        do {
            let response = try await MyStoriesService.shared.fetchMyStories(token: token)
            navigationManager.updateNewStoriesCount(response.newStoriesCount)
        } catch {
            print("Failed to fetch new stories count: \(error)")
        }
        
        // Fetch completed avatars count
        do {
            let count = try await PersonalizationService.shared.fetchCompletedAvatarsCount(token: token)
            navigationManager.updateCompletedAvatarsCount(count)
        } catch {
            print("Failed to fetch completed avatars count: \(error)")
        }
    }
}

// MARK: - Page Views

struct HomePageView: View {
    @ObservedObject var viewModel: StoryViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var navigationManager: NavigationManager
    let onShowTextModal: () -> Void
    let onShowComicModal: () -> Void
    let onShowComingSoon: (String) -> Void
    
    var body: some View {
        // Show story results if story exists OR if completion is in progress (prevents flickering)
        if viewModel.story.isEmpty && !viewModel.isCompletingStory {
            VStack(spacing: 24) {
                // Question Section
                Text("What do you want to learn today?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                
                // Input Section
                VStack(alignment: .trailing, spacing: 8) {
                    ZStack(alignment: .bottomTrailing) {
                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 120)
                            .padding(20)
                            .background(AppTheme.secondaryBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppTheme.border, lineWidth: 2)
                            )
                            .disabled(viewModel.loading)
                        
                        if viewModel.description.isEmpty {
                            Text("Enter your question or topic")
                                .foregroundColor(AppTheme.tertiaryText)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 24)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .allowsHitTesting(false)
                        }
                        
                    }
                }
                
                // Generate Button
                Button(action: {
                    Task {
                        await viewModel.generateStory(authViewModel: authViewModel)
                    }
                }) {
                    Text(viewModel.loading ? "Creating your story..." : "Generate Story")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AppTheme.accentColor.opacity(0.2))
                        .cornerRadius(12)
                }
                .disabled(viewModel.loading || viewModel.selectedFormats.isEmpty)
                .opacity(viewModel.loading || viewModel.selectedFormats.isEmpty ? 0.6 : 1)
                
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.destructiveColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.destructiveColor.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // Story Formats Section
                VStack(spacing: 16) {
                    Text("Choose Your Preferred Story Formats")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Select the formats you'd like to see for your story")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(StoryFormat.allCases, id: \.self) { format in
                            FormatCard(
                                title: format.rawValue,
                                description: getFormatDescription(format),
                                icon: getFormatIcon(format),
                                isSelected: viewModel.selectedFormats.contains(format.rawValue),
                                action: {
                                    viewModel.toggleFormat(format.rawValue)
                                }
                            )
                        }
                    }
                }
                .padding(.top, 20)
            }
        } else {
            // Story Results
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                Text("Choose how you'd like to experience your story:")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.secondaryText)
                
                VStack(spacing: 12) {
                    if viewModel.selectedFormats.contains("Text Story") {
                        ResultFormatCard(
                            title: "Text Story",
                            icon: "doc.text",
                            count: nil,
                            isAvailable: true,
                            action: onShowTextModal
                        )
                    }
                    
                    if viewModel.selectedFormats.contains("Comic Book") {
                        ResultFormatCard(
                            title: "Comic Book",
                            icon: "book",
                            count: viewModel.imageUrls.count,
                            isAvailable: !viewModel.imageUrls.isEmpty,
                            action: onShowComicModal
                        )
                    }
                    
                    if viewModel.selectedFormats.contains("Animated Video") {
                        ResultFormatCard(
                            title: "Animated Video",
                            icon: "play.rectangle",
                            count: nil,
                            isAvailable: false,
                            action: {
                                onShowComingSoon("Animated Video")
                            }
                        )
                    }
                    
                    if viewModel.selectedFormats.contains("Audio Story") {
                        ResultFormatCard(
                            title: "Audio Story",
                            icon: "headphones",
                            count: nil,
                            isAvailable: false,
                            action: {
                                onShowComingSoon("Audio Story")
                            }
                        )
                    }
                }
                
                if viewModel.selectedFormats.contains("Comic Book") && viewModel.imageUrls.isEmpty {
                    Text("Comic illustrations are still being created...")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.secondaryText)
                        .padding()
                }
            }
        }
    }
}

// Helper functions for FormatCard
func getFormatDescription(_ format: StoryFormat) -> String {
    switch format {
    case .textStory:
        return "Read your story"
    case .comicBook:
        return "Comic illustrations"
    case .animatedVideo:
        return "Coming soon"
    case .audioStory:
        return "Coming soon"
    }
}

func getFormatIcon(_ format: StoryFormat) -> String {
    switch format {
    case .textStory:
        return "doc.text"
    case .comicBook:
        return "book"
    case .animatedVideo:
        return "play.rectangle"
    case .audioStory:
        return "headphones"
    }
}

struct PublicStoriesPageView: View {
    @ObservedObject var viewModel: PublicStoriesViewModel
    @ObservedObject var navigationManager: NavigationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Public Stories")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppTheme.primaryText)
                        
                        Text("Discover amazing stories shared by everyone")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Filter Section
                VStack(spacing: 12) {
                    // Featured toggle
                    HStack {
                        Button(action: { 
                            viewModel.toggleFeatured()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: viewModel.showOnlyFeatured ? "star.fill" : "star")
                                    .foregroundColor(viewModel.showOnlyFeatured ? .yellow : AppTheme.secondaryText)
                                Text("Featured Stories")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(viewModel.showOnlyFeatured ? AppTheme.primaryText : AppTheme.secondaryText)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.showOnlyFeatured ? AppTheme.accentColor.opacity(0.1) : AppTheme.buttonBackground)
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                    }
                    
                    // Category filters
                    if !viewModel.categories.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Button("All") {
                                    viewModel.selectCategory(nil)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedCategory == nil ? AppTheme.accentColor : AppTheme.buttonBackground)
                                .foregroundColor(viewModel.selectedCategory == nil ? .white : AppTheme.primaryText)
                                .cornerRadius(20)
                                
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button(category) {
                                        viewModel.selectCategory(category)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? AppTheme.accentColor : AppTheme.buttonBackground)
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : AppTheme.primaryText)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 8)
                
                // Stories Grid
                if viewModel.loading {
                    ProgressView("Loading public stories...")
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if !viewModel.error.isEmpty {
                    VStack(spacing: 12) {
                        Text("Error")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppTheme.primaryText)
                        
                        Text(viewModel.error)
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.fetchPublicStories()
                            }
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppTheme.accentColor)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else if viewModel.stories.isEmpty {
                    VStack(spacing: 12) {
                        Text("No Stories Found")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppTheme.primaryText)
                        
                        Text("No public stories match your current filters.")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)
                    ], spacing: 16) {
                        ForEach(viewModel.stories) { story in
                            PublicStoryCardView(story: story) {
                                // Convert PublicStory to MyStory for compatibility
                                let myStory = MyStory(
                                    id: story.id,
                                    title: story.title,
                                    prompt: story.prompt,
                                    storyContent: story.storyContent,
                                    imageUrls: story.imageUrls,
                                    formats: story.formats,
                                    status: story.status,
                                    createdAt: story.createdAt
                                )
                                navigationManager.goToStoryViewer(story: myStory)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
        }
        .refreshable {
            await viewModel.fetchPublicStories()
        }
        .task {
            if viewModel.stories.isEmpty {
                await viewModel.fetchPublicStories()
            }
        }
    }
}

struct PublicStoryCardView: View {
    let story: PublicStory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Image
                if let imageUrls = story.imageUrls, !imageUrls.isEmpty {
                    AsyncImage(url: URL(string: imageUrls[0])) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(AppTheme.inputBackground)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.8)
                            )
                    }
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(AppTheme.inputBackground)
                        .frame(height: 120)
                        .cornerRadius(8)
                        .overlay(
                            Text("📚")
                                .font(.system(size: 32))
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    // Category and featured badge
                    HStack {
                        Text(story.category)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.accentColor.opacity(0.1))
                            .cornerRadius(12)
                        
                        if story.featured == 1 {
                            Text("⭐")
                                .font(.system(size: 12))
                        }
                        
                        Spacer()
                    }
                    
                    // Title
                    Text(story.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Age group
                    Text("Ages \(story.ageGroup)")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.secondaryText)
                }
                .padding(.horizontal, 4)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MyStoriesPageView: View {
    @ObservedObject var viewModel: MyStoriesViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.loading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    Text("Loading your stories...")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.secondaryText)
                        .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.error.isEmpty {
                VStack {
                    Text("Error: \(viewModel.error)")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.destructiveColor)
                        .multilineTextAlignment(.center)
                    
                    Button("Try Again") {
                        if let token = authViewModel.token {
                            Task {
                                await viewModel.fetchMyStories(token: token)
                            }
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(AppTheme.accentColor)
                    .cornerRadius(8)
                    .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.stories.isEmpty {
                VStack(spacing: 16) {
                    Text("📚")
                        .font(.system(size: 60))
                    
                    Text("No stories yet")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("Create your first story to see it here!")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button("Create Story") {
                        navigationManager.goToPage(.home)
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppTheme.accentColor)
                    .cornerRadius(8)
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.stories) { story in
                        StoryCardView(
                            story: story,
                            onTap: {
                                handleStoryTap(story)
                            }
                        )
                    }
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            if let token = authViewModel.token {
                Task {
                    await viewModel.fetchMyStories(token: token)
                }
            }
        }
    }
    
    private func handleStoryTap(_ story: MyStory) {
        Task {
            // Mark story as viewed if it's NEW
            if story.status == "NEW", let token = authViewModel.token {
                await viewModel.markStoryAsViewed(storyId: story.id, token: token)
                navigationManager.updateNewStoriesCount(viewModel.newStoriesCount)
            }
            
            // Only allow viewing completed stories
            if story.status == "IN_PROGRESS" {
                // Could show an alert here
                print("This story is still being generated. Please wait a few moments and refresh.")
                return
            }
            
            navigationManager.goToStoryViewer(story: story)
        }
    }
}

struct StoryViewerPageView: View {
    let story: MyStory
    @ObservedObject var navigationManager: NavigationManager
    let onShowTextModal: () -> Void
    let onShowComicModal: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Story Meta Information
            VStack(spacing: 16) {
                Text(story.title)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                // Created date hidden for cleaner UI
                // Text("Created \(formatDate(story.createdAt))")
                //     .font(.system(size: 14))
                //     .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original Prompt")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(story.prompt)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.secondaryText)
                        .padding()
                        .background(AppTheme.buttonBackground)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 24)
            
            // Format Selection
            VStack(spacing: 16) {
                Text("Choose Your Experience")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Select how you'd like to experience this story:")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.secondaryText)
                
                VStack(spacing: 12) {
                    if let formats = story.formats, formats.contains("Text Story") {
                        ResultFormatCard(
                            title: "Text Story",
                            icon: "doc.text",
                            count: nil,
                            isAvailable: true,
                            action: onShowTextModal
                        )
                    }
                    
                    if let formats = story.formats, formats.contains("Comic Book") {
                        ResultFormatCard(
                            title: "Comic Book",
                            icon: "book",
                            count: story.imageUrls?.count,
                            isAvailable: story.imageUrls?.isEmpty == false,
                            action: onShowComicModal
                        )
                    }
                    
                    if let formats = story.formats, formats.contains("Animated Video") {
                        ResultFormatCard(
                            title: "Animated Video",
                            icon: "play.rectangle",
                            count: nil,
                            isAvailable: false,
                            action: {
                                print("Animated Video feature is coming soon!")
                            }
                        )
                    }
                    
                    if let formats = story.formats, formats.contains("Audio Story") {
                        ResultFormatCard(
                            title: "Audio Story",
                            icon: "headphones",
                            count: nil,
                            isAvailable: false,
                            action: {
                                print("Audio Story feature is coming soon!")
                            }
                        )
                    }
                }
                
                if let formats = story.formats, formats.contains("Comic Book") && (story.imageUrls?.isEmpty != false) {
                    VStack(spacing: 8) {
                        Text("⏳")
                            .font(.system(size: 40))
                        
                        Text("Comic illustrations are being created...")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Your comic book version will be available shortly. Try the text version while you wait!")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(AppTheme.warningColor.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        guard let date = formatter.date(from: dateString) else {
            return "Unknown date"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .long
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}

import PhotosUI

struct PersonalizationPageView: View {
    @ObservedObject var viewModel: PersonalizationViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var navigationManager: NavigationManager
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Page Header
            VStack(spacing: 8) {
                Text("Personalization")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Create a comic-style avatar for your stories")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)
            
            // Error/Success Messages
            if !viewModel.error.isEmpty {
                Text(viewModel.error)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.destructiveColor)
                    .padding()
                    .background(AppTheme.destructiveColor.opacity(0.1))
                    .cornerRadius(8)
            }
            
            if !viewModel.success.isEmpty {
                Text(viewModel.success)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.successColor)
                    .padding()
                    .background(AppTheme.successColor.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Avatar Display or Form
            if let avatar = viewModel.avatar, !viewModel.isEditing {
                // Display existing avatar
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: avatar.s3ImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture {
                        viewModel.showAvatarModal = true
                    }
                    
                    VStack(spacing: 8) {
                        Text(avatar.avatarName)
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text(avatar.traitsDescription)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        // Created date hidden for cleaner UI
                        // Text("Created: \(viewModel.formatDate(avatar.createdAt))")
                        //     .font(.system(size: 12))
                        //     .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 16) {
                        Button("Edit Details") {
                            viewModel.startEditing()
                        }
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.accentColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppTheme.accentColor.opacity(0.1))
                        .cornerRadius(8)
                        
                        Button("Create New Avatar") {
                            viewModel.startCreatingNew()
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppTheme.accentColor)
                        .cornerRadius(8)
                    }
                }
            } else {
                // Avatar creation/editing form
                VStack(spacing: 20) {
                    Text(viewModel.isCreatingNew ? "Create New Avatar" : viewModel.avatar != nil ? "Edit Avatar" : "Create Your Avatar")
                        .font(.system(size: 18, weight: .semibold))
                    
                    // Image Upload Section
                    if viewModel.avatar == nil || viewModel.selectedImage != nil || viewModel.isCreatingNew {
                        VStack(spacing: 12) {
                            if let selectedImage = viewModel.selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                Button(action: { showingImagePicker = true }) {
                                    VStack(spacing: 8) {
                                        Text("📸")
                                            .font(.system(size: 40))
                                        
                                        Text("Click to upload image")
                                            .font(.system(size: 16))
                                        
                                        Text("Max 10MB • JPG, PNG")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.tertiaryText)
                                    }
                                    .frame(width: 150, height: 150)
                                    .background(AppTheme.buttonBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppTheme.border, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    )
                                }
                            }
                        }
                    }
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Avatar Name")
                                .font(.system(size: 14, weight: .medium))
                            
                            TextField("Enter a name for your avatar", text: $viewModel.avatarName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Personality Traits")
                                .font(.system(size: 14, weight: .medium))
                            
                            TextEditor(text: $viewModel.traitsDescription)
                                .frame(height: 80)
                                .padding(8)
                                .background(AppTheme.buttonBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                            
                            if viewModel.traitsDescription.isEmpty {
                                Text("Describe 1-2 personality traits (e.g., funny and creative, brave and kind)")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.tertiaryText)
                                    .padding(.horizontal, 8)
                                    .padding(.top, -72)
                                    .allowsHitTesting(false)
                            }
                            
                            Text("These traits will influence how your avatar appears in stories")
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.tertiaryText)
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(viewModel.avatar != nil && viewModel.selectedImage == nil && !viewModel.isCreatingNew ? "Update Avatar" : "Create Avatar") {
                            Task {
                                if let token = authViewModel.token {
                                    if viewModel.selectedImage != nil || viewModel.isCreatingNew {
                                        await viewModel.createAvatar(token: token)
                                    } else {
                                        await viewModel.updateAvatar(token: token)
                                    }
                                }
                            }
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(viewModel.loading ? AppTheme.buttonBackground : AppTheme.accentColor)
                        .cornerRadius(8)
                        .disabled(viewModel.loading || viewModel.avatarName.isEmpty || viewModel.traitsDescription.isEmpty)
                        
                        if viewModel.avatar != nil {
                            Button("Cancel") {
                                viewModel.cancelEditing()
                            }
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppTheme.accentColor.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Info Section
            VStack(alignment: .leading, spacing: 8) {
                Text("About Personalized Avatars")
                    .font(.system(size: 16, weight: .semibold))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Upload a photo to create a comic-style avatar")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Your avatar can be featured in future stories")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Personality traits influence how your avatar appears")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Only one avatar per account (you can replace it anytime)")
                    }
                }
                .font(.system(size: 14))
                .foregroundColor(AppTheme.secondaryText)
            }
            .padding()
            .background(AppTheme.secondaryBackground)
            .cornerRadius(12)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .fullScreenCover(isPresented: $viewModel.showAvatarModal) {
            if let avatar = viewModel.avatar {
                AvatarFullScreenView(avatar: avatar, isPresented: $viewModel.showAvatarModal)
            }
        }
        .onAppear {
            if let token = authViewModel.token {
                Task {
                    await viewModel.fetchAvatar(token: token)
                }
            }
        }
    }
}

struct StoryCardView: View {
    let story: MyStory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(story.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        // Created date hidden for cleaner UI
                        // Text(formatDate(story.createdAt))
                        //     .font(.system(size: 12))
                        //     .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if story.status == "NEW" {
                        Text("NEW!")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppTheme.destructiveColor)
                            .cornerRadius(4)
                    } else if story.status == "IN_PROGRESS" {
                        HStack(spacing: 4) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.7)
                            Text("Generating...")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Prompt: \(story.prompt)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if story.status == "IN_PROGRESS" {
                        Text("Your magical story is being created... ✨")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.secondaryText)
                            .italic()
                    } else {
                        Text(String(story.storyContent.prefix(120)) + (story.storyContent.count > 120 ? "..." : ""))
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.secondaryText)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let formats = story.formats {
                    HStack {
                        ForEach(formats, id: \.self) { format in
                            HStack(spacing: 4) {
                                Text(formatIcon(format))
                                    .font(.system(size: 12))
                                Text(format)
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.tertiaryText)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppTheme.buttonBackground)
                            .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        if let imageUrls = story.imageUrls, !imageUrls.isEmpty {
                            HStack(spacing: 2) {
                                Text("🖼️")
                                    .font(.system(size: 10))
                                Text("\(imageUrls.count) images")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.tertiaryText)
                            }
                        }
                        
                        Text("Click to view")
                            .font(.system(size: 10))
                            .foregroundColor(AppTheme.accentColor)
                    }
                }
            }
            .padding()
            .background(AppTheme.primaryBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(story.status == "NEW" ? AppTheme.accentColor : AppTheme.separator, lineWidth: story.status == "NEW" ? 2 : 1)
            )
            .shadow(color: AppTheme.primaryText.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        guard let date = formatter.date(from: dateString) else {
            return "Unknown date"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        return displayFormatter.string(from: date)
    }
    
    private func formatIcon(_ format: String) -> String {
        switch format {
        case "Comic Book": return "📚"
        case "Text Story": return "📄"
        case "Animated Video": return "🎬"
        case "Audio Story": return "🎧"
        default: return "📖"
        }
    }
}

struct AvatarFullScreenView: View {
    let avatar: Avatar
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            AppTheme.overlayBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(AppTheme.overlayBackground)
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text(avatar.avatarName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(avatar.traitsDescription)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                AsyncImage(url: URL(string: avatar.s3ImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                
                Spacer()
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Updated Hamburger Menu

struct HamburgerMenuView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var viewModel: StoryViewModel
    @Binding var showLoginModal: Bool
    @Binding var showSignupModal: Bool
    @Binding var showTextModal: Bool
    @Binding var showComicModal: Bool
    @Binding var isPresented: Bool
    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false
    @State private var deleteError: String = ""
    @State private var showDeleteError = false
    @State private var showDeleteSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Menu")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title2)
                }
                .padding()
                
                // Authentication section
                if authViewModel.isAuthenticated, let user = authViewModel.user {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Welcome, \(user.firstName)!")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            Button("Sign Out") {
                                Task {
                                    await authViewModel.logout()
                                }
                                isPresented = false
                            }
                            .foregroundColor(AppTheme.destructiveColor)
                            
                            Spacer()
                            
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                HStack {
                                    if isDeleting {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                        Text("Deleting...")
                                    } else {
                                        Text("Delete Account")
                                    }
                                }
                            }
                            .foregroundColor(AppTheme.destructiveColor)
                            .font(.system(size: 14))
                            .disabled(isDeleting)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Button("Sign In") {
                            showLoginModal = true
                            isPresented = false
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppTheme.accentColor)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        Button("Create Account") {
                            showSignupModal = true
                            isPresented = false
                        }
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppTheme.accentColor.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    MenuItemView(
                        icon: "🏠",
                        title: "Home",
                        isActive: navigationManager.currentPage == .home,
                        action: {
                            // Close ALL modals to ensure we get back to main home page
                            showTextModal = false
                            showComicModal = false
                            showLoginModal = false
                            showSignupModal = false
                            viewModel.showFunFactsModal = false
                            
                            // Only reset if we're not already on home page and not in story completion process
                            // This preserves the story when user is on home page viewing results
                            if navigationManager.currentPage != .home && !viewModel.isCompletingStory {
                                viewModel.reset()
                            }
                            navigationManager.goToPage(.home)
                            isPresented = false
                        }
                    )
                    
                    MenuItemView(
                        icon: "🌟",
                        title: "Public Stories",
                        isActive: navigationManager.currentPage == .publicStories,
                        action: {
                            navigationManager.goToPage(.publicStories)
                            isPresented = false
                        }
                    )
                    
                    if authViewModel.isAuthenticated {
                        MenuItemView(
                            icon: "📖",
                            title: "My Stories",
                            isActive: navigationManager.currentPage == .myStories,
                            notificationCount: navigationManager.newStoriesCount,
                            action: {
                                navigationManager.goToPage(.myStories)
                                isPresented = false
                            }
                        )
                        
                        MenuItemView(
                            icon: "🎭",
                            title: "Personalization",
                            isActive: navigationManager.currentPage == .personalization,
                            notificationCount: navigationManager.completedAvatarsCount,
                            action: {
                                navigationManager.goToPage(.personalization)
                                // Clear completed avatars count when visiting personalization page
                                navigationManager.updateCompletedAvatarsCount(0)
                                isPresented = false
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .background(AppTheme.primaryBackground)
            .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {
                    showDeleteConfirmation = false
                }
                Button("Delete Account", role: .destructive) {
                    Task {
                        await deleteAccountConfirmed()
                    }
                }
            } message: {
                Text("Are you sure you want to permanently delete your account?\n\nThis will immediately and permanently remove:\n• All your generated stories\n• Your avatar and personalization settings\n• Your account profile and login information\n• All associated data\n\nThis action cannot be undone.")
            }
            .alert("Account Deleted", isPresented: $showDeleteSuccess) {
                Button("OK") {
                    // Close ALL modals FIRST, then logout
                    DispatchQueue.main.async {
                        // Close story view modals first
                        showTextModal = false
                        showComicModal = false
                        // Close auth modals
                        showLoginModal = false
                        showSignupModal = false
                        // Close hamburger menu
                        isPresented = false
                        // Close any viewModel modals
                        viewModel.showFunFactsModal = false
                        
                        // Clear story state to ensure clean home page
                        viewModel.story = ""
                        viewModel.title = ""
                        viewModel.imageUrls = []
                        
                        // Then logout after a brief delay to allow UI updates
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            Task {
                                await authViewModel.logout()
                            }
                        }
                    }
                }
            } message: {
                Text("Your account has been permanently deleted. All data has been removed and cannot be recovered.")
            }
            .alert("Deletion Failed", isPresented: $showDeleteError) {
                Button("OK") {
                    showDeleteError = false
                }
            } message: {
                Text(deleteError)
            }
        }
    }
    
    private func deleteAccountConfirmed() async {
        guard let token = authViewModel.token else {
            return
        }
        
        isDeleting = true
        
        do {
            try await AuthService.shared.deleteAccount(token: token)
            
            // Account deleted successfully - show success message
            DispatchQueue.main.async {
                self.isDeleting = false
                self.showDeleteSuccess = true
                self.showDeleteConfirmation = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isDeleting = false
                self.deleteError = "Failed to delete account: \(error.localizedDescription). Please try again or contact support."
                self.showDeleteError = true
                self.showDeleteConfirmation = false
            }
        }
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    let isActive: Bool
    let notificationCount: Int
    let action: () -> Void
    
    init(icon: String, title: String, isActive: Bool, notificationCount: Int = 0, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isActive = isActive
        self.notificationCount = notificationCount
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(isActive ? AppTheme.accentColor : AppTheme.primaryText)
                
                Spacer()
                
                if notificationCount > 0 {
                    Text("\(notificationCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppTheme.destructiveColor)
                        .clipShape(Circle())
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Authentication Views

struct LoginModalView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var showSignupModal: Bool
    @Binding var isPresented: Bool
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Sign In")
                    .font(.title)
                    .bold()
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                if !authViewModel.error.isEmpty {
                    Text(authViewModel.error)
                        .foregroundColor(AppTheme.destructiveColor)
                        .font(.caption)
                }
                
                Button("Sign In") {
                    Task {
                        await authViewModel.login(email: email, password: password)
                        if authViewModel.isAuthenticated {
                            isPresented = false
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.accentColor)
                .cornerRadius(10)
                .disabled(authViewModel.loading || email.isEmpty || password.isEmpty)
                
                
                HStack {
                    Text("Don't have an account?")
                    Button("Sign Up") {
                        isPresented = false
                        showSignupModal = true
                    }
                    .foregroundColor(AppTheme.accentColor)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct SignupModalView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var showLoginModal: Bool
    @Binding var isPresented: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var validationError = ""
    
    // Password validation computed properties
    private var passwordChecks: (length: Bool, lowercase: Bool, uppercase: Bool, number: Bool) {
        let length = password.count >= 8
        let lowercase = password.contains { $0.isLowercase }
        let uppercase = password.contains { $0.isUppercase }
        let number = password.contains { $0.isNumber }
        return (length, lowercase, uppercase, number)
    }
    
    private var passwordStrength: Int {
        let checks = passwordChecks
        return [checks.length, checks.lowercase, checks.uppercase, checks.number].compactMap { $0 ? 1 : nil }.count
    }
    
    private var passwordsMatch: Bool {
        return password == confirmPassword && !confirmPassword.isEmpty
    }
    
    private var isFormValid: Bool {
        return !firstName.isEmpty && 
               !lastName.isEmpty && 
               !email.isEmpty && 
               passwordChecks.length && 
               passwordChecks.lowercase && 
               passwordChecks.uppercase && 
               passwordChecks.number && 
               passwordsMatch
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Create Account")
                    .font(.title)
                    .bold()
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Password Field with Toggle
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(AppTheme.tertiaryText)
                            }
                            .padding(.trailing, 8)
                        }
                        
                        // Password Requirements
                        if !password.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                // Password Strength Bar
                                HStack {
                                    Text("Password Strength: ")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.tertiaryText)
                                    
                                    Text(passwordStrength < 2 ? "Weak" : passwordStrength < 4 ? "Good" : "Strong")
                                        .font(.caption)
                                        .foregroundColor(passwordStrength < 2 ? .red : passwordStrength < 4 ? .orange : .green)
                                        .fontWeight(.semibold)
                                }
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: geometry.size.width, height: 4)
                                            .opacity(0.3)
                                            .foregroundColor(AppTheme.tertiaryText)
                                        
                                        Rectangle()
                                            .frame(width: min(CGFloat(passwordStrength) / 4.0 * geometry.size.width, geometry.size.width), height: 4)
                                            .foregroundColor(passwordStrength < 2 ? .red : passwordStrength < 4 ? .orange : .green)
                                            .animation(.linear(duration: 0.2), value: passwordStrength)
                                    }
                                }
                                .frame(height: 4)
                                
                                // Password Checklist
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack {
                                                Image(systemName: passwordChecks.length ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(passwordChecks.length ? .green : .gray)
                                                    .font(.caption)
                                                Text("At least 8 characters")
                                                    .font(.caption)
                                                    .foregroundColor(passwordChecks.length ? .green : .gray)
                                            }
                                            
                                            HStack {
                                                Image(systemName: passwordChecks.lowercase ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(passwordChecks.lowercase ? .green : .gray)
                                                    .font(.caption)
                                                Text("One lowercase letter")
                                                    .font(.caption)
                                                    .foregroundColor(passwordChecks.lowercase ? .green : .gray)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack {
                                                Image(systemName: passwordChecks.uppercase ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(passwordChecks.uppercase ? .green : .gray)
                                                    .font(.caption)
                                                Text("One uppercase letter")
                                                    .font(.caption)
                                                    .foregroundColor(passwordChecks.uppercase ? .green : .gray)
                                            }
                                            
                                            HStack {
                                                Image(systemName: passwordChecks.number ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(passwordChecks.number ? .green : .gray)
                                                    .font(.caption)
                                                Text("One number")
                                                    .font(.caption)
                                                    .foregroundColor(passwordChecks.number ? .green : .gray)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(12)
                            .background(AppTheme.buttonBackground)
                            .cornerRadius(8)
                        }
                    }
                    
                    // Confirm Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            if showConfirmPassword {
                                TextField("Confirm Password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            Button(action: { showConfirmPassword.toggle() }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(AppTheme.tertiaryText)
                            }
                            .padding(.trailing, 8)
                        }
                        
                        // Password Match Indicator
                        if !confirmPassword.isEmpty {
                            HStack {
                                Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(passwordsMatch ? .green : .red)
                                    .font(.caption)
                                Text(passwordsMatch ? "Passwords match" : "Passwords do not match")
                                    .font(.caption)
                                    .foregroundColor(passwordsMatch ? .green : .red)
                            }
                        }
                    }
                }
                
                // Show validation errors or auth errors
                if !validationError.isEmpty {
                    Text(validationError)
                        .foregroundColor(AppTheme.destructiveColor)
                        .font(.caption)
                }
                
                if !authViewModel.error.isEmpty {
                    Text(authViewModel.error)
                        .foregroundColor(AppTheme.destructiveColor)
                        .font(.caption)
                }
                
                Button("Create Account") {
                    // Clear previous validation errors
                    validationError = ""
                    
                    // Validate form
                    if !isFormValid {
                        if password != confirmPassword {
                            validationError = "Passwords do not match"
                        } else if !passwordChecks.length {
                            validationError = "Password must be at least 8 characters"
                        } else if !passwordChecks.lowercase {
                            validationError = "Password must contain a lowercase letter"
                        } else if !passwordChecks.uppercase {
                            validationError = "Password must contain an uppercase letter"
                        } else if !passwordChecks.number {
                            validationError = "Password must contain a number"
                        } else {
                            validationError = "Please fill in all fields"
                        }
                        return
                    }
                    
                    Task {
                        await authViewModel.signup(email: email, password: password, firstName: firstName, lastName: lastName)
                        if authViewModel.isAuthenticated {
                            isPresented = false
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid && !authViewModel.loading ? AppTheme.accentColor : AppTheme.buttonBackground)
                .cornerRadius(10)
                .disabled(!isFormValid || authViewModel.loading)
                
                
                HStack {
                    Text("Already have an account?")
                    Button("Sign In") {
                        isPresented = false
                        showLoginModal = true
                    }
                    .foregroundColor(AppTheme.accentColor)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}



// MARK: - Missing Views

struct LoadingView: View {
    @ObservedObject var viewModel: StoryViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Generating your story...")
                .font(.headline)
                .foregroundColor(.primary)
            
            if !viewModel.funFacts.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    let currentFact = viewModel.funFacts[viewModel.currentFactIndex]
                    
                    Text(currentFact.question)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text(currentFact.answer)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.currentFactIndex)
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

struct TextStoryView: View {
    let story: String
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text(story)
                        .font(.body)
                        .lineSpacing(8)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct ComicStoryView: View {
    let imageUrls: [String]
    let title: String
    @Binding var isPresented: Bool
    @State private var loadedImages: [Int: UIImage] = [:]
    @State private var currentPage = 0
    @State private var isLoadingCurrentImage = false
    @State private var preloadedImages: Set<Int> = []
    
    // Helper function to calculate optimal image size
    private func calculateImageSize(for geometry: GeometryProxy, image: UIImage) -> CGSize {
        let safeArea = geometry.safeAreaInsets
        let headerHeight: CGFloat = 80
        let padding: CGFloat = 40
        
        let availableWidth = geometry.size.width - safeArea.leading - safeArea.trailing - padding
        let availableHeight = geometry.size.height - safeArea.top - safeArea.bottom - headerHeight - padding
        
        // Calculate aspect ratio
        let imageAspectRatio = image.size.width / image.size.height
        let containerAspectRatio = availableWidth / availableHeight
        
        var finalWidth: CGFloat
        var finalHeight: CGFloat
        
        if imageAspectRatio > containerAspectRatio {
            // Image is wider relative to container, constrain by width
            finalWidth = availableWidth
            finalHeight = finalWidth / imageAspectRatio
        } else {
            // Image is taller relative to container, constrain by height
            finalHeight = availableHeight
            finalWidth = finalHeight * imageAspectRatio
        }
        
        return CGSize(width: max(finalWidth, 100), height: max(finalHeight, 100))
    }
    
    var body: some View {
        GeometryReader { fullGeometry in
            ZStack {
                AppTheme.overlayBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with close button and page indicator
                    HStack {
                        Button("✕") {
                            isPresented = false
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Navigation controls with page indicator
                        HStack(spacing: 16) {
                            // Previous page button
                            Button(action: { goToPreviousPage() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(AppTheme.overlayBackground)
                                    .clipShape(Circle())
                            }
                            .disabled(currentPage == 0)
                            .opacity(currentPage == 0 ? 0.5 : 1.0)
                            
                            // Page indicator
                            Text("\(currentPage + 1)/\(imageUrls.count)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(AppTheme.overlayBackground)
                                .cornerRadius(20)
                            
                            // Next page button
                            Button(action: { advanceToNextPage() }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(AppTheme.overlayBackground)
                                    .clipShape(Circle())
                            }
                            .disabled(currentPage == imageUrls.count - 1)
                            .opacity(currentPage == imageUrls.count - 1 ? 0.5 : 1.0)
                        }
                        
                        Spacer()
                        
                        // Invisible spacer to balance layout
                        Button("") { }
                            .font(.title2)
                            .foregroundColor(.clear)
                            .padding(.trailing, 20)
                            .disabled(true)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                // Main image display (full screen, one at a time)
                ZStack {
                    if isLoadingCurrentImage {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            Text("Loading...")
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                    }
                    
                    if let currentImage = loadedImages[currentPage] {
                        // Calculate optimal image size
                        let imageSize = calculateImageSize(for: fullGeometry, image: currentImage)
                        let safeArea = fullGeometry.safeAreaInsets
                        let headerHeight: CGFloat = 80
                        let availableWidth = fullGeometry.size.width - safeArea.leading - safeArea.trailing - 40
                        let availableHeight = fullGeometry.size.height - safeArea.top - safeArea.bottom - headerHeight - 40
                        
                        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                            Image(uiImage: currentImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: imageSize.width,
                                    height: imageSize.height
                                )
                                .clipped()
                                .opacity(isLoadingCurrentImage ? 0.3 : 1.0)
                        }
                        .frame(
                            maxWidth: max(availableWidth, 100),
                            maxHeight: max(availableHeight, 100)
                        )
                        .background(AppTheme.overlayBackground)
                        .clipped()
                        .contentShape(Rectangle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppTheme.overlayBackground)
            }
        }
        }
        .task {
            await loadCurrentImage()
            await preloadAdjacentImages()
        }
        .onChange(of: currentPage) { _, newPage in
            Task {
                await loadCurrentImage()
                await preloadAdjacentImages()
            }
        }
    }
    
    private func advanceToNextPage() {
        if currentPage < imageUrls.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        }
    }
    
    private func goToPreviousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage -= 1
            }
        }
    }
    
    private func loadCurrentImage() async {
        let index = currentPage
        
        // If image is already loaded, no need to load again
        if loadedImages[index] != nil {
            isLoadingCurrentImage = false
            return
        }
        
        isLoadingCurrentImage = true
        
        guard index < imageUrls.count else {
            isLoadingCurrentImage = false
            return
        }
        
        guard let url = URL(string: imageUrls[index]) else {
            isLoadingCurrentImage = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    loadedImages[index] = image
                    preloadedImages.insert(index)
                    isLoadingCurrentImage = false
                }
            } else {
                await MainActor.run {
                    isLoadingCurrentImage = false
                }
            }
        } catch {
            print("Failed to load image at index \(index): \(error)")
            await MainActor.run {
                isLoadingCurrentImage = false
            }
        }
    }
    
    private func preloadAdjacentImages() async {
        // Priority preload: current, next, and previous images (like React implementation)
        let indicesToPreload = [
            currentPage,     // Current image (highest priority)
            currentPage + 1, // Next image
            currentPage - 1  // Previous image
        ].compactMap { index in
            (index >= 0 && index < imageUrls.count && !preloadedImages.contains(index)) ? index : nil
        }
        
        for index in indicesToPreload {
            guard let url = URL(string: imageUrls[index]) else { continue }
            
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        await MainActor.run {
                            loadedImages[index] = image
                            preloadedImages.insert(index)
                        }
                    }
                } catch {
                    print("Failed to preload image at index \(index): \(error)")
                }
            }
        }
    }
}

struct FormatCard: View {
    let title: String
    let description: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : AppTheme.accentColor)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? AppTheme.accentColor : AppTheme.accentColor.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppTheme.accentColor)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppTheme.accentColor.opacity(0.1) : AppTheme.buttonBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppTheme.accentColor : AppTheme.separator, lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ResultFormatCard: View {
    let title: String
    let icon: String
    let count: Int?
    let isAvailable: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(isAvailable ? .blue : .gray)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(isAvailable ? .primary : .secondary)
                
                if let count = count {
                    Text("\(count) panels")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isAvailable ? AppTheme.accentColor.opacity(0.1) : AppTheme.buttonBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isAvailable ? AppTheme.accentColor : AppTheme.separator, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isAvailable)
    }
}
