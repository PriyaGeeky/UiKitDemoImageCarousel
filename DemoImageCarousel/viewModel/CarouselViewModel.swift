//
//  CarouselViewModel.swift
//  DemoImageCarousel
//
//  Created by Priyanka Sahani on 01/09/24.
//


import Foundation

class CarouselViewModel {
    
    // Define a closure that will update the UI when data is fetched
    var onUsersFetched: (([CarouselModel]) -> Void)?
    
    // Function to fetch users from the API
    func fetchUsers() {
        let urlString = "https://stewartlynch.github.io/CarouselImages/samples.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to fetch users: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let users = try JSONDecoder().decode([CarouselModel].self, from: data)
                
                // Call the closure to update the UI
                DispatchQueue.main.async {
                    self?.onUsersFetched?(users)
                }
            } catch let jsonError {
                print("Failed to decode JSON: \(jsonError)")
            }
        }.resume()
    }
}
