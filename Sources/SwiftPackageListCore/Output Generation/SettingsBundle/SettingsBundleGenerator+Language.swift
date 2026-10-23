//
//  SettingsBundleGenerator+Language.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 08.04.22.
//

import Foundation

extension SettingsBundleGenerator {
    enum Language: String, CaseIterable {
        case arabic = "ar"
        case chineseSimplified = "zh-Hans"
        case chineseTraditional = "zh-Hant"
        case english = "en"
        case french = "fr"
        case german = "de"
        case hindi = "hi"
        case italian = "it"
        case japanese = "ja"
        case polish = "pl"
        case portuguese = "pt"
        case russian = "ru"
        case spanish = "es"
        case turkish = "tr"
        case ukrainian = "uk"
    }
}

extension SettingsBundleGenerator.Language {
    private enum RootStringsKey: String {
        case acknowledgments = "Acknowledgments"
    }

    private var rootStrings: [RootStringsKey: String] {
        switch self {
        case .arabic:
            return [
                .acknowledgments: "إقرارات",
            ]
        case .chineseSimplified:
            return [
                .acknowledgments: "致谢",
            ]
        case .chineseTraditional:
            return [
                .acknowledgments: "致謝",
            ]
        case .english:
            return [
                .acknowledgments: "Acknowledgments",
            ]
        case .french:
            return [
                .acknowledgments: "Remerciements",
            ]
        case .german:
            return [
                .acknowledgments: "Danksagungen",
            ]
        case .hindi:
            return [
                .acknowledgments: "आभार",
            ]
        case .italian:
            return [
                .acknowledgments: "Ringraziamenti",
            ]
        case .japanese:
            return [
                .acknowledgments: "謝辞"
            ]
        case .polish:
            return [
                .acknowledgments: "Podziękowania",
            ]
        case .portuguese:
            return [
                .acknowledgments: "Agradecimentos",
            ]
        case .russian:
            return [
                .acknowledgments: "Благодарности",
            ]
        case .spanish:
            return [
                .acknowledgments: "Agradecimientos",
            ]
        case .turkish:
            return [
                .acknowledgments: "Teşekkürler",
            ]
        case .ukrainian:
            return [
                .acknowledgments: "Подяки",
            ]
        }
    }
}

extension SettingsBundleGenerator.Language {
    private enum AcknowledgmentsStringsKey: String {
        case licenses = "Licenses"
    }

    private var acknowledgmentsStrings: [AcknowledgmentsStringsKey: String] {
        switch self {
        case .arabic:
            return [
                .licenses: "التراخيص",
            ]
        case .chineseSimplified:
            return [
                .licenses: "许可证",
            ]
        case .chineseTraditional:
            return [
                .licenses: "許可證",
            ]
        case .english:
            return [
                .licenses: "Licenses",
            ]
        case .french:
            return [
                .licenses: "Licences",
            ]
        case .german:
            return [
                .licenses: "Lizenzen",
            ]
        case .hindi:
            return [
                .licenses: "लाइसेंस",
            ]
        case .italian:
            return [
                .licenses: "Licenze",
            ]
        case .japanese:
            return [
                .licenses: "ライセンス"
            ]
        case .polish:
            return [
                .licenses: "Licencje",
            ]
        case .portuguese:
            return [
                .licenses: "Licenças",
            ]
        case .russian:
            return [
                .licenses: "Лицензии",
            ]
        case .spanish:
            return [
                .licenses: "Licencias",
            ]
        case .turkish:
            return [
                .licenses: "Lisanslar",
            ]
        case .ukrainian:
            return [
                .licenses: "Ліцензії",
            ]
        }
    }
}

extension SettingsBundleGenerator.Language {
    var rootFileData: Data {
        let fileString = rootStrings
            .map { "\"\($0.key.rawValue)\" = \"\($0.value)\"" }
            .joined(separator: ";\n")
            .appending(";")
        return Data(fileString.utf8)
    }

    var acknowledgmentsFileData: Data {
        let fileString = acknowledgmentsStrings
            .map { "\"\($0.key.rawValue)\" = \"\($0.value)\"" }
            .joined(separator: ";\n")
            .appending(";")
        return Data(fileString.utf8)
    }
}
