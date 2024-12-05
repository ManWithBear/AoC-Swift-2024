import Algorithms

enum Letter {
    static let x = Character("X")
    static let m = Character("M")
    static let a = Character("A")
    static let s = Character("S")
}

struct Day04: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var characters: [[Character]]

    var width: Int {
        characters.first?.count ?? 0
    }
    var height: Int {
        characters.count
    }

    init(data: String) {
        self.data = data
        characters = data.split(separator: "\n")
            .map(Array.init)
    }

    func countXMAS(at index: (y: Int, x: Int)) -> Int {
        guard characters[index.y][index.x] == Letter.x else {
            return 0
        }
        var count = 0
        // Look N
        if index.y - 3 >= 0 {
            if characters[index.y - 1][index.x] == Letter.m
                && characters[index.y - 2][index.x] == Letter.a
                && characters[index.y - 3][index.x] == Letter.s
            {
                count += 1
            }
        }
        // Look NE
        if index.y - 3 >= 0 && index.x + 3 < width {
            if characters[index.y - 1][index.x + 1] == Letter.m
                && characters[index.y - 2][index.x + 2] == Letter.a
                && characters[index.y - 3][index.x + 3] == Letter.s
            {
                count += 1
            }
        }
        // Look E
        if index.x + 3 < width {
            if characters[index.y][index.x + 1] == Letter.m
                && characters[index.y][index.x + 2] == Letter.a
                && characters[index.y][index.x + 3] == Letter.s
            {
                count += 1
            }
        }
        // Look SE
        if index.y + 3 < height && index.x + 3 < width {
            if characters[index.y + 1][index.x + 1] == Letter.m
                && characters[index.y + 2][index.x + 2] == Letter.a
                && characters[index.y + 3][index.x + 3] == Letter.s
            {
                count += 1
            }
        }
        // Look S
        if index.y + 3 < height {
            if characters[index.y + 1][index.x] == Letter.m
                && characters[index.y + 2][index.x] == Letter.a
                && characters[index.y + 3][index.x] == Letter.s
            {
                count += 1
            }
        }
        // Look SW
        if index.y + 3 < height && index.x - 3 >= 0 {
            if characters[index.y + 1][index.x - 1] == Letter.m
                && characters[index.y + 2][index.x - 2] == Letter.a
                && characters[index.y + 3][index.x - 3] == Letter.s
            {
                count += 1
            }
        }
        // Look W
        if index.x - 3 >= 0 {
            if characters[index.y][index.x - 1] == Letter.m
                && characters[index.y][index.x - 2] == Letter.a
                && characters[index.y][index.x - 3] == Letter.s
            {
                count += 1
            }
        }
        // Look NW
        if index.y - 3 >= 0 && index.x - 3 >= 0 {
            if characters[index.y - 1][index.x - 1] == Letter.m
                && characters[index.y - 2][index.x - 2] == Letter.a
                && characters[index.y - 3][index.x - 3] == Letter.s
            {
                count += 1
            }
        }
        return count
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var count = 0
        for y in 0..<height {
            for x in 0..<width {
                count += countXMAS(at: (y, x))
            }
        }
        return count
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
