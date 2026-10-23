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
        case acknowledgements = "Acknowledgements"
    }

    private var rootStrings: [RootStringsKey: String] {
        switch self {
        case .arabic:
            return [
                .acknowledgements: "إقرارات",
            ]
        case .chineseSimplified:
            return [
                .acknowledgements: "致谢",
            ]
        case .chineseTraditional:
            return [
                .acknowledgements: "致謝",
            ]
        case .english:
            return [
                .acknowledgements: "Acknowledgments",
            ]
        case .french:
            return [
                .acknowledgements: "Remerciements",
            ]
        case .german:
            return [
                .acknowledgements: "Danksagungen",
            ]
        case .hindi:
            return [
                .acknowledgements: "आभार",
            ]
        case .italian:
            return [
                .acknowledgements: "Ringraziamenti",
            ]
        case .japanese:
            return [
                .acknowledgements: "謝辞"
            ]
        case .polish:
            return [
                .acknowledgements: "Podziękowania",
            ]
        case .portuguese:
            return [
                .acknowledgements: "Agradecimentos",
            ]
        case .russian:
            return [
                .acknowledgements: "Благодарности",
            ]
        case .spanish:
            return [
                .acknowledgements: "Agradecimientos",
            ]
        case .turkish:
            return [
                .acknowledgements: "Teşekkürler",
            ]
        case .ukrainian:
            return [
                .acknowledgements: "Подяки",
            ]
        }
    }
}

extension SettingsBundleGenerator.Language {
    private enum AcknowledgementsStringsKey: String {
        case licenses = "Licenses"
    }

    private var acknowledgementsStrings: [AcknowledgementsStringsKey: String] {
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

    var acknowledgementsFileData: Data {
        let fileString = acknowledgementsStrings
            .map { "\"\($0.key.rawValue)\" = \"\($0.value)\"" }
            .joined(separator: ";\n")
            .appending(";")
        return Data(fileString.utf8)
    }
}
