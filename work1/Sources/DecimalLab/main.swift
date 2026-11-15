import DecimalKit
import Foundation

func show(_ title: String, _ value: Decimal) {
    print("\(title): \(value)")
}

print("1. Создание Decimal")
let integer = Decimal(42)
let exactFromString = try Decimal.exact("0.1")
let pollutedByDouble = Decimal(0.1 + 0.2)
let exactThreeTenths = try Decimal.exact("0.3")

show("Из Int", integer)
show("Из строки", exactFromString)
show("После вычисления из Double", pollutedByDouble)
show("0.3 из строки", exactThreeTenths)
print("Проверка равенства последних двух значений", pollutedByDouble == exactThreeTenths)

print("\n2. Денежная арифметика")
let unitPrice = try Decimal.exact("19.99")
let quantity = Decimal(3)
let subtotal = unitPrice * quantity
let taxRate = try Decimal.exact("0.20")
let tax = subtotal * taxRate
let total = subtotal + tax

show("Стоимость без налога", subtotal)
show("Налог", tax)
show("Итого", total.rounded(scale: 2, mode: .plain))

print("\n3. Режимы округления")
let halfway = try Decimal.exact("2.345")
show("plain", halfway.rounded(scale: 2, mode: .plain))
show("bankers", halfway.rounded(scale: 2, mode: .bankers))
show("down", halfway.rounded(scale: 2, mode: .down))
show("up", halfway.rounded(scale: 2, mode: .up))

print("\n4. Локаль и форматирование")
let russianLocale = Locale(identifier: "ru_RU")
if let localized = Decimal(string: "1234,56", locale: russianLocale) {
    show("Строка ru_RU", localized)
    let currency = localized.formatted(
        .currency(code: "RUB").locale(russianLocale)
    )
    print("Валюта:", currency)
}

print("\n5. Сравнение, сортировка и проверяемое деление")
let values = try ["10.5", "2.75", "100.01"].map(Decimal.exact)
print("По возрастанию:", values.sorted())

do {
    let oneThird = try Decimal(1).dividedCheckingErrors(by: Decimal(3))
    show("1 / 3 (ограниченная точность)", oneThird)
} catch {
    print(error)
}

do {
    _ = try Decimal(1).dividedCheckingErrors(by: Decimal(0))
} catch {
    print("Ожидаемая ошибка:", error)
}
