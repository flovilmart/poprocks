import Foundation


// protocol Coder
protocol CoderType{
    func code() -> String
    func sleep() -> [AnyObject?]?
}

//extension GoodCoder
protocol GoodCoderType:CoderType {
    func writeTests() -> String
}


// protocol DrunkCoder
protocol DrunkCoderType:CoderType {
    func code() throws -> String
    func takeAShot() throws
}

extension CoderType {
    func code() -> String {
        return "code"
    }
    
    func sleep() -> [AnyObject?]? {
        return nil
    }
}




//protocol GoodCoder
extension GoodCoderType {
    func code() -> String {
        return "\(writeTests()) + code"
    }
    func writeTests() -> String {
        return "I WRITE UNIT TESTS!!"
    }
}

struct DrunkCoder:DrunkCoderType {
    
    func code() throws -> String {
        try takeAShot()
        return "drunk_code"
    }
    
    func takeAShot() throws {
        if random() % 5 == 0 {
            try vomit()
        }
    }
    func vomit() throws {
        throw NSError(domain: "com.flovilmart.coder.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "puke"])
    }
}

let coder = DrunkCoder()

var codeVomits = (0.0, 0.0)
var starving = 0

let range = 1...100

let drunkCoding:[String?] = range.map({ (_) -> String? in
    var result:String?
    do {
        result = try coder.code()
        codeVomits.0++
    }catch let error {
        print(error)
        codeVomits.1++
    }
    return result
})

let r = codeVomits.1/codeVomits.0

struct Coder:CoderType {}

struct GoodCoder:GoodCoderType {}

protocol CoderTeamType:CoderType {
    var coders:[CoderType] {get set}
}

extension CoderTeamType {
    mutating func build(count:Int) {
        for _ in 1..<count {
            switch random()%3 {
            case 0:
                coders.append(Coder())
            case 1:
                coders.append(GoodCoder())
            case 2:
                coders.append(DrunkCoder())
            default:
                break
            }
        }
    }
    
    func code() -> String {
        return coders.map({ (coder) -> String in
            return coder.code()
        }).reduce("", combine: { (a, str) -> String in
            return "\(a) \(str)"
        })
    }
}


struct Team:CoderTeamType {
    var coders = [CoderType]()
}

var team = Team()
team.build(20)

team.code()
