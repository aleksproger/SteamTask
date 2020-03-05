//
//  CircleImage.swift
//  loginSwiftUI
//
//  Created by Alex on 21.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var diameter: CGFloat
    var shadowRadius: CGFloat
    init(image: Image, diameter: CGFloat = 184.0, shadowRadius: CGFloat = 5) {
        self.image = image
        self.diameter = diameter
        self.shadowRadius = shadowRadius
    }
    var body: some View {
    
            image
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4.0))
            .shadow(radius: shadowRadius)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image(systemName: "photo"))
    }
}
