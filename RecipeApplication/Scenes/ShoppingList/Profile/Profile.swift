//
//  Profile.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 4/29/24.
//


import SwiftUI
import PhotosUI
@MainActor
struct ProfilePage: View {
   
    @EnvironmentObject var authService: AuthService


    var body: some View {
        Group {
                ProfileView()
                .environmentObject(AuthService.shared)
                    .environmentObject(NavigationCoordinator(navigationController: UINavigationController()))
                    .environmentObject(ShoppingListViewModel.shared)
            }
        }
    }

struct ProfileView: View {
    
    @State private var avatarImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @EnvironmentObject var authService: AuthService
    @State private var shoppingList: [ExtendedIngredient] = []
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var shoppingListViewModel: ShoppingListViewModel
    
    @StateObject private var userManager = UserManager.shared
    
    @State private var selectedSegment: String = "Shopping list"
    var body: some View {
        
        VStack(alignment: .leading){
            userInfoSection
            PickerView(selectedSegment: $selectedSegment, filterOptions: ["Shopping list", "Favorited Recipes"])
            
            if selectedSegment == "Shopping list" {
                ShoppingListView()
            } else if selectedSegment == "Favorited Recipes" {
                FavoritesViewControllerRepresentable()
                
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            
            if let currentUserID = AuthService.shared.currentUser?.id {
                userManager.downloadProfileImage(userId: currentUserID) { (image, error) in
                    if let error = error {
                        print("Error downloading profile image: \(error)")
                    } else if let image = image {
                        DispatchQueue.main.async {
                            self.avatarImage = image
                            print("Profile image downloaded and set successfully")
                        }
                    } else {
                        print("Error: Downloaded image is nil")
                    }
                }
            }
            Task {
                await shoppingListViewModel.loadShoppingList()                
            }
        }
    }
    
    private var userInfoSection: some View {
        Section {
            HStack {
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(.circle)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(.circle)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(AuthService.shared.currentUser?.username ?? "username not found")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(AuthService.shared.currentUser?.email ?? "email not found")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                ButtonView(text: "Log out") {
                    print("Logout button pressed")
                    AuthService.shared.signOut { error in
                        if let error = error {
                            print("Error signing out: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.navigationCoordinator.state = .unauthenticated
                            }
                        }
                    }
                }
                .frame(width: 80)
            }
            .onChange(of: photosPickerItem) { _ in
                Task { await handleImageSelection() }
            }
            
        }
        .padding()
    }
    
    private func handleImageSelection() async {
        if let photosPickerItem,
           let data = try? await photosPickerItem.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            avatarImage = image
            
            do {
                if let currentUserID = AuthService.shared.currentUser?.id,
                   let avatarImage = avatarImage {
                 userManager.uploadProfileImage(userId: currentUserID, image: avatarImage) { error in
                        if let error = error {
                            print("Error uploading profile image: \(error)")
                        } else {
                            print("Profile image uploaded successfully")
                        }
                    }
                } else {
                    print("Error: Current user ID not found or avatarImage is nil")
                }
    
            }
        }
        photosPickerItem = nil
    }
}
