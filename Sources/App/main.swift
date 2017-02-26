import Foundation
import Vapor

let drop = Droplet()

let controller = Controller(workDir: drop.workDir, drop.view as! LeafRenderer)

drop.get(String.self) { (request, articleName) in
	return try controller.articlePage(articleUrlName: articleName)
}

drop.get { req in
    return try controller.home()
}

drop.run()
