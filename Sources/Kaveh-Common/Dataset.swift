import SwiftUI

// MARK: - Models

/// Represents a downloadable dataset with metadata and download state.
public class Dataset: Identifiable, ObservableObject, Codable {
    /// Unique identifier for the dataset.
    public var id = UUID()
    /// The type of the dataset (e.g., "ip", "domain").
    var type: String = ""
    /// The name of the dataset.
    var name: String = ""
    /// The URL from which the dataset can be downloaded.
    var url: String = ""
    /// Whether the dataset is currently being downloaded.
    @Published var isDownloading: Bool = false
    /// Whether the dataset has been downloaded.
    @Published var isDownloaded: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, type, name, url
    }
    
    /// Decodes a Dataset from a decoder.
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        _isDownloading = Published(initialValue: false)
        _isDownloaded = Published(initialValue: FileManager.default.fileExists(atPath: filePath.path))
    }
    
    /// Encodes the Dataset to an encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }
    
    /// Creates a new Dataset instance.
    /// - Parameters:
    ///   - type: The type of the dataset.
    ///   - name: The name of the dataset.
    ///   - url: The download URL for the dataset.
    init(type: String, name: String, url: String) {
        self.type = type
        self.name = name
        self.url = url
        _isDownloaded = Published(initialValue: FileManager.default.fileExists(atPath: filePath.path))
    }
    
    /// The file path where the dataset is stored locally.
    var filePath: URL {
        Common.datasetsPath.appendingPathComponent("\(name).dat")
    }
    
    /// Downloads the dataset asynchronously.
    func download() async  {
        guard let url = URL(string: self.url) else {
            return
        }
        await MainActor.run {
            isDownloading = true
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            try data.write(to: filePath)
            await MainActor.run {
               self.isDownloaded = true
            }
        } catch {
            print("download error: \(error)")
        }
        await MainActor.run {
            isDownloading = false
        }
    }
    
    /// Deletes the dataset file from disk.
    func delete() throws {
        if isDownloaded {
            try FileManager.default.removeItem(at: filePath)
            isDownloaded = false
        }
    }
    
    /// Checks if the dataset file exists locally.
    /// - Returns: `true` if the file exists, `false` otherwise.
    func hasFile() -> Bool {
        FileManager.default.fileExists(atPath: filePath.path)
    }
}

/// Represents geolocation data with category and rule counts.
public struct GeoData: Codable {
    /// The number of categories in the data.
    let categoryCount: Int
    /// The number of rules in the data.
    let ruleCount: Int
    /// The list of geolocation data rows.
    let codes: [GeoDataRow]
    
    /// Creates a new GeoData instance.
    /// - Parameters:
    ///   - categoryCount: The number of categories.
    ///   - ruleCount: The number of rules.
    ///   - codes: The geolocation data rows.
    init(categoryCount: Int = 0, ruleCount: Int = 0, codes: [GeoDataRow] = []) {
        self.categoryCount = categoryCount
        self.ruleCount = ruleCount
        self.codes = codes
    }
}

/// Represents a single row of geolocation data.
public struct GeoDataRow: Codable {
    /// The code for the geolocation entry.
    let code: String
    /// The number of rules for this code.
    let ruleCount: Int
}

/// Manages a collection of datasets and their persistence.
public class DatasetsManager: ObservableObject {
    
  @MainActor static var shared: DatasetsManager = .init()
    
    /// The list of datasets managed by this instance.
    @Published var datasets: [Dataset] = []
    /// The user defaults key for storing datasets.
    private let userDefaultsKey = "datasets"
    
    /// Creates a new DatasetsManager and loads datasets from storage.
    init() {
        loadDatasets()
    }
    
    /// Loads datasets from user defaults.
    func loadDatasets() {
      if let savedData = UserDefaults(suiteName: Common.groupName)!.data(
        forKey: userDefaultsKey
      ),
           let decodedDatasets = try? JSONDecoder().decode([Dataset].self, from: savedData) {
            datasets = decodedDatasets
        }
        if !datasets.contains(where: { $0.name == "geoip" }) {
            //datasets.append(Dataset(type: "ip", name: "geoip", url: "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"))
        }
        if !datasets.contains(where: { $0.name == "geosite" }) {
           // datasets.append(Dataset(type: "domain", name: "geosite", url: "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat"))
        }
    }
    
    /// Saves the current datasets to user defaults.
    func saveDatasets() {
        if let encoded = try? JSONEncoder().encode(datasets) {
          UserDefaults(suiteName: Common.groupName)!
            .set(encoded, forKey: userDefaultsKey)
        }
    }
    
    /// Updates all datasets by downloading them asynchronously.
    func updateAllDatasets() async {
        await withTaskGroup(of: Void.self) { group in
            for dataset in datasets {
                group.addTask {
                    await dataset.download()
                }
            }
        }
    }
    
    /// Deletes all dataset files from disk.
    func deleteAllFiles() {
        for dataset in datasets {
            try? dataset.delete()
        }
    }

    /// Validates that all required datasets are present and downloaded.
    /// - Returns: `true` if all required datasets are downloaded, `false` otherwise.
    func validateRequiredDatasets() -> Bool {
        let requiredFiles = ["geoip", "geosite"]
        let downloadedFiles = datasets.filter { dataset in
            requiredFiles.contains(dataset.name) && dataset.hasFile()
        }
        return downloadedFiles.count == requiredFiles.count
    }
}
