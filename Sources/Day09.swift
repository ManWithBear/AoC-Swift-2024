import Algorithms

struct Day09: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var blocks: [Int]

    init(data: String) {
        self.data = data
        self.blocks = data.map { $0.wholeNumberValue! }
    }

    func sumSequence(start: Int, count: Int, d: Int = 1) -> Int {
        count * (2 * start + (count - 1) * d) / 2
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var checkSum = 0
        let occupiedDiskSize = blocks.reduce((flag: 1, size: 0)) { (acc, block) in
            (1 - acc.flag, acc.size + block * acc.flag)
        }.size
        var mapIndex = 0
        var blockIndex: Int { mapIndex / 2 }
        var diskPointer = 0
        var emptyStack = [(from: Int, to: Int)]()

        var isDataBlock = true
        var list = blocks

        // Calculate the checksum for data blocks that don't need to be moved
        // while keeping track of empty spaces
        while diskPointer < occupiedDiskSize {
            let blockSize = list.removeFirst()
            let blockUsage = min(blockSize, occupiedDiskSize - diskPointer)
            if isDataBlock {
                let indexSum = sumSequence(
                    start: diskPointer,
                    count: blockUsage,
                    d: 1
                )
                checkSum += blockIndex * indexSum
            } else {
                emptyStack.append((diskPointer, diskPointer + blockUsage))
            }
            diskPointer += blockUsage
            if blockSize > blockUsage {
                list.insert(blockSize - blockUsage, at: 0)
            } else {
                mapIndex += 1
                isDataBlock.toggle()
            }
        }
        // If the last block was an empty space, drop it
        if !isDataBlock {
            mapIndex += 1
            list.removeFirst()
        }

        // Calculate the checksum for empty spaces by filling them from end to start
        while let (from, to) = emptyStack.popLast() {
            let blockSize = list.removeFirst()
            let blockUsage = min(blockSize, to - from)
            let indexSum = sumSequence(start: to - 1, count: blockUsage, d: -1)
            checkSum += blockIndex * indexSum
            if blockSize > blockUsage {
                list.insert(blockSize - blockUsage, at: 0)
            } else {
                if blockUsage < to - from {
                    emptyStack.append((from, to - blockUsage))
                }
                if !list.isEmpty {
                    list.removeFirst()  // drop extra empty space
                }
                mapIndex += 2
            }
        }

        return checkSum
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        // 10064434267399 is too high
        struct DataBlock {
            var size: Int
            var index: Int
            var id: Int
        }
        var blocks = self.blocks.reduce((idx: 0, isDataBlock: true, blocks: [DataBlock]())) {
            acc, block in
            var index = acc.idx
            var blocks = acc.blocks
            if acc.isDataBlock {
                blocks.append(DataBlock(size: block, index: index, id: blocks.count))
            }
            index += block
            return (index, !acc.isDataBlock, blocks)
        }.blocks

        var tailPointer = blocks.count - 1
        while tailPointer > 0 {
            var block = blocks[tailPointer]
            var headPointer = 0
            while headPointer < tailPointer {
                let headBlock = blocks[headPointer]
                let nextHeadBlock = blocks[headPointer + 1]
                let space = nextHeadBlock.index - (headBlock.index + headBlock.size)
                if space >= block.size {
                    block.index = headBlock.index + headBlock.size
                    blocks.remove(at: tailPointer)
                    blocks.insert(block, at: headPointer + 1)
                    tailPointer += 1  // after a shift the tail pointer is pointing to the next block (counter -1 outside the loop)
                    break
                }
                headPointer += 1
            }
            tailPointer -= 1
        }

        return blocks.reduce(0) { acc, block in
            acc + sumSequence(start: block.index, count: block.size, d: 1) * block.id
        }
    }
}
