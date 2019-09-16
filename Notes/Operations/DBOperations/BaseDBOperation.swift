import Foundation
import CoreData
import UIKit

class BaseDBOperation: AsyncOperation
{
    let notebook: FileNotebook
    var context: NSManagedObjectContext! {
        didSet
        {
            print("context did set")
        }
    }
    var backgroundContext: NSManagedObjectContext!
    
    init(notebook: FileNotebook)
    {
        self.notebook = notebook
        super.init()
        context = (UIApplication.shared.delegate as! AppDelegate).container.viewContext
        backgroundContext = (UIApplication.shared.delegate as! AppDelegate).container.newBackgroundContext()
    }
}
