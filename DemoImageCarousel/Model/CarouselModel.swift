//
//  CarouselModel.swift
//  DemoImageCarousel
//
//  Created by Priyanka Sahani on 01/09/24.
//

import Foundation

struct CarouselModel: Identifiable, Codable, Hashable {
    let id: Int
    let imageUrl: URL
    let caption: String
}
