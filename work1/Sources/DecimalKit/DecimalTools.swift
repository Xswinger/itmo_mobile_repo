import Foundation

public enum DecimalInputError: Error, Equatable, CustomStringConvertible {
    case invalidNumber(String)

    public var description: String {
        switch self {
        case let .invalidNumber(text):
            return "Не удалось преобразовать \"\(text)\" в Decimal"
        }
    }
}

public enum DecimalCalculationError: Error, Equatable, CustomStringConvertible {
    case calculation(NSDecimalNumber.CalculationError)

    public var description: String {
        switch self {
        case let .calculation(error):
            return "Ошибка decimal-вычисления: \(error)"
        }
    }
}

public extension Decimal {

    /// Парсит число с точкой в качестве десятичного разделителя
    static func exact(_ text: String) throws -> Decimal {
        guard let value = Decimal(
            string: text,
            locale: Locale(identifier: "en_US_POSIX")
        ) else {
            throw DecimalInputError.invalidNumber(text)
        }
        return value
    }

    /// Округляет до количества знаков после десятичной точки
    func rounded(
        scale: Int,
        mode: NSDecimalNumber.RoundingMode = .bankers
    ) -> Decimal {
        var source = self
        var result = Decimal()
        NSDecimalRound(&result, &source, scale, mode)
        return result
    }

    /// Делит с явной проверкой ошибки Foundation вместо NaN
    func dividedCheckingErrors(
        by divisor: Decimal,
        mode: NSDecimalNumber.RoundingMode = .bankers
    ) throws -> Decimal {
        var lhs = self
        var rhs = divisor
        var result = Decimal()
        let error = NSDecimalDivide(&result, &lhs, &rhs, mode)

        guard error == .noError else {
            throw DecimalCalculationError.calculation(error)
        }
        return result
    }
}
