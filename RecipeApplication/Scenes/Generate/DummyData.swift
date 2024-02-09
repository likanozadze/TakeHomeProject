//
//  DummyData.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/6/24.
//

import SwiftUI


struct DRecipe: Identifiable {
    var id: Int
    var title: String
    var image: String
    var servings: Int
    var cookTime: Int
    var ingredients: [dummyIngredient]
    var instructions: [dummyInstruction]
}

struct dummyIngredient: Identifiable {
    var id: Int
    var name: String
    var amount: Double
    var unit: String
    
}

struct dummyInstruction: Identifiable {
    var id: Int
    var step: String
}
let dummyRecipes: [DRecipe] = [
    DRecipe(id: 716426,
            title: "Chicken Shawarma",
            image: "chicken",
            servings: 6,
            cookTime: 30,
            ingredients: [
                dummyIngredient(id: 20444, name: "chicken breast", amount: 2.0, unit: "pounds"),
                dummyIngredient(id: 11215, name: "plain yogurt", amount: 1.0, unit: "cups"),
                dummyIngredient(id: 1002049, name: "lemon juice", amount: 2.0, unit: "tbl"),
                dummyIngredient(id: 10014505, name: "olive oil", amount: 2.0, unit: "tbl"),
                dummyIngredient(id: 10020502, name: "garlic", amount: 4.0, unit: "cloves"),
                dummyIngredient(id: 10018020, name: "cumin", amount: 1.0, unit: "tsp"),
                dummyIngredient(id: 10018021, name: "coriander", amount: 1.0, unit: "tsp"),
                dummyIngredient(id: 10018022, name: "paprika", amount: 1.0, unit: "tsp")
            ],
            instructions: [
                dummyInstruction(id: 1, step: "In a large bowl, whisk together yogurt, lemon juice, olive oil, garlic, cumin, coriander, paprika, turmeric, cinnamon, cayenne, and salt. Add chicken and toss to coat. Cover and refrigerate for at least 1 hour and up to 24 hours."),
                dummyInstruction(id: 2, step: "Light one chimney full of charcoal. When all the charcoal is lit and covered with gray ash, pour out and spread the coals evenly over half of coal grate. Alternatively, set all the burners of a gas grill to high heat. Set cooking grate in place, cover grill, and allow to preheat for 5 minutes. Clean and oil the grilling grate."),
                dummyInstruction(id: 3, step: "Grill chicken until well charred on both sides and center registers 165°F on an instant-read thermometer, about 5 minutes per side. Transfer to a cutting board and let rest for 5 minutes. Slice into thin strips."),
                dummyInstruction(id: 4, step: "Serve with pita, tahini sauce, tomatoes, cucumber, parsley, and onion.")
            ]),
    
    DRecipe(id: 823759,
            title: "Chicken Alfredo Pasta",
            image: "alfredo",
            servings: 4,
            cookTime: 25,
            ingredients: [
                dummyIngredient(id: 1022020, name: "fettuccine pasta", amount: 8.0, unit: "ounces"),
                dummyIngredient(id: 1005114, name: "butter", amount: 3.0, unit: "tablespoons"),
                dummyIngredient(id: 2047, name: "boneless, skinless chicken breast", amount: 1.0, unit: "pound"),
                dummyIngredient(id: 11291, name: "heavy cream", amount: 1.0, unit: "cup"),
                dummyIngredient(id: 1033, name: "parmesan cheese", amount: 1.0, unit: "cup"),
                dummyIngredient(id: 10019335, name: "garlic powder", amount: 1.0, unit: "teaspoon"),
                dummyIngredient(id: 1102047, name: "black pepper", amount: 0.5, unit: "teaspoon"),
                dummyIngredient(id: 2049, name: "salt", amount: 0.5, unit: "teaspoon")
            ],
            instructions: [
                dummyInstruction(id: 1, step: "Cook fettuccine pasta according to package instructions. Drain and set aside."),
                dummyInstruction(id: 2, step: "In a large skillet, melt butter over medium heat. Add chicken breasts and cook until browned and no longer pink in the center, about 6-7 minutes per side. Remove chicken from skillet and let it rest."),
                dummyInstruction(id: 3, step: "In the same skillet, add heavy cream, parmesan cheese, garlic powder, black pepper, and salt. Cook over medium heat, stirring constantly, until the sauce thickens, about 5 minutes."),
                dummyInstruction(id: 4, step: "Slice cooked chicken into thin strips. Add cooked fettuccine and sliced chicken to the skillet with the alfredo sauce. Toss until everything is well coated and heated through."),
                dummyInstruction(id: 5, step: "Serve hot, garnished with additional parmesan cheese and freshly ground black pepper, if desired.")
            ]),
    
    DRecipe(id: 961428,
            title: "Vegetarian Stir-Fry",
            image: "stirfry",
            servings: 4,
            cookTime: 20,
            ingredients: [
                dummyIngredient(id: 11215, name: "soy sauce", amount: 0.25, unit: "cup"),
                dummyIngredient(id: 2047, name: "vegetable broth", amount: 0.5, unit: "cup"),
                dummyIngredient(id: 11282, name: "sesame oil", amount: 2.0, unit: "tablespoons"),
                dummyIngredient(id: 10018350, name: "ginger", amount: 1.0, unit: "tablespoon"),
                dummyIngredient(id: 10011282, name: "garlic", amount: 3.0, unit: "cloves"),
                dummyIngredient(id: 10011282, name: "mixed vegetables", amount: 4.0, unit: "cups"),
                dummyIngredient(id: 10118368, name: "tofu", amount: 12.0, unit: "ounces"),
                dummyIngredient(id: 11216, name: "cornstarch", amount: 1.0, unit: "tablespoon"),
                dummyIngredient(id: 20081, name: "water", amount: 2.0, unit: "tablespoons")
            ],
            instructions: [
                dummyInstruction(id: 1, step: "In a small bowl, whisk together soy sauce, vegetable broth, sesame oil, ginger, garlic, and cornstarch mixture. Set aside."),
                dummyInstruction(id: 2, step: "Heat a large skillet or wok over medium-high heat. Add tofu and cook until browned on all sides, about 5-7 minutes. Remove tofu from skillet and set aside."),
                dummyInstruction(id: 3, step: "In the same skillet, add mixed vegetables and stir-fry for 3-4 minutes until slightly softened."),
                dummyInstruction(id: 4, step: "Return tofu to the skillet. Pour the sauce over the tofu and vegetables. Cook, stirring constantly, until the sauce has thickened and everything is heated through, about 2-3 minutes."),
                dummyInstruction(id: 5, step: "Serve hot over cooked rice or noodles.")
            ]),
    DRecipe(
        id: 123456,
        title: "Classic Margherita Pizza",
        image: "margherita",
        servings: 2,
        cookTime: 15,
        ingredients: [
            dummyIngredient(id: 234567, name: "pizza dough", amount: 1.0, unit: "ball"),
            dummyIngredient(id: 345678, name: "fresh mozzarella cheese", amount: 8.0, unit: "ounces"),
            dummyIngredient(id: 456789, name: "ripe tomatoes", amount: 2.0, unit: "medium"),
            dummyIngredient(id: 567890, name: "fresh basil leaves", amount: 1.0, unit: "bunch"),
            dummyIngredient(id: 678901, name: "extra virgin olive oil", amount: 2.0, unit: "tablespoons"),
            dummyIngredient(id: 789012, name: "salt", amount: 1.0, unit: "teaspoon"),
            dummyIngredient(id: 890123, name: "black pepper", amount: 0.5, unit: "teaspoon")
        ],
        instructions: [
            dummyInstruction(id: 1, step: "Preheat your oven to 475°F (245°C). Place a pizza stone or baking sheet in the oven to preheat."),
            dummyInstruction(id: 2, step: "Roll out the pizza dough into a circle on a lightly floured surface."),
            dummyInstruction(id: 3, step: "Slice the tomatoes thinly. Tear the fresh mozzarella into small pieces."),
            dummyInstruction(id: 4, step: "Spread olive oil over the rolled-out dough. Arrange the tomato slices and mozzarella pieces evenly over the dough."),
            dummyInstruction(id: 5, step: "Season with salt and black pepper."),
            dummyInstruction(id: 6, step: "Bake the pizza in the preheated oven for 10-12 minutes, or until the crust is golden and the cheese is bubbly."),
            dummyInstruction(id: 7, step: "Remove the pizza from the oven and top with fresh basil leaves before serving."),
            dummyInstruction(id: 8, step: "Slice and serve hot. Enjoy your classic Margherita pizza!")
        ]),
    
    DRecipe(
        id: 234567,
        title: "Chocolate Chip Cookies",
        image: "cookies",
        servings: 24,
        cookTime: 10,
        ingredients: [
            dummyIngredient(id: 345678, name: "all-purpose flour", amount: 2.25, unit: "cups"),
            dummyIngredient(id: 456789, name: "baking soda", amount: 1.0, unit: "teaspoon"),
            dummyIngredient(id: 567890, name: "salt", amount: 0.5, unit: "teaspoon"),
            dummyIngredient(id: 678901, name: "unsalted butter", amount: 1.0, unit: "cup"),
            dummyIngredient(id: 789012, name: "granulated sugar", amount: 0.75, unit: "cup"),
            dummyIngredient(id: 890123, name: "packed light brown sugar", amount: 0.75, unit: "cup"),
            dummyIngredient(id: 901234, name: "vanilla extract", amount: 1.0, unit: "teaspoon"),
            dummyIngredient(id: 123456, name: "large eggs", amount: 2.0, unit: ""),
            dummyIngredient(id: 234567, name: "semi-sweet chocolate chips", amount: 2.0, unit: "cups")
        ],
        instructions: [
            dummyInstruction(id: 1, step: "Preheat your oven to 375°F (190°C). Line baking sheets with parchment paper."),
            dummyInstruction(id: 2, step: "In a small bowl, combine flour, baking soda, and salt. Set aside."),
            dummyInstruction(id: 3, step: "In a large mixing bowl, cream together the butter, granulated sugar, and brown sugar until light and fluffy."),
            dummyInstruction(id: 4, step: "Beat in the eggs, one at a time, then stir in the vanilla extract."),
            dummyInstruction(id: 5, step: "Gradually blend in the dry ingredients, then fold in the chocolate chips."),
            dummyInstruction(id: 6, step: "Drop tablespoon-sized balls of dough onto the prepared baking sheets, spacing them about 2 inches apart."),
            dummyInstruction(id: 7, step: "Bake for 8 to 10 minutes, or until edges are lightly golden."),
            dummyInstruction(id: 8, step: "Allow the cookies to cool on the baking sheets for a few minutes before transferring to wire racks to cool completely."),
            dummyInstruction(id: 9, step: "Enjoy your delicious homemade chocolate chip cookies!")
        ])
    ]
