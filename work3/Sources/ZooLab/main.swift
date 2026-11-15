import ZooKit

print("Проверка одного животного")
let animal = Animal(name: "Зверёк")
animal.growOlder()
print(animal.description)
animal.eat()
print("После еды: \(animal.description)")
precondition(animal.age == 1 && animal.daysWithoutFood == 0)

let hungryRabbit = Rabbit(name: "Голодный кролик")
for _ in 0..<3 {
    hungryRabbit.growOlder()
}
precondition(!hungryRabbit.isAlive)
print("После трёх дней без еды жив: \(hungryRabbit.isAlive)")

let fedRabbit = Rabbit(name: "Сытый кролик")
fedRabbit.growOlder()
fedRabbit.growOlder()
fedRabbit.eat()
fedRabbit.growOlder()
precondition(fedRabbit.isAlive)
print("Если покормить перед третьим днём, жив: \(fedRabbit.isAlive)")

print("\nОдин день с заданным вручную действием")
let practiceZoo = Zoo(animals: [Turtle(name: "Тестовая черепаха")])
practiceZoo.liveOneDay(actionFor: { _ in 1 })
precondition(practiceZoo.animals[0].daysWithoutFood == 1)

print("\nЗоопарк: начальные животные")
let zoo = Zoo()
let animals: [Animal] = [
    Rabbit(name: "Пушок"),
    Rabbit(name: "Снежок"),
    Parrot(name: "Кеша"),
    Parrot(name: "Рио"),
    Turtle(name: "Тортилла"),
    Turtle(name: "Шелли"),
    Cat(name: "Мурка"),
    Cat(name: "Барсик"),
    Dog(name: "Бобик"),
    Dog(name: "Шарик")
]
for animal in animals {
    zoo.add(animal: animal)
}
zoo.showAnimals()
zoo.runSimulation(maxDays: 30)
