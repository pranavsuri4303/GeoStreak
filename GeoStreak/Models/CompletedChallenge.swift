//
//  CompletedChallenge.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftData

@Model
final class CompletedChallenge {
    var countryName: String
    var challengeTypeId: String
    var completedDate: Date
    
    init(countryName: String, challengeTypeId: String, completedDate: Date = Date()) {
        self.countryName = countryName
        self.challengeTypeId = challengeTypeId
        self.completedDate = completedDate
    }
}
