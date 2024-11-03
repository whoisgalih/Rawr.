//
//  ScreenshotMapper.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import Foundation
import RealmSwift

final class ScreenshotMapper {
    static func mapScreenshotResponsesToEntities(
        input screenshotsResponse: [ScreenshotResponse]
    ) -> [ScreenshotEntity] {
        return screenshotsResponse.map { result in
            let screenshotEntity = ScreenshotEntity()
            screenshotEntity.id = result.id
            screenshotEntity.image = result.image
            screenshotEntity.width = result.width
            screenshotEntity.height = result.height
            screenshotEntity.isDeleted = result.isDeleted
            return screenshotEntity
        }
    }

    static func mapScreenshotEntitiesToDomains(
        input screenshotEntities: [ScreenshotEntity]
    ) -> [ScreenshotModel] {
        return screenshotEntities.map { result in
            return ScreenshotModel(
                id: result.id,
                image: result.image,
                width: result.width,
                height: result.height,
                isDeleted: result.isDeleted
            )
        }
    }

    static func mapScreenshotResponsesToDomains(
        input screenshotsResponse: [ScreenshotResponse]
    ) -> [ScreenshotModel] {
        return screenshotsResponse.map { result in
            return ScreenshotModel(
                id: result.id,
                image: result.image,
                width: result.width,
                height: result.height,
                isDeleted: result.isDeleted
            )
        }
    }
}
