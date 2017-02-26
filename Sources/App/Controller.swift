//
//  Store.swift
//  Hello
//
//  Created by Marin Bencevic on 17/01/17.
//
//

import Foundation
import Vapor
import cmark_swift

class Controller {
    
    typealias URL = String
    
    
    // MARK: - Setup

	private let workDir: String
	private let renderer: LeafRenderer

	private let fileManager = FileManager()
	private let parser = ArticleParser()

	init(workDir: String, _ renderer: LeafRenderer) {
		self.workDir = workDir
		self.renderer = renderer
	}
    
    
    // MARK: - Public API
    
    /// Fetches an article or a page with the requested url.
    ///
    /// - Parameter articleUrlName: the URL path to the article
    /// - Returns: a HTML `View` generated from a Leaf template
    public func articlePage(articleUrlName: String) throws -> View {
        
        let foundArticle = try articles()
            .filter { $0.urlName == articleUrlName }
            .first
        
        let foundPage = try pages()
            .filter { $0.urlName == articleUrlName }
            .first
        
        if let foundArticle = foundArticle {
            return try articlePage(foundArticle)
        } else if let foundPage = foundPage {
            return try page(foundPage)
        } else {
            throw Abort.notFound
        }
    }
    
    /// Creates the home page.
    ///
    /// - Returns: the homepage HTML `View`
    public func home() throws -> View {
        
        if cachedPages[".."] == nil {
            
            let allArticles = try articles()
            
            let featured = allArticles
                .filter { $0.isFeatured }
                .prefix(4)
            
            let rest = allArticles
                .filter { !$0.isFeatured }
                .sorted { $0.date > $1.date }
            
            cachedPages[".."] = try renderer.make("welcome", [
                "featuredPosts": Node(try featured.map { try $0.makeNode() }),
                "posts": Node(try rest.map { try $0.makeNode() }),
                "navigationLinks": Node(try navigationItems().map { try $0.makeNode() })
                ])
        }
        
        return cachedPages[".."]!
    }
    
    
    // MARK: - Caching data

	private var cachedArticles: [Article] = []
    private var cachedNavigationPages: [Article] = []
	private var cachedPages: [URL: View] = [:]
    
    /// Loads all of the pages in the pages directory and returns them.
    ///
    /// - Returns: all of the pages in the `Resources/Pages` directory
    /// - Note: The pages are cached.
    private func pages() throws -> [Article] {
        
        if cachedPages.isEmpty {
            cachedNavigationPages = try loadAllPages()
        }
        
        return cachedNavigationPages
    }

    
    /// Loads all of the articles in the `Resources/Articles` directory and returns them.
    ///
    /// - Returns: all of the pages in the `Resources/Pages` directory
    /// - Note: The articles are cached.
	private func articles() throws -> [Article] {

		if cachedArticles.isEmpty {
			let articles = try loadAllArticles()
			cachedArticles = articles
		}

		return cachedArticles
	}
    
    /// Returns the items to be displayed in the navbar.
    private func navigationItems() throws -> [[String: String]] {
        return try pages().map { page in
            return [
                "title": page.title,
                "url": page.urlName,
            ]
        }
    }
    
    
    // MARK: - Rendering
    
    /// Renders a HTML `View` for the specified page.
    ///
    /// - Parameter article: the page to render
    /// - Returns: the rendered HTML `View`
    private func page(_ article: Article) throws -> View {
        
        if cachedPages[article.urlName] == nil {
            cachedPages[article.urlName] = try renderer.make(
                "post", [
                    "title": article.title,
                    "content": try markdownToHTML(article.content),
                    "navigationLinks": Node(try navigationItems().map { try $0.makeNode() }),
                ])
        }
        
        return cachedPages[article.urlName]!
    }
    
    /// Renders a HTML `View` for the specified article.
    ///
    /// - Parameter article: the article to render
    /// - Returns: the rendered HTML `View`
	private func articlePage(_ article: Article) throws -> View {
        
        let articles = try self.articles()
        
        var previousArticle: Article?
        var nextArticle: Article?
        
        if let currentArticleIndex = articles.index(of: article) {
            previousArticle = articles[safe: currentArticleIndex - 1]
            nextArticle = articles[safe: currentArticleIndex + 1]
        }
        
        let featuredArticles: [Node] = [previousArticle, nextArticle]
            .flatMap { $0 }
            .map { article in
                return Node([
                        "title": Node(article.title),
                        "url": Node(article.urlName)
                    ])
            }

		if cachedPages[article.urlName] == nil {
			cachedPages[article.urlName] = try renderer.make(
                "post", [
					"title": article.title,
					"content": try markdownToHTML(article.content),
                    "navigationLinks": Node(try navigationItems().map { try $0.makeNode() }),
                    "featuredArticles": Node(featuredArticles),
				])
		}
        
		return cachedPages[article.urlName]!
	}
    
    
    // MARK: - File system
    
    private func loadAllPages() throws -> [Article] {
        
        let path = workDir + "/Resources/Pages/"
        return try getArticles(fromPath: path)
    }
    
    private func loadAllArticles() throws -> [Article] {
        
        let path = workDir + "/Resources/Posts/"
        return try getArticles(fromPath: path)
    }
    
    private func getArticles(fromPath path: String) throws -> [Article] {
        
        guard let directory = fileManager.enumerator(atPath: path) else {
            return []
        }
        
        return try directory.flatMap { file-> Article? in
            
            guard let file = file as? String, file.hasSuffix(".md") else {
                return nil
            }
            
            let contents = try String(contentsOfFile: path + file, encoding: .utf8)
            
            return try parser.parse(articleFile: contents, filePath: path, fileName: file)
        }
    }

}
