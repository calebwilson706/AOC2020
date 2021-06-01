object Day15 {

    private val myPuzzleInput = mutableListOf(0,12,6,13,20,1,17)

    fun part1() {
        println(findNumberInGame(2020))
    }

    fun part2() {
        println(findNumberInGame(30000000))
    }

    private fun findNumberInGame(at : Int, startNumbers : List<Int> = myPuzzleInput) : Int {
        val lastRegistered = startNumbers.associateWith { startNumbers.indexOf(it) }.toMutableMap()
        var mostRecent = startNumbers.last()

       (startNumbers.lastIndex until at - 1).forEach { player ->
            if (lastRegistered[mostRecent] == null){
                lastRegistered[mostRecent] = player
                mostRecent = 0
            } else {
                val previous = mostRecent
                mostRecent = player - lastRegistered[mostRecent]!!
                lastRegistered[previous] = player
            }
        }
        return (mostRecent)
    }
}