# Swift `Decimal`: практика, окружение и ручная сборка

Этот каталог - готовый Swift Package. Он содержит библиотеку `DecimalKit`,
консольный пример `DecimalLab` и сценарий ручной сборки.

## 1. Структура проекта

```text
work1/
├── Package.swift
├── report.md
├── build_manual.sh
└── Sources/
    ├── DecimalKit/DecimalTools.swift
    └── DecimalLab/main.swift
```

## 2. Что такое `Decimal`

`Decimal` - структура из `Foundation` для чисел с основанием 10. Часто используется
для денег, процентов и данных, где десятичные дроби должны вести себя
предсказуемо. Реализация дает не менее 38 десятичных цифр точности.

Для работы нужен импорт:

```swift
import Foundation
```

### Создание значений

Из целого числа:

```swift
let count = Decimal(42)
```

Из строки с явной локалью:

```swift
let price = Decimal(
    string: "19.99",
    locale: Locale(identifier: "en_US_POSIX")
)!
```

Для машинных данных и денег строка предпочтительнее промежуточного `Double`.
Если сначала выполнить выражение как `Double`, его двоичная погрешность
попадет в `Decimal`:

```swift
let inaccurate = Decimal(0.1 + 0.2) // 0.3000000000000000512
let exact = Decimal(string: "0.3", locale: Locale(identifier: "en_US_POSIX"))!

print(inaccurate == exact) // false
```

Сам `Decimal` поддерживает обычные операторы:

```swift
let subtotal = price * Decimal(3)
let tax = subtotal * Decimal(string: "0.20")!
let total = subtotal + tax
```

### Округление

Операторы не превращают значение автоматически в значение с необходимым
числом знаков после запятой. Округлять следует явно до необходимого числа
после запятой. В проекте есть метод `rounded(scale:mode:)`,
внутри которого используется `NSDecimalRound`:

```swift
let value = Decimal(string: "2.345")!

value.rounded(scale: 2, mode: .plain)   // 2.35
value.rounded(scale: 2, mode: .bankers) // 2.34
value.rounded(scale: 2, mode: .down)    // 2.34
value.rounded(scale: 2, mode: .up)      // 2.35
```

- `.plain` — к ближайшему; на середине округляется в ближайшую от нуля.
- `.bankers` — к ближайшему; на середине округляется к ближайшему четному.
- `.down` — в сторону меньшего.
- `.up` — в сторону большего.

### Локаль и отображение

Парсинг пользовательского ввода зависит от локали:

```swift
let locale = Locale(identifier: "ru_RU")
let amount = Decimal(string: "1234,56", locale: locale)!
let text = amount.formatted(.currency(code: "RUB").locale(locale))
// Например: 1 234,56 ₽
```

`Decimal` хранит число, его отображение зависит от выбора локали. Например, `9.20` и `9.2`

- одно числовое значение; два знака после запятой задаются при форматировании.

### Ошибки вычислений

Операторы удобны, но низкоуровневые функции `NSDecimalAdd`,
`NSDecimalMultiply`, `NSDecimalDivide` и другие возвращают
`NSDecimalNumber.CalculationError`. Это позволяет явно обнаружить деление на
ноль, переполнение и потерю точности. В `DecimalTools.swift` показана обертка
`dividedCheckingErrors(by:)`.

Главные практические правила:

1. Парсить деньги из строки с явно заданной локалью.
2. Не вычислять исходное значение в `Double` перед преобразованием в `Decimal`.
3. Явно определить масштаб и режим округления.
4. Форматировать только на границе UI/отчета.
5. Для критичных вычислений проверять `CalculationError` и граничные значения.

## 3. Установка окружения

### Вариант A: Command Line Tools

Подходит для консольных программ и Swift Package Manager:

```bash
xcode-select --install
```

После завершения установки:

```bash
xcode-select -p
xcrun --find swift
xcrun swift --version
xcrun --show-sdk-path
```

### Вариант B: Xcode

Используется для iOS/macOS GUI-приложений, симуляторов, подписывания и полного
набора Apple-инструментов. Необходимо установить Xcode, а затем выбрать
его toolchain:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
xcrun swift --version
xcrun --show-sdk-path
```

### Вариант C: несколько версий Swift

Официальный менеджер `swiftly` используется, когда проектам нужны разные toolchain.
После установки пакета `swiftly` по инструкции из Swift.org:

```bash
~/.swiftly/bin/swiftly init
swiftly install --use 6.3
swift --version
```

## 4. Сборка через Swift Package Manager

Из каталога `work1`:

```bash
swift build
swift run DecimalLab
```

Release-сборка и путь к готовым бинарникам:

```bash
swift build -c release
swift build -c release --show-bin-path
```

Полезные флаги SwiftPM:

| Флаг                   | Назначение                                                                         |
| ---------------------- | ---------------------------------------------------------------------------------- |
| `-c debug`             | Отладочная сборка; это значение по умолчанию.                                      |
| `-c release`           | Оптимизированная сборка.                                                           |
| `--product DecimalLab` | Собрать один продукт.                                                              |
| `--target DecimalKit`  | Собрать одну цель пакета.                                                          |
| `-v` / `--verbose`     | Показать запускаемые команды; полезно для изучения сборки.                         |
| `--show-bin-path`      | Вывести каталог результатов.                                                       |
| `--scratch-path PATH`  | Перенести рабочий каталог вместо `.build`.                                         |
| `--triple TRIPLE`      | Задать целевую платформу/архитектуру.                                              |
| `--sdk PATH`           | Явно выбрать SDK. Обычно это делает `xcrun`.                                       |
| `--disable-sandbox`    | Отключить песочницу SwiftPM; применять только при диагностированной необходимости. |

## 5. Ручная сборка через `swiftc`

### Что происходит

```text
.swift → разбор и проверка типов → SIL → LLVM IR → объектные файлы → линкер → Mach-O
```

SwiftPM автоматизирует эти этапы. В ручном режиме мы сами определяем модуль,
пути поиска и параметры линкера.

### build_manual.sh

Для сборки и запуска реализован скрипт `./build_manual.sh`. Он производт сборку 2
модулей: библиотеки и executable файла.

Сначала библиотека и файл Swift-модуля:

```bash
xcrun swiftc Sources/DecimalKit/DecimalTools.swift \
  -parse-as-library \
  -emit-library \
  -emit-module \
  -module-name DecimalKit \
  -emit-module-path .manual-build/DecimalKit.swiftmodule \
  -o .manual-build/libDecimalKit.dylib \
  -Onone -g \
  -Xlinker -install_name \
  -Xlinker @rpath/libDecimalKit.dylib
```

Затем программа, которая импортирует библиотеку:

```bash
xcrun swiftc Sources/DecimalLab/main.swift \
  -I .manual-build \
  -L .manual-build \
  -lDecimalKit \
  -o .manual-build/DecimalLab \
  -Onone -g \
  -Xlinker -rpath \
  -Xlinker @executable_path
```

Готовый сценарий:

```bash
chmod +x build_manual.sh
./build_manual.sh
CONFIGURATION=release ./build_manual.sh
```

### Главные флаги `swiftc`

| Флаг                                      | За что отвечает                                                              |
| ----------------------------------------- | ---------------------------------------------------------------------------- |
| `-emit-executable`                        | Скомпилировать и слинковать исполняемый файл.                                |
| `-emit-library`                           | Слинковать библиотеку (`.dylib` на macOS); вместе с `-static` — статическую. |
| `-emit-module`                            | Создать импортируемый `.swiftmodule`.                                        |
| `-emit-module-path PATH`                  | Явно задать путь файла модуля.                                               |
| `-module-name NAME`                       | Задать имя модуля, используемое в `import`.                                  |
| `-parse-as-library`                       | Не трактовать исходник как скрипт с top-level кодом.                         |
| `-c` / `-emit-object`                     | Остановиться на объектном файле, не выполнять линковку.                      |
| `-o PATH`                                 | Имя основного результата.                                                    |
| `-I PATH`                                 | Каталог поиска Swift/C-модулей.                                              |
| `-L PATH`                                 | Каталог поиска библиотек.                                                    |
| `-lNAME`                                  | Линковать `libNAME.dylib` или `libNAME.a`.                                   |
| `-F PATH` / `-framework NAME`             | Найти и подключить Apple framework.                                          |
| `-Onone`                                  | Без оптимизации, удобно для отладки.                                         |
| `-O`                                      | Оптимизация производительности.                                              |
| `-swift-version 6`                        | Выбрать режим языка, а не конкретную версию компилятора.                     |
| `-warnings-as-errors`                     | Считать предупреждения ошибками.                                             |
| `-suppress-warnings`                      | Скрыть предупреждения.                                                       |
| `-target TRIPLE`                          | Выбрать архитектуру, ОС и минимальную версию ОС.                             |
| `-sdk PATH`                               | Выбрать SDK. На macOS предпочтительно вызывать через `xcrun`.                |
| `-Xlinker ARG`                            | Передать параметр системному линкеру.                                        |
| `-typecheck`                              | Только разобрать и проверить типы.                                           |
| `-emit-sil`, `-emit-ir`, `-emit-assembly` | Остановиться на соответствующем промежуточном представлении.                 |
| `-save-temps`                             | Сохранить промежуточные результаты для исследования.                         |

Официальные материалы:

- Decimal: https://developer.apple.com/documentation/foundation/decimal
- Округление: https://developer.apple.com/documentation/foundation/nsdecimalround(_:_:_:_:)
- Command Line Tools: https://developer.apple.com/documentation/xcode/installing-the-command-line-tools
- SwiftPM tutorial: https://www.swift.org/getting-started/library-swiftpm/
- swiftly для macOS: https://www.swift.org/install/macos/swiftly/
