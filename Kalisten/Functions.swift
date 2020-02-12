import Foundation

class Functions {
    
    static func difficultyLevel(difficulty: Int) -> String {
        
        var diffLevel = ""
        
        switch difficulty {
        case 1: diffLevel = "SUPER EASY"
        case 2: diffLevel = "VERY EASY"
        case 3: diffLevel = "EASY"
        case 4: diffLevel = "NORMAL"
        case 5: diffLevel = "CHALLENGING"
        case 6: diffLevel = "HARD"
        case 7: diffLevel = "VERY HARD"
        case 8: diffLevel = "SUPER HARD"
        case 9: diffLevel = "PROFESSIONAL"
        case 10: diffLevel = "OLYMPIC"
        default:
            diffLevel = "DIFFICULTY"
        }
        
        return diffLevel
    }
    
    static func difficultyAmount(difficulty: String) -> Int {
        
        var diffLevel = 0
        
        switch difficulty {
        case "SUPER EASY": diffLevel = 1
        case "VERY EASY": diffLevel = 2
        case "EASY": diffLevel = 3
        case "NORMAL": diffLevel = 4
        case "CHALLENGING": diffLevel = 5
        case "HARD": diffLevel = 6
        case "VERY HARD": diffLevel = 7
        case "SUPER HARD": diffLevel = 8
        case "PROFESSIONAL": diffLevel = 9
        case "OLYMPIC": diffLevel = 10
        default:
            diffLevel = 0
        }
        
        return diffLevel
    }
}
