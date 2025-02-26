//
//  MainMenuViewModel.swift
//  Domashka
//
//  Created by Ulyana Eskova on 17.01.2025.
//

final class MainMenuViewModel {
    private let service: MockMainMenuService
    var chefs: [Chef] = []
    var bestDishes: [Dish] = []
    
    var onDataUpdated: (() -> Void)?
    
    init(service: MockMainMenuService) {
        self.service = service
    }
    
    func fetchData() {
        chefs = service.fetchChefs()
        bestDishes = service.fetchBestDishes()
        onDataUpdated?()
    }
}
