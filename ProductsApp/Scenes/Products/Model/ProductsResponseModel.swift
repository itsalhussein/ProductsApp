//
//  ProductsResponseModel.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//


import Foundation
struct ProductsResponseModel : Codable {
    let id : Int?
    let productDescription : String?
    let image : Image?
    let price : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case productDescription = "productDescription"
        case image = "image"
        case price = "price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        productDescription = try values.decodeIfPresent(String.self, forKey: .productDescription)
        image = try values.decodeIfPresent(Image.self, forKey: .image)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
    }

}

struct Image : Codable {
    let width : Int?
    let height : Int?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case width = "width"
        case height = "height"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}
