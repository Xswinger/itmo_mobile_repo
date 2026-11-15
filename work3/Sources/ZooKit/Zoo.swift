public final class Zoo {
    public private(set) var animals: [Animal]
    public private(set) var initialCount: Int
    public private(set) var day = 0
    public private(set) var totalBirths = 0
    public private(set) var totalDeaths = 0

    public init(animals: [Animal] = []) {
        precondition(animals.count <= 30, "В зоопарке не может быть больше 30 животных")
        self.animals = animals
        initialCount = animals.count
    }

    public func add(animal: Animal) {
        precondition(animals.count < 30, "В зоопарке нет свободных мест")
        animals.append(animal)
        initialCount += 1
    }

    public func showAnimals(output: (String) -> Void = { print($0) }) {
        for animal in animals {
            output("\(animal.description). Звук: \(animal.makeSound())")
        }
    }

    public func liveOneDay(
        actionFor: (Animal) -> Int = { _ in Int.random(in: 1...3) },
        output: (String) -> Void = { print($0) }
    ) {
        guard !animals.isEmpty else { return }

        day += 1
        output("\nДень \(day)")
        let todayAnimals = animals
        var babies: [Animal] = []

        for animal in todayAnimals {
            let action = actionFor(animal)
            switch action {
            case 1:
                animal.eat()
                output("\(animal.name): ест")
            case 2:
                output("\(animal.name): отдыхает")
            case 3:
                if animal.age < 2 || animal.daysWithoutFood > 1 {
                    output("\(animal.name): попытка рождения — недостаточный возраст/голоден")
                } else if todayAnimals.count + babies.count >= 30 {
                    output("\(animal.name): попытка рождения — нет места")
                } else {
                    let baby = animal.makeBaby()
                    babies.append(baby)
                    output("\(animal.name): родился \(baby.name) (\(type(of: baby)))")
                }
            default:
                preconditionFailure("Неизвестное действие: \(action). Допустимы 1, 2 и 3")
            }
        }

        for animal in todayAnimals {
            animal.growOlder()
        }
        let deadAnimals = todayAnimals.filter { !$0.isAlive }
        for animal in deadAnimals {
            output("Умер: \(animal.name)")
        }
        animals.removeAll { !$0.isAlive }
        animals.append(contentsOf: babies)
        totalBirths += babies.count
        totalDeaths += deadAnimals.count
        output("Осталось животных: \(animals.count)")
    }

    public func runSimulation(
        maxDays: Int = 30,
        actionFor: (Animal) -> Int = { _ in Int.random(in: 1...3) },
        output: (String) -> Void = { print($0) }
    ) {
        precondition(maxDays >= 0, "Число дней не может быть отрицательным")
        for _ in 0..<maxDays {
            if animals.isEmpty { break }
            liveOneDay(actionFor: actionFor, output: output)
        }

        if animals.isEmpty {
            output("Зоопарк пуст. Симуляция завершена досрочно.")
        }
        output("\nИтоги: рождений — \(totalBirths), смертей — \(totalDeaths), осталось — \(animals.count)")
        let expectedCount = initialCount + totalBirths - totalDeaths
        output("Баланс: \(initialCount) + \(totalBirths) - \(totalDeaths) = \(animals.count)")
        precondition(expectedCount == animals.count, "Нарушен баланс популяции")
    }
}
