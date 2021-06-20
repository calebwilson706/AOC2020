import java.io.File

object Day21 {
    private val inputLines =  File("/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day21Input.txt").readLines()

    fun part1() {
        val recipes = parseInput()
        val myAllergens = getTranslationsOfIngredients().values
        val allIngredients = recipes.flatMap { it.foreignIngredients }

        print(allIngredients.count { !myAllergens.contains(it) })
    }

    fun part2() {
        print(
            getTranslationsOfIngredients()
                .toSortedMap()
                .values
                .joinToString(",")
        )
    }

    private fun getTranslationsOfIngredients(): MutableMap<String, String> {
        val recipes = parseInput()
        val ingredientsToFind = getAllIngredientsKnown(recipes)

        val possibleTranslations = ingredientsToFind.associateWith { ingredientToFind ->
            recipes.filter {
                it.knownIngredients.contains(ingredientToFind)
            }.map {
                it.foreignIngredients
            }.mutualItems()
        }.toMutableMap()

        val result = mutableMapOf<String, String>()

        while (possibleTranslations.isNotEmpty()) {
            val nextFound = possibleTranslations.filter { it.value.size == 1 }.entries.first()
            result[nextFound.key] = nextFound.value.first()
            possibleTranslations.remove(nextFound.key)
            possibleTranslations.forEach { entry ->
                entry.value.remove(nextFound.value.first())
            }

        }

        return result
    }

    private fun getAllIngredientsKnown(recipes : List<Recipe>) : Set<String> {
        return recipes.foldRight(setOf<String>()) { next, acc ->
            acc + next.knownIngredients
        }
    }

    private fun parseInput() : List<Recipe> {
        return inputLines.map {
            val parts = it.split(" (")
            val foreignIngredients = parts.first().splitByWhiteSpace()

            if (parts.size == 1) {
                Recipe(foreignIngredients, emptyList())
            } else {
                val known = parts.last().dropLast(1).drop(9).split(", ")
                Recipe(foreignIngredients, known)
            }
        }
    }

    private fun List<List<String>>.mutualItems() : MutableSet<String> {
        return this.first().filter { ingredient ->
            this.all {
                it.contains(ingredient)
            }
        }.toMutableSet()
    }
}

data class Recipe(val foreignIngredients : List<String>, val knownIngredients : List<String>)

