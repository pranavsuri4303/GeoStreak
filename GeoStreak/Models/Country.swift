//
//  Country.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftData

@Model
final class Country: Identifiable {
    @Attribute(.unique) var name: String
    var capital: String
    var level: Int
    var flag: String
    var funFact: String
    var continent: String
    var difficulty: Int
    var isCompleted: Bool
    
    @Relationship(inverse: \UserProgress.completedCountries) var userProgress: UserProgress?
    
    init(name: String, capital: String, level: Int, flag: String, funFact: String, continent: String, difficulty: Int = 3) {
        self.name = name
        self.capital = capital
        self.level = level
        self.flag = flag
        self.funFact = funFact
        self.continent = continent
        self.difficulty = difficulty
        self.isCompleted = false
    }
}

// MARK: - Sample Data
extension Country {
    static var sampleCountries: [Country] {
        // Level 1: European Capitals (Easier)
        let europeanCountries = [
            Country(name: "France", capital: "Paris", level: 1, flag: "🇫🇷",
                    funFact: "France has a law that allows you to marry a dead person. 💍", continent: "Europe", difficulty: 1),
            Country(name: "Germany", capital: "Berlin", level: 1, flag: "🇩🇪",
                    funFact: "Germany has over 1,500 different types of sausage. 🌭", continent: "Europe", difficulty: 1),
            Country(name: "Italy", capital: "Rome", level: 1, flag: "🇮🇹",
                    funFact: "Italians invented pizza – even if they haven't agreed on the best toppings. 🍕", continent: "Europe", difficulty: 1),
            Country(name: "Spain", capital: "Madrid", level: 1, flag: "🇪🇸",
                    funFact: "Spain has a tooth fairy mouse named Ratoncito Pérez. 🐭", continent: "Europe", difficulty: 1),
            Country(name: "United Kingdom", capital: "London", level: 1, flag: "🇬🇧",
                    funFact: "The UK has a law making it illegal to die in Parliament. 💀", continent: "Europe", difficulty: 1),
            Country(name: "Sweden", capital: "Stockholm", level: 1, flag: "🇸🇪",
                    funFact: "Sweden even has a hotel made entirely of ice. ❄️", continent: "Europe", difficulty: 1),
            Country(name: "Finland", capital: "Helsinki", level: 1, flag: "🇫🇮",
                    funFact: "Finland celebrates a national holiday for failure – to learn from it! 😂", continent: "Europe", difficulty: 1),
            Country(name: "Portugal", capital: "Lisbon", level: 1, flag: "🇵🇹",
                    funFact: "Portugal is the world's largest cork producer. 🍾", continent: "Europe", difficulty: 1),
            Country(name: "Netherlands", capital: "Amsterdam", level: 1, flag: "🇳🇱",
                    funFact: "The Netherlands has more bikes than people. 🚲", continent: "Europe", difficulty: 1),
            Country(name: "Belgium", capital: "Brussels", level: 1, flag: "🇧🇪",
                    funFact: "Belgium boasts the world's longest tram line. 🚋", continent: "Europe", difficulty: 1),
            Country(name: "Switzerland", capital: "Bern", level: 1, flag: "🇨🇭",
                    funFact: "Switzerland consumes more chocolate per capita than anywhere else. 🍫", continent: "Europe", difficulty: 1),
            Country(name: "Austria", capital: "Vienna", level: 1, flag: "🇦🇹",
                    funFact: "Austria has a town named 'Fugging'. 😅", continent: "Europe", difficulty: 1),
            Country(name: "Denmark", capital: "Copenhagen", level: 1, flag: "🇩🇰",
                    funFact: "Denmark has twice as many pigs as people. 🐷", continent: "Europe", difficulty: 1),
            Country(name: "Norway", capital: "Oslo", level: 1, flag: "🇳🇴",
                    funFact: "Norway once knighted a penguin. 🐧", continent: "Europe", difficulty: 1),
            Country(name: "Ireland", capital: "Dublin", level: 1, flag: "🇮🇪",
                    funFact: "Ireland has a pub for every 100 people. 🍺", continent: "Europe", difficulty: 1),
            Country(name: "Greece", capital: "Athens", level: 1, flag: "🇬🇷",
                    funFact: "Greece boasts more archaeological museums than any other country. 🏛️", continent: "Europe", difficulty: 1),
            Country(name: "Poland", capital: "Warsaw", level: 1, flag: "🇵🇱",
                    funFact: "Poland is home to the mysterious Błędów Desert. 🏜️", continent: "Europe", difficulty: 1),
            Country(name: "Czech Republic", capital: "Prague", level: 1, flag: "🇨🇿",
                    funFact: "Prague is known as the City of a Hundred Spires. ⛪", continent: "Europe", difficulty: 1),
            Country(name: "Hungary", capital: "Budapest", level: 1, flag: "🇭🇺",
                    funFact: "Budapest is famously split by the Danube into Buda and Pest. 🌉", continent: "Europe", difficulty: 1)
        ]
        
        // Level 2: Asian Capitals
        let asianCountries = [
            Country(name: "Japan", capital: "Tokyo", level: 2, flag: "🇯🇵",
                    funFact: "Japan grows watermelons in perfect square shapes. 🍉", continent: "Asia", difficulty: 2),
            Country(name: "China", capital: "Beijing", level: 2, flag: "🇨🇳",
                    funFact: "China is home to a 34-mile-long bridge. 🌉", continent: "Asia", difficulty: 2),
            Country(name: "India", capital: "New Delhi", level: 2, flag: "🇮🇳",
                    funFact: "India even has a spa exclusively for elephants. 🐘", continent: "Asia", difficulty: 2),
            Country(name: "Thailand", capital: "Bangkok", level: 2, flag: "🇹🇭",
                    funFact: "Thailand hosts an annual monkey buffet festival. 🍌", continent: "Asia", difficulty: 2),
            Country(name: "South Korea", capital: "Seoul", level: 2, flag: "🇰🇷",
                    funFact: "South Korea once opened a toilet-themed park. 🚽", continent: "Asia", difficulty: 2),
            Country(name: "Vietnam", capital: "Hanoi", level: 2, flag: "🇻🇳",
                    funFact: "Vietnam has a cave so vast it can fit a 40-story building. 🏙️", continent: "Asia", difficulty: 2),
            Country(name: "Singapore", capital: "Singapore", level: 2, flag: "🇸🇬",
                    funFact: "Singapore famously banned chewing gum. 🚫", continent: "Asia", difficulty: 2),
            Country(name: "Indonesia", capital: "Jakarta", level: 2, flag: "🇮🇩",
                    funFact: "Indonesia is home to a volcano with blue lava. 🌋", continent: "Asia", difficulty: 2),
            Country(name: "Malaysia", capital: "Kuala Lumpur", level: 2, flag: "🇲🇾",
                    funFact: "Malaysia hosts a cave with over 2 million bats. 🦇", continent: "Asia", difficulty: 2),
            Country(name: "Philippines", capital: "Manila", level: 2, flag: "🇵🇭",
                    funFact: "The Philippines boasts an island within a lake, on an island within a lake. 🏝️", continent: "Asia", difficulty: 2),
            Country(name: "Saudi Arabia", capital: "Riyadh", level: 2, flag: "🇸🇦",
                    funFact: "Saudi Arabia is famously devoid of rivers. 🏜️", continent: "Asia", difficulty: 2),
            Country(name: "United Arab Emirates", capital: "Abu Dhabi", level: 2, flag: "🇦🇪",
                    funFact: "The UAE even has a ski resort in the desert. ⛷️", continent: "Asia", difficulty: 2),
            Country(name: "Qatar", capital: "Doha", level: 2, flag: "🇶🇦",
                    funFact: "Qatar is home to some of the world's richest people per capita. 💰", continent: "Asia", difficulty: 2),
            Country(name: "Oman", capital: "Muscat", level: 2, flag: "🇴🇲",
                    funFact: "Oman has a mountain that soars above the Grand Canyon. 🏔️", continent: "Asia", difficulty: 2),
            Country(name: "Jordan", capital: "Amman", level: 2, flag: "🇯🇴",
                    funFact: "Jordan boasts a city carved entirely from rock. 🏜️", continent: "Asia", difficulty: 2),
            Country(name: "Israel", capital: "Jerusalem", level: 2, flag: "🇮🇱",
                    funFact: "Israel has more museums per capita than anywhere else. 🖼️", continent: "Asia", difficulty: 2),
            Country(name: "Turkey", capital: "Ankara", level: 2, flag: "🇹🇷",
                    funFact: "Turkey is credited with introducing coffee to Europe. ☕", continent: "Asia", difficulty: 2)
        ]
        
        // Level 3: American Capitals
        let americanCountries = [
            Country(name: "United States", capital: "Washington, D.C.", level: 3, flag: "🇺🇸",
                    funFact: "In one U.S. town, it’s actually illegal to die. 🚫", continent: "North America", difficulty: 3),
            Country(name: "Brazil", capital: "Brasília", level: 3, flag: "🇧🇷",
                    funFact: "Brazil’s nut can be deadly if you overindulge. 🌰", continent: "South America", difficulty: 3),
            Country(name: "Canada", capital: "Ottawa", level: 3, flag: "🇨🇦",
                    funFact: "Canada keeps a secret strategic maple syrup reserve. 🥞", continent: "North America", difficulty: 3),
            Country(name: "Mexico", capital: "Mexico City", level: 3, flag: "🇲🇽",
                    funFact: "Mexico even has a museum dedicated solely to tequila. 🍹", continent: "North America", difficulty: 3),
            Country(name: "Argentina", capital: "Buenos Aires", level: 3, flag: "🇦🇷",
                    funFact: "Argentina plays a national sport on horseback called Pato. 🐎", continent: "South America", difficulty: 3),
            Country(name: "Peru", capital: "Lima", level: 3, flag: "🇵🇪",
                    funFact: "Peru has a billboard that generates drinking water from air. 💧", continent: "South America", difficulty: 3),
            Country(name: "Chile", capital: "Santiago", level: 3, flag: "🇨🇱",
                    funFact: "Chile is home to a swimming pool over 1,000 yards long. 🏊", continent: "South America", difficulty: 3),
            Country(name: "Colombia", capital: "Bogotá", level: 3, flag: "🇨🇴",
                    funFact: "Colombia features a river that shimmers like a liquid rainbow. 🌈", continent: "South America", difficulty: 3),
            Country(name: "Venezuela", capital: "Caracas", level: 3, flag: "🇻🇪",
                    funFact: "Venezuela is home to Angel Falls, the world's tallest waterfall. 💦", continent: "South America", difficulty: 3),
            Country(name: "Cuba", capital: "Havana", level: 3, flag: "🇨🇺",
                    funFact: "Cuba proudly displays a statue of John Lennon. 🎸", continent: "North America", difficulty: 3),
            Country(name: "Dominican Republic", capital: "Santo Domingo", level: 3, flag: "🇩🇴",
                    funFact: "The Dominican Republic is famous for its glowing lake. 🌌", continent: "North America", difficulty: 3),
            Country(name: "Costa Rica", capital: "San José", level: 3, flag: "🇨🇷",
                    funFact: "Costa Rica is notable for having no army at all. ✌️", continent: "North America", difficulty: 3),
            Country(name: "Panama", capital: "Panama City", level: 3, flag: "🇵🇦",
                    funFact: "Panama boasts a jungle right in the middle of the city. 🌴", continent: "North America", difficulty: 3),
            Country(name: "Uruguay", capital: "Montevideo", level: 3, flag: "🇺🇾",
                    funFact: "Uruguay has more cows than people. 🐄", continent: "South America", difficulty: 3),
            Country(name: "Paraguay", capital: "Asunción", level: 3, flag: "🇵🇾",
                    funFact: "Paraguay's flag is uniquely designed with different images on each side. 🚩", continent: "South America", difficulty: 3),
            Country(name: "Bolivia", capital: "Sucre", level: 3, flag: "🇧🇴",
                    funFact: "Bolivia even has a hotel made entirely of salt. 🧂", continent: "South America", difficulty: 3)
        ]
        
        // Level 4: African Capitals
        let africanCountries = [
            Country(name: "Egypt", capital: "Cairo", level: 4, flag: "🇪🇬",
                    funFact: "Egypt has a city where it hasn't rained in years. ☀️", continent: "Africa", difficulty: 4),
            Country(name: "South Africa", capital: "Pretoria", level: 4, flag: "🇿🇦",
                    funFact: "South Africa even has a penguin colony on its beaches. 🐧", continent: "Africa", difficulty: 4),
            Country(name: "Kenya", capital: "Nairobi", level: 4, flag: "🇰🇪",
                    funFact: "Kenya’s capital even has a national park right in the city center. 🦒", continent: "Africa", difficulty: 4),
            Country(name: "Morocco", capital: "Rabat", level: 4, flag: "🇲🇦",
                    funFact: "Morocco boasts a town painted entirely blue. 🔵", continent: "Africa", difficulty: 4),
            Country(name: "Nigeria", capital: "Abuja", level: 4, flag: "🇳🇬",
                    funFact: "Nigeria's film industry, Nollywood, produces more movies than Hollywood. 🎬", continent: "Africa", difficulty: 4),
            Country(name: "Ghana", capital: "Accra", level: 4, flag: "🇬🇭",
                    funFact: "Ghana is home to a lake that turns pink in the right light. 🌸", continent: "Africa", difficulty: 4),
            Country(name: "Ethiopia", capital: "Addis Ababa", level: 4, flag: "🇪🇹",
                    funFact: "Ethiopia runs on its own calendar – 7 years behind the Gregorian system. 📅", continent: "Africa", difficulty: 4),
            Country(name: "Tanzania", capital: "Dodoma", level: 4, flag: "🇹🇿",
                    funFact: "Tanzania’s crater is famous for its dense lion population. 🦁", continent: "Africa", difficulty: 4),
            Country(name: "Uganda", capital: "Kampala", level: 4, flag: "🇺🇬",
                    funFact: "Uganda even has a lake named after a British queen. 👑", continent: "Africa", difficulty: 4),
            Country(name: "Senegal", capital: "Dakar", level: 4, flag: "🇸🇳",
                    funFact: "Senegal is home to a baobab tree over 1,000 years old. 🌳", continent: "Africa", difficulty: 4),
            Country(name: "Ivory Coast", capital: "Yamoussoukro", level: 4, flag: "🇨🇮",
                    funFact: "Ivory Coast hosts a basilica larger than St. Peter's. ⛪", continent: "Africa", difficulty: 4),
            Country(name: "Cameroon", capital: "Yaoundé", level: 4, flag: "🇨🇲",
                    funFact: "Cameroon is so diverse it’s often called 'Africa in miniature'. 🌍", continent: "Africa", difficulty: 4),
            Country(name: "Zimbabwe", capital: "Harare", level: 4, flag: "🇿🇼",
                    funFact: "Zimbabwe has balancing rocks that seem to defy gravity. 🪨", continent: "Africa", difficulty: 4),
            Country(name: "Botswana", capital: "Gaborone", level: 4, flag: "🇧🇼",
                    funFact: "Botswana is home to more elephants than any other country. 🐘", continent: "Africa", difficulty: 4),
            Country(name: "Namibia", capital: "Windhoek", level: 4, flag: "🇳🇦",
                    funFact: "Namibia boasts the world's largest free-roaming cheetah population. 🐆", continent: "Africa", difficulty: 4),
            Country(name: "Madagascar", capital: "Antananarivo", level: 4, flag: "🇲🇬",
                    funFact: "Madagascar has a tree that appears to bleed. 🌳", continent: "Africa", difficulty: 4)
        ]
        
        // Level 5: Oceania & Challenging Capitals
        let oceaniaCountries = [
            Country(name: "Australia", capital: "Canberra", level: 5, flag: "🇦🇺",
                    funFact: "Australia has a fence longer than the Great Wall of China. 🐑", continent: "Oceania", difficulty: 5),
            Country(name: "New Zealand", capital: "Wellington", level: 5, flag: "🇳🇿",
                    funFact: "New Zealand has more sheep than people. 🐑", continent: "Oceania", difficulty: 5),
            Country(name: "Kazakhstan", capital: "Astana", level: 5, flag: "🇰🇿",
                    funFact: "Kazakhstan even has its own space launch facility. 🚀", continent: "Asia", difficulty: 5),
            Country(name: "Bhutan", capital: "Thimphu", level: 5, flag: "🇧🇹",
                    funFact: "Bhutan measures prosperity with a national happiness index. 😊", continent: "Asia", difficulty: 5),
            Country(name: "Kiribati", capital: "Tarawa", level: 5, flag: "🇰🇮",
                    funFact: "Kiribati is the only country in all four hemispheres. 🌍", continent: "Oceania", difficulty: 5),
            Country(name: "Fiji", capital: "Suva", level: 5, flag: "🇫🇯",
                    funFact: "Fiji even uses bark as currency – at least in local legends! 🌴", continent: "Oceania", difficulty: 5),
            Country(name: "Papua New Guinea", capital: "Port Moresby", level: 5, flag: "🇵🇬",
                    funFact: "Papua New Guinea is home to over 800 unique languages. 🗣️", continent: "Oceania", difficulty: 5),
            Country(name: "Solomon Islands", capital: "Honiara", level: 5, flag: "🇸🇧",
                    funFact: "The Solomon Islands have a quirky shark-calling tradition. 🦈", continent: "Oceania", difficulty: 5),
            Country(name: "Vanuatu", capital: "Port Vila", level: 5, flag: "🇻🇺",
                    funFact: "Vanuatu even boasts an underwater post office. 📬", continent: "Oceania", difficulty: 5),
            Country(name: "Tonga", capital: "Nuku'alofa", level: 5, flag: "🇹🇴",
                    funFact: "Tonga once had a king who weighed 200 kg. 👑", continent: "Oceania", difficulty: 5),
            Country(name: "Samoa", capital: "Apia", level: 5, flag: "🇼🇸",
                    funFact: "Samoa skipped a day in 2011 to align with Australia. 📅", continent: "Oceania", difficulty: 5),
            Country(name: "Marshall Islands", capital: "Majuro", level: 5, flag: "🇲🇭",
                    funFact: "The Marshall Islands feature a beach made entirely of crushed coral. 🏖️", continent: "Oceania", difficulty: 5),
            Country(name: "Palau", capital: "Ngerulmud", level: 5, flag: "🇵🇼",
                    funFact: "Palau's jellyfish are famous for not stinging. 🪼", continent: "Oceania", difficulty: 5),
            Country(name: "Micronesia", capital: "Palikir", level: 5, flag: "🇫🇲",
                    funFact: "Micronesia once used stones as currency – stone money! 💰", continent: "Oceania", difficulty: 5),
            Country(name: "Nauru", capital: "Yaren", level: 5, flag: "🇳🇷",
                    funFact: "Nauru is the smallest island country in the world. 🏝️", continent: "Oceania", difficulty: 5),
            Country(name: "Tuvalu", capital: "Funafuti", level: 5, flag: "🇹🇻",
                    funFact: "Tuvalu’s population is smaller than many high schools. 🏫", continent: "Oceania", difficulty: 5)
        ]
        
        return europeanCountries + asianCountries + americanCountries + africanCountries + oceaniaCountries
    }
}
