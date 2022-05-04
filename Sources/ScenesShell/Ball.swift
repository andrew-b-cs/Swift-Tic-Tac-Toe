import Igis
import Scenes
import Foundation

class Ball : RenderableEntity, EntityMouseClickHandler {
    var currentPlayer = "X"
    var playerScale = 10
    var xPlayer : Image
    var yPlayer : Image
    var clearingBox : Image
    var background : Background?

    init() {
        // Using a meaningful name can be helpful for debugging
        guard let clearingBoxUrl = URL(string:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs7JymjngWBlKUaY4qul9pyUsfHOoL2Dm6hoShqOU4v92tmLNBV4bz5Quim8x4qKMygas&usqp=CAU") else {
            fatalError("Failed to crate URL")
        }
        
        guard let xPlayerUrl = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Letter_x.svg/1200px-Letter_x.svg.png") else {
            fatalError("Failed to crate URL")
        }

        guard let yPlayerUrl = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Letter_o.svg/1085px-Letter_o.svg.png") else {
            fatalError("Failed to crate URL")
        }
        
        xPlayer = Image(sourceURL:xPlayerUrl)
        yPlayer = Image(sourceURL:yPlayerUrl)
        clearingBox = Image(sourceURL:clearingBoxUrl)
        
        super.init(name:"Ball")
    }

    func setBackground(layer:Background) {
        self.background = layer
    }

    //if let backgrond = background {}
    
    override func setup(canvasSize: Size, canvas: Canvas) {
       
        canvas.setup(xPlayer)
        canvas.setup(yPlayer)
        canvas.setup(clearingBox)

        clearingBox.renderMode = .destinationRect(Rect(topLeft:Point(x:10, y:10), size:Size(width:210, height:210)))
        xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:90, y:30), size:Size(width:1200/playerScale, height:2160/playerScale)))
        yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:-1000, y:0), size:Size(width:1200/playerScale, height:2160/playerScale)))
     
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas:Canvas) {
        if let background = background {
            print(background.getX())
        }
        
        if clearingBox.isReady {
            canvas.render(clearingBox)
        }
        
        if xPlayer.isReady {
            canvas.render(xPlayer)
        }

        if yPlayer.isReady {
            canvas.render(yPlayer)
        }
    }

    
    
    func onEntityMouseClick(globalLocation: Point) {
       
        
        if (currentPlayer == "X") {
            currentPlayer = "O"
            
            xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:globalLocation.x - (1200/playerScale)/2, y:globalLocation.y - ((2160/playerScale)/2)), size:Size(width:1200/playerScale, height:2160/playerScale)))
            
            //show who's turn it is to go
            yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:90, y:30), size:Size(width:1200/playerScale, height:2160/playerScale)))
            
        } else {
            
            currentPlayer = "X"

            
            yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:globalLocation.x -  (1200/playerScale)/2, y:globalLocation.y - ((2160/playerScale)/2)), size:Size(width:1200/playerScale, height:2160/playerScale)))
            
            //show who's turn it is to go 
            xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:90, y:30), size:Size(width:1200/playerScale, height:2160/playerScale)))
            
        }
        
    }

    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
}
