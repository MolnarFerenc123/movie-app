//
//  CombinedMediaItem.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 28..
//


struct CombinedMediaItem{
    let mediaItem: MediaItem
    let originalTitle: String
    let showType: MediaItemType
    let character: String

    init(mediaItem: MediaItem, originalTitle: String, showType: MediaItemType, character: String) {
        self.mediaItem = mediaItem
        self.originalTitle = originalTitle
        self.showType = showType
        self.character = character
    }

    init(dto: CombinedMediaItemResponse){
        self.mediaItem = MediaItem(dto: dto)
        switch dto.mediaType{
        case "movie":
            self.showType = .movie
        case "tv":
            self.showType = .tv
        default:
            self.showType = .movie
        }
        self.character = dto.character
        self.originalTitle = dto.originalTitle ?? dto.originalName ?? "N/A"
    }
}
