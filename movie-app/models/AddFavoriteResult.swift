//
//  Genre.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 08..
//

struct AddFavoriteResult: Hashable, Equatable {
    let success : Bool
    let statusCode : Int
    let statusMessage : String
    
    init(success: Bool, statusCode : Int, statusMessage : String) {
        self.success = success
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
    
    init(dto: AddFavoriteResponse) {
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
