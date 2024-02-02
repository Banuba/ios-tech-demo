//
//  DeepLinkParser.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 22.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

enum DeepLinkRoute: Equatable {
    case technology(id: String)
    case category(id: String, technologyId: String)
}

final class DeepLinkParser {
    class func deepLinkRoute(from url: URL) -> DeepLinkRoute? {
        guard let components = URLComponents(string: url.absoluteString),
              components.path == "/open",
              let queryItems = components.queryItems else { return nil }
        let technologyKey = "technology"
        let categoryKey = "category"
        
        if queryItems.count == 1,
            let techParameter = queryItems.first,
            techParameter.name == technologyKey,
            let value = techParameter.value {
            return .technology(id: value)
        }
        if queryItems.count == 2,
           let techId = queryItems.first(where: { $0.name == technologyKey })?.value,
           let categoryId = queryItems.first(where: { $0.name == categoryKey })?.value {
            return .category(id: categoryId, technologyId: techId)
        }
        return nil
    }
}
