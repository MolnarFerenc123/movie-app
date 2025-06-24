//
//  EditFavoritResult.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 13..
//

struct ModifyMediaResult {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    init(dto: ModifyMediaResponse){
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
