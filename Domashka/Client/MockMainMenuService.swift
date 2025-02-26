//
//  MockMainMenuService.swift
//  Domashka
//
//  Created by Ulyana Eskova on 18.01.2025.
//

final class MockMainMenuService {
    func fetchChefs() -> [Chef] {
        let ingredients = [
            Ingredient(name: "Сыр", imageUrl: "mock_cheese.jpg"),
            Ingredient(name: "Бекон", imageUrl: "mock_bacon.jpg"),
            Ingredient(name: "Томаты", imageUrl: "mock_tomatoes.jpg")
        ]
        
        let nutritionalInfo = NutritionalInfo(
            calories: 500,
            proteins: 25,
            fats: 20,
            carbohydrates: 50
        )
        
        let reviews = [
            Reviews(userName: "Иван Петров", score: 5.0, text: "Великолепно! Очень вкусно."),
            Reviews(userName: "Анна Смирнова", score: 4.5, text: "Было вкусно, но немного жирновато."),
            Reviews(userName: "Мария Иванова", score: 4.0, text: "Быстро доставили, вкус хороший.")
        ]
        
        let chefRating = ChefRating(
            rating: 4.8,
            reviews: reviews
        )
        
        let chef1 = Chef(
            name: "Иван",
            surname: "Смирнов",
            description: "Мастер итальянской кухни с многолетним опытом.",
            rating: chefRating,
            yearsExperience: 10,
            menu: []
        )
        
        let dishesForChef1 = [
            Dish(
                id: "1",
                name: "Паста Карбонара",
                description: "Классическая итальянская паста с соусом на основе яиц, сыра и бекона.",
                chef: chef1,
                rating: 4.9,
                nutritionalInfo: nutritionalInfo,
                optionalIngredients: ingredients,
                portionSize: "200г",
                price: 550,
                imageUrl: "mock_pasta.jpg",
                deliveryTimeMin: 15,
                deliveryTimeMax: 20
            ),
            Dish(
                id: "2",
                name: "Лазанья Болоньезе",
                description: "Слоеное итальянское блюдо с мясным соусом, томатами и сыром.",
                chef: chef1,
                rating: 4.7,
                nutritionalInfo: nutritionalInfo,
                optionalIngredients: ingredients,
                portionSize: "300г",
                price: 700,
                imageUrl: "mock_lasagna.jpg",
                deliveryTimeMin: 15,
                deliveryTimeMax: 20
            )
        ]
        
        let chef1Updated = Chef(
            name: chef1.name,
            surname: chef1.surname,
            description: chef1.description,
            rating: chef1.rating,
            yearsExperience: chef1.yearsExperience,
            menu: dishesForChef1
        )
        
        let chef2 = Chef(
            name: "Анна",
            surname: "Кузнецова",
            description: "Специалист по азиатской кухне, включая тайские и китайские блюда.",
            rating: ChefRating(rating: 4.6, reviews: reviews),
            yearsExperience: 8,
            menu: []
        )
        
        let dishesForChef2 = [
            Dish(
                id: "3",
                name: "Том Ям",
                description: "Острый тайский суп с креветками, кокосовым молоком и лаймом.",
                chef: chef2,
                rating: 4.8,
                nutritionalInfo: nutritionalInfo,
                optionalIngredients: ingredients,
                portionSize: "250г",
                price: 600,
                imageUrl: "mock_tomyam.jpg",
                deliveryTimeMin: 15,
                deliveryTimeMax: 20
            ),
            Dish(
                id: "4",
                name: "Пад Тай",
                description: "Традиционная тайская лапша с креветками, тофу и орехами.",
                chef: chef2,
                rating: 4.6,
                nutritionalInfo: nutritionalInfo,
                optionalIngredients: ingredients,
                portionSize: "300г",
                price: 500,
                imageUrl: "mock_padthai.jpg",
                deliveryTimeMin: 15,
                deliveryTimeMax: 20
            )
        ]
        
        let chef2Updated = Chef(
            name: chef2.name,
            surname: chef2.surname,
            description: chef2.description,
            rating: chef2.rating,
            yearsExperience: chef2.yearsExperience,
            menu: dishesForChef2
        )
        
        return [chef1Updated, chef2Updated]
    }
    
    func fetchBestDishes() -> [Dish] {
        let chefs = fetchChefs()
        
        let allDishes = chefs.flatMap { $0.menu }
        
        let bestDishes = allDishes.sorted { $0.rating > $1.rating }
        
        return bestDishes
    }
}
