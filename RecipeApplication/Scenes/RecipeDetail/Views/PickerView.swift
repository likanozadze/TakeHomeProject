//
//  PickerView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//

import SwiftUI

struct PickerView: View {
    @Binding var selectedSegment: String
    
    let filterOptions: [String]
    
    init(selectedSegment: Binding<String>, filterOptions: [String]) {
        
        _selectedSegment = selectedSegment
        self.filterOptions = filterOptions
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 134/255, green: 191/255, blue: 62/255, alpha: 1.0)
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)}
    
    var body: some View {
        Picker(
            selection: $selectedSegment,
            label: Text("Picker"),
            content: {
                ForEach(filterOptions, id: \.self) { option in
                    Text(option)
                        .tag(option)
                }
            })
        .pickerStyle(SegmentedPickerStyle())
        
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(selectedSegment: .constant("Ingredients"), filterOptions: ["Ingredients", "Instructions"])
    }
}
