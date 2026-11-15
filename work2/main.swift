import Foundation

// Задание 1. Сборка сообщения из нескольких строк
let messageBeginning = "Swift makes"
let messageEnding = "sense"
print(messageBeginning + " " + messageEnding + "!")
print("\(messageBeginning) \(messageEnding)!")

// Задание 2. Возраст и количество прожитых дней
// Без аргумента используется учебный возраст 20 лет
// Свой возраст можно передать так: ./build_manual.sh 21
let currentAge: Int
if CommandLine.arguments.count == 1 {
    currentAge = 20
    print("Возраст не указан: используется учебный пример - 20 лет")
} else if CommandLine.arguments.count == 2,
          let suppliedAge = Int(CommandLine.arguments[1]),
          suppliedAge >= 0, suppliedAge <= 150 {
    currentAge = suppliedAge
} else {
    print("Ошибка: передайте один целочисленный возраст от 0 до 150 лет")
    exit(1)
}
let ageAfterSevenYears = currentAge + 7
let averageDaysInYear = 365.2425
let estimatedDaysPassed: Float = Float(ageAfterSevenYears) * Float(averageDaysInYear)
print("Сейчас мне \(currentAge) лет. Через 7 лет мне будет \(ageAfterSevenYears) лет. К этому моменту с рождения пройдет примерно \(Int(estimatedDaysPassed)) дней")

// Задание 3. Работа с Float и Double
let firstNumber: Float = 7.25
let secondNumber: Float = 18.6
let sumConvertedAfterAddition: Double = Double(firstNumber + secondNumber)
let sumConvertedBeforeAddition: Double = Double(firstNumber) + Double(secondNumber)
print("Сложение Float с последующим преобразованием: \(sumConvertedAfterAddition)")
print("Преобразование в Double перед сложением: \(sumConvertedBeforeAddition)")
print("Результаты равны: \(sumConvertedAfterAddition == sumConvertedBeforeAddition)")
// Float хранит меньше значащих битов, чем Double. Сложение в Float может
// дополнительно округлить результат и последующее преобразование этого не исправит
// Для данных операндов суммы равны: их сумма представима в Float
// При этом само число 18.6 уже было округлено при сохранении в Float

// Задание 4. Прямоугольный треугольник
let legAB = 9.0
let legBC = 12.0
let hypotenuse = sqrt(legAB * legAB + legBC * legBC)
let triangleArea = legAB * legBC / 2
let trianglePerimeter = legAB + legBC + hypotenuse
print("Гипотенуза: \(hypotenuse)")
print("Площадь: \(triangleArea)")
print("Периметр: \(trianglePerimeter)")

// Задание 5. Целочисленное деление
let totalItems = 17
let boxesCount = 6
let itemsPerBox = totalItems / boxesCount
let remainingItems = totalItems % boxesCount
print("При распределении \(totalItems) элементов по \(boxesCount) коробкам в каждую попадет \(itemsPerBox), останется \(remainingItems)")
print("\(totalItems) / \(boxesCount) = \(itemsPerBox) \(remainingItems)/\(boxesCount)")

// Задание 6. Сколько времени прошло с указанной даты
// Произвольная памятная дата: 1 января 2006 года
let startDay = 1
let startMonth = 1
let startYear = 2006
let currentDay = 17
let currentMonth = 9
let currentYear = 2026
let elapsedDays = (currentYear - startYear) * 360
    + (currentMonth - startMonth) * 30 + (currentDay - startDay)
// Это полные годы и месяцы за весь период, а не остатки после выделения лет
let elapsedYears = elapsedDays / 360
let elapsedMonths = elapsedDays / 30
let elapsedSeconds = elapsedDays * 24 * 60 * 60
print("С указанной даты прошло: \(elapsedYears) лет, \(elapsedMonths) месяцев, \(elapsedDays) дней и \(elapsedSeconds) секунд")

// Задание 7. Определение квартала
func quarterDescription(for month: Int) -> String {
    if month < 1 || month > 12 {
        return "Ошибка: номер месяца должен находиться в диапазоне от 1 до 12."
    } else if month <= 3 {
        return "I квартал"
    } else if month <= 6 {
        return "II квартал"
    } else if month <= 9 {
        return "III квартал"
    } else {
        return "IV квартал"
    }
}
print("Текущий месяц: \(currentMonth). \(quarterDescription(for: currentMonth))")

// Задание 8. Математическая функция. Аргумент cos задаётся в радианах
let cosineOfTwo = cos(2.0)
let roundedCosine = round(cosineOfTwo * 10_000) / 10_000
print("Косинус, округлённый арифметически: \(roundedCosine)")
print(String(format: "Косинус, форматированный до четырёх знаков: %.4f", cosineOfTwo))

// Задание 9. Информация об устройстве
let device = (model: "iPhone 15", releaseYear: 2023, storage: 128)
print("Модель: \(device.model)")
print("Год выпуска: \(device.releaseYear)")
print("Память: \(device.storage) ГБ")
print("Модель: \(device.model), год выпуска: \(device.releaseYear), память: \(device.storage) ГБ")

// Задание 10. Доступ в лабораторию
var hasStudentID = true
var hasScheduledClass = true
var safetyBriefingPassed = true
var isInstructor = false

var canEnterLab: Bool {
    hasStudentID && (isInstructor || hasScheduledClass && safetyBriefingPassed)
}
let accessScenarios = [
    (id: true, scheduled: true, briefed: true, instructor: false),
    (id: true, scheduled: false, briefed: true, instructor: false),
    (id: true, scheduled: true, briefed: false, instructor: false),
    (id: true, scheduled: false, briefed: false, instructor: true),
    (id: false, scheduled: true, briefed: true, instructor: false),
    (id: false, scheduled: false, briefed: false, instructor: true)
]
for scenario in accessScenarios {
    hasStudentID = scenario.id
    hasScheduledClass = scenario.scheduled
    safetyBriefingPassed = scenario.briefed
    isInstructor = scenario.instructor
    print("ID: \(hasStudentID), занятие: \(hasScheduledClass), инструктаж: \(safetyBriefingPassed), преподаватель: \(isInstructor)")
    print("Доступ разрешен: \(canEnterLab)")
}

// Задание 11. Поиск ошибки в условии
// Число не может быть одновременно меньше 1 И больше 12, поэтому исходное
// условие с && всегда ложно, в том числе для 15. Нужен оператор || (ИЛИ):
// достаточно нарушения хотя бы одной границы, исправление - в задании 7
for month in [-2, -1, 0, 1, 4, 9, 12, 13, 15, 27] {
    print("Месяц \(month): \(quarterDescription(for: month))")
}

// Задание 12. Найти и записать число Фибоначчи 4250
// Нумерация: F(0) = 0, F(1) = 1. Для F(4250) типа Int недостаточно,
// поэтому храним десятичные цифры от младшей к старшей цифре
// и складываем с переносом.
func addDecimalDigits(_ left: [Int], _ right: [Int]) -> [Int] {
    var result: [Int] = []
    var carry = 0
    for index in 0..<max(left.count, right.count) {
        let leftDigit = index < left.count ? left[index] : 0
        let rightDigit = index < right.count ? right[index] : 0
        let sum = leftDigit + rightDigit + carry
        result.append(sum % 10)
        carry = sum / 10
    }
    if carry > 0 {
        result.append(carry)
    }
    return result
}

func fibonacci(_ index: Int) -> String {
    precondition(index >= 0, "Номер числа Фибоначчи не может быть отрицательным")
    var previous = [0]
    var current = [1]
    for _ in 0..<index {
        let next = addDecimalDigits(previous, current)
        previous = current
        current = next
    }
    return previous.reversed().map { String($0) }.joined()
}

let fibonacci4250 = fibonacci(4250)
print("F(4250) = \(fibonacci4250)")
