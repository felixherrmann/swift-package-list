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
        case czech = "cs"
        case danish = "da"
        case dutch = "nl"
        case english = "en"
        case englishBritish = "en-GB"
        case finnish = "fi"
        case french = "fr"
        case german = "de"
        case hindi = "hi"
        case indonesian = "id"
        case italian = "it"
        case japanese = "ja"
        case korean = "ko"
        case norwegianBokmal = "nb"
        case polish = "pl"
        case portuguese = "pt"
        case russian = "ru"
        case spanish = "es"
        case swedish = "sv"
        case turkish = "tr"
        case ukrainian = "uk"
        case vietnamese = "vi"
    }
}

extension SettingsBundleGenerator.Language {
    private enum RootStringsKey: String {
        case acknowledgmentsTitle = "SPL_ACKNOWLEDGMENTS_TITLE"
    }

    private var rootStrings: [RootStringsKey: String] {
        switch self {
        case .arabic:
            return [
                .acknowledgmentsTitle: "إقرارات",
            ]
        case .chineseSimplified:
            return [
                .acknowledgmentsTitle: "致谢",
            ]
        case .chineseTraditional:
            return [
                .acknowledgmentsTitle: "致謝",
            ]
        case .czech:
            return [
                .acknowledgmentsTitle: "Poděkování",
            ]
        case .danish:
            return [
                .acknowledgmentsTitle: "Tak",
            ]
        case .dutch:
            return [
                .acknowledgmentsTitle: "Dankbetuigingen",
            ]
        case .english:
            return [
                .acknowledgmentsTitle: "Acknowledgments",
            ]
        case .englishBritish:
            return [
                .acknowledgmentsTitle: "Acknowledgements",
            ]
        case .finnish:
            return [
                .acknowledgmentsTitle: "Kiitokset",
            ]
        case .french:
            return [
                .acknowledgmentsTitle: "Remerciements",
            ]
        case .german:
            return [
                .acknowledgmentsTitle: "Danksagungen",
            ]
        case .hindi:
            return [
                .acknowledgmentsTitle: "आभार",
            ]
        case .indonesian:
            return [
                .acknowledgmentsTitle: "Ucapan Terima Kasih",
            ]
        case .italian:
            return [
                .acknowledgmentsTitle: "Ringraziamenti",
            ]
        case .japanese:
            return [
                .acknowledgmentsTitle: "謝辞"
            ]
        case .korean:
            return [
                .acknowledgmentsTitle: "감사의 말",
            ]
        case .norwegianBokmal:
            return [
                .acknowledgmentsTitle: "Takk",
            ]
        case .polish:
            return [
                .acknowledgmentsTitle: "Podziękowania",
            ]
        case .portuguese:
            return [
                .acknowledgmentsTitle: "Agradecimentos",
            ]
        case .russian:
            return [
                .acknowledgmentsTitle: "Благодарности",
            ]
        case .spanish:
            return [
                .acknowledgmentsTitle: "Agradecimientos",
            ]
        case .swedish:
            return [
                .acknowledgmentsTitle: "Tack",
            ]
        case .turkish:
            return [
                .acknowledgmentsTitle: "Teşekkürler",
            ]
        case .ukrainian:
            return [
                .acknowledgmentsTitle: "Подяки",
            ]
        case .vietnamese:
            return [
                .acknowledgmentsTitle: "Lời cảm ơn",
            ]
        }
    }
}

extension SettingsBundleGenerator.Language {
    private enum AcknowledgmentsStringsKey: String {
        case acknowledgmentsSectionTitle = "SPL_ACKNOWLEDGMENTS_SECTION_TITLE"
    }

    private var acknowledgmentsStrings: [AcknowledgmentsStringsKey: String] {
        switch self {
        case .arabic:
            return [
                .acknowledgmentsSectionTitle: "التراخيص",
            ]
        case .chineseSimplified:
            return [
                .acknowledgmentsSectionTitle: "许可证",
            ]
        case .chineseTraditional:
            return [
                .acknowledgmentsSectionTitle: "許可證",
            ]
        case .czech:
            return [
                .acknowledgmentsSectionTitle: "Licence",
            ]
        case .danish:
            return [
                .acknowledgmentsSectionTitle: "Licenser",
            ]
        case .dutch:
            return [
                .acknowledgmentsSectionTitle: "Licenties",
            ]
        case .english:
            return [
                .acknowledgmentsSectionTitle: "Licenses",
            ]
        case .englishBritish:
            return [
                .acknowledgmentsSectionTitle: "Licences",
            ]
        case .finnish:
            return [
                .acknowledgmentsSectionTitle: "Lisenssit",
            ]
        case .french:
            return [
                .acknowledgmentsSectionTitle: "Licences",
            ]
        case .german:
            return [
                .acknowledgmentsSectionTitle: "Lizenzen",
            ]
        case .hindi:
            return [
                .acknowledgmentsSectionTitle: "लाइसेंस",
            ]
        case .indonesian:
            return [
                .acknowledgmentsSectionTitle: "Lisensi",
            ]
        case .italian:
            return [
                .acknowledgmentsSectionTitle: "Licenze",
            ]
        case .japanese:
            return [
                .acknowledgmentsSectionTitle: "ライセンス"
            ]
        case .korean:
            return [
                .acknowledgmentsSectionTitle: "라이선스",
            ]
        case .norwegianBokmal:
            return [
                .acknowledgmentsSectionTitle: "Lisenser",
            ]
        case .polish:
            return [
                .acknowledgmentsSectionTitle: "Licencje",
            ]
        case .portuguese:
            return [
                .acknowledgmentsSectionTitle: "Licenças",
            ]
        case .russian:
            return [
                .acknowledgmentsSectionTitle: "Лицензии",
            ]
        case .spanish:
            return [
                .acknowledgmentsSectionTitle: "Licencias",
            ]
        case .swedish:
            return [
                .acknowledgmentsSectionTitle: "Licenser",
            ]
        case .turkish:
            return [
                .acknowledgmentsSectionTitle: "Lisanslar",
            ]
        case .ukrainian:
            return [
                .acknowledgmentsSectionTitle: "Ліцензії",
            ]
        case .vietnamese:
            return [
                .acknowledgmentsSectionTitle: "Giấy phép",
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
