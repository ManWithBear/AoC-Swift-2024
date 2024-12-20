import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day20Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        ###############
        #...#...#.....#
        #.#.#.#.#.###.#
        #S#...#.#.#...#
        #######.#.#.###
        #######.#.#...#
        #######.#.###.#
        ###..E#...#...#
        ###.#######.###
        #...###...#...#
        #.#####.#.###.#
        #.#...#.#.#...#
        #.#.#.#.#.#.###
        #...#...#...###
        ###############
        """

    @Test func testPart1() async throws {
        let challenge = Day20(data: testData, saveAtLeast: 20)
        #expect(String(describing: challenge.part1()) == "5")
    }

    @Test func testPart2() async throws {
        let challenge = Day20(data: testData)
        #expect(String(describing: challenge.part2()) == "-1")
    }
}
