//
//  Article.swift
//  Hello
//
//  Created by Marin Bencevic on 17/01/17.
//
//

import Foundation
import Vapor

struct Article: NodeRepresentable {

	let title: String
	let filePath: String
	let urlName: String
	let date: Date
	let formattedDate: String
	let content: String
	let isFeatured: Bool

	func makeNode(context: Context) throws -> Node {
		return [
			"title": Node(title),
			"date": Node(formattedDate),
			"content": Node(content),
			"url": Node(urlName)
		]
	}
}


extension Article: Equatable {
    
    static func ==(lhs: Article, rhs: Article)-> Bool {
        return lhs.urlName == rhs.urlName
    }
    
}
