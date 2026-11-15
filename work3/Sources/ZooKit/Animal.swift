public class Animal: CustomStringConvertible {
    public var name: String
    public var age: Int
    public var daysWithoutFood: Int

    public init(name: String, age: Int = 0, daysWithoutFood: Int = 0) {
        self.name = name
        self.age = age
        self.daysWithoutFood = daysWithoutFood
    }

    public var maxAge: Int { 10 }

    public var isAlive: Bool {
        age < maxAge && daysWithoutFood < 3
    }

    public var description: String {
        "\(name): возраст — \(age), дней без еды — \(daysWithoutFood)"
    }

    public func makeSound() -> String {
        "Звук животного"
    }

    public func eat() {
        daysWithoutFood = 0
    }

    public func growOlder() {
        age += 1
        daysWithoutFood += 1
    }

    public func makeBaby() -> Animal {
        Animal(name: "Малыш")
    }
}

public final class Rabbit: Animal {
    public override var maxAge: Int { 12 }
    public override func makeSound() -> String { "Фыр-фыр" }
    public override func makeBaby() -> Animal { Rabbit(name: "Малыш") }
}

public final class Parrot: Animal {
    public override var maxAge: Int { 15 }
    public override func makeSound() -> String { "Прррривет!" }
    public override func makeBaby() -> Animal { Parrot(name: "Малыш") }
}

public final class Turtle: Animal {
    public override var maxAge: Int { 20 }
    public override func makeSound() -> String { "Тишина - тоже ответ" }
    public override func makeBaby() -> Animal { Turtle(name: "Малыш") }
}

public final class Cat: Animal {
    public override var maxAge: Int { 14 }
    public override func makeSound() -> String { "Мяу!" }
    public override func makeBaby() -> Animal { Cat(name: "Малыш") }
}

public final class Dog: Animal {
    public override var maxAge: Int { 16 }
    public override func makeSound() -> String { "Гав!" }
    public override func makeBaby() -> Animal { Dog(name: "Малыш") }
}
