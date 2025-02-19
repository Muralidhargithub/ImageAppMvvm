//
//  Photo.swift
//  ImageAppMvvm
//
//  Created by Muralidhar reddy Kakanuru on 12/9/24.
//


import Foundation

struct Photo: Codable, Identifiable {
    let albumId: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}


