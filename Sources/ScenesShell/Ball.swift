import Igis
import Scenes
import Foundation

class Ball : RenderableEntity, EntityMouseClickHandler {
    //var activePlayer = "X" //Cross
    var playerScale = 10
    var xPlayer : Image
    var yPlayer : Image
    var clearingBox : Image
    var background : Background?

    var lineWidth : Int
    var gridSpace : Int
    var xPos : Int
    var yPos : Int
    var placeAllowed = true
    
    var count = 1
    var activePlayer = 1 //Cross
    var gameState = [0,0,0,0,0,0,0,0,0]
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

    var gameIsActive = true
    
    var quadrantPoint = Point(x:0, y:0)
    
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

        

        lineWidth = 0
        gridSpace = 0
        xPos = 0
        yPos = 0
        
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

        clearingBox.renderMode = .destinationRect(Rect(topLeft:Point(x:0, y:0), size:Size(width:500, height:500)))
        xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:120, y:30), size:Size(width:1200/6, height:2160/6)))
        yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:-1000, y:0), size:Size(width:1200/6, height:2160/6)))
     
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas:Canvas) {
     
        
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
        
        if let background = background {
            lineWidth = background.getLineWidth()
            gridSpace = background.getGridSpace()
            xPos = background.getX()
            yPos = background.getY()
        }

        let clickPoint = Point(x:globalLocation.x - (1200/playerScale)/2, y:globalLocation.y - ((2160/playerScale)/2))
        
        if clickPoint.x < xPos + gridSpace - lineWidth*3 && clickPoint.y < yPos + gridSpace/2 + lineWidth {
            quadrantPoint.x = xPos + gridSpace/4
            quadrantPoint.y = yPos + gridSpace/8
           
            if gameState[0] == 0{
                gameState[0] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 2) - lineWidth*2 && clickPoint.y < yPos + gridSpace/2 + lineWidth {
            quadrantPoint.x = xPos + gridSpace + gridSpace/4 + lineWidth
            quadrantPoint.y = yPos + gridSpace/8
           
            if gameState[1] == 0{
                gameState[1] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 3) - lineWidth*2  && clickPoint.y < yPos + gridSpace/2 + lineWidth{
            quadrantPoint.x = xPos + gridSpace*2 + gridSpace/4 + lineWidth*2
            quadrantPoint.y = yPos + gridSpace/8

            if gameState[2] == 0{
                gameState[2] = activePlayer
            } else {
                placeAllowed = false
            }
           
        }
        //--------------
        else if clickPoint.x < xPos + gridSpace - lineWidth*3 && clickPoint.y < yPos + gridSpace/2 + lineWidth*2 + gridSpace {
            quadrantPoint.x = xPos + gridSpace/4
            quadrantPoint.y = yPos + gridSpace + gridSpace/8
           
            if gameState[3] == 0{
                gameState[3] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 2) - lineWidth*2 && clickPoint.y < yPos + gridSpace/2 + lineWidth*2 + gridSpace {
            quadrantPoint.x = xPos + gridSpace + gridSpace/4 + lineWidth
            quadrantPoint.y = yPos + gridSpace + gridSpace/8
           
            if gameState[4] == 0{
                gameState[4] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 3) - lineWidth*2  && clickPoint.y < yPos + gridSpace/2 + lineWidth*2 + gridSpace {
            quadrantPoint.x = xPos + gridSpace*2 + gridSpace/4 + lineWidth*2
            quadrantPoint.y = yPos + gridSpace + gridSpace/8
            
            if gameState[5] == 0{
                gameState[5] = activePlayer
            } else {
                placeAllowed = false
            }
        }
        //--------------
        else if clickPoint.x < xPos + gridSpace - lineWidth*3 && clickPoint.y < yPos + gridSpace/2 + lineWidth*3 + gridSpace*2 {
            quadrantPoint.x = xPos + gridSpace/4
            quadrantPoint.y = yPos + gridSpace*2 + gridSpace/8 + lineWidth

            if gameState[6] == 0{
                gameState[6] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 2) - lineWidth*2 && clickPoint.y < yPos + gridSpace/2 + lineWidth*3 + gridSpace*2 {
            quadrantPoint.x = xPos + gridSpace + gridSpace/4 + lineWidth
            quadrantPoint.y = yPos + gridSpace*2 + gridSpace/8 + lineWidth

            if gameState[7] == 0{
                gameState[7] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 3) - lineWidth*2  && clickPoint.y < yPos + gridSpace/2 + lineWidth*3 + gridSpace*2 {
            quadrantPoint.x = xPos + gridSpace*2 + gridSpace/4 + lineWidth*2
            quadrantPoint.y = yPos + gridSpace*2 + gridSpace/8 + lineWidth

            if gameState[8] == 0{
                gameState[8] = activePlayer
            } else {
                placeAllowed = false
            }
            
        }

        
        
        if (activePlayer == 1 && placeAllowed) {
            activePlayer = 2
            
            xPlayer.renderMode = .destinationRect(Rect(topLeft:quadrantPoint, size:Size(width:1200/playerScale, height:2160/playerScale)))
            
            //show who's turn it is to go
            yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:120, y:30), size:Size(width:1200/6, height:2160/6)))
            
        } else if(placeAllowed) {
            
            activePlayer = 1

            
            yPlayer.renderMode = .destinationRect(Rect(topLeft:quadrantPoint, size:Size(width:1200/playerScale, height:2160/playerScale)))
            
            //show who's turn it is to go 
            xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:120, y:30), size:Size(width:1200/6, height:2160/6)))
            
        }
        
        placeAllowed = true
        
        for combination in winningCombinations {
            if gameState[combination[0]] != 0 &&
                 gameState[combination[0]] ==
                 gameState[combination[1]] &&
                 gameState[combination[1]] ==
                 gameState[combination[2]] {
                
                gameIsActive = false

                if gameState[combination[0]] == 1 {
                    print("x won")
                } else {
                    print("o won")
                }
            
            }

            for i in gameState {
                if i == 0 {
                  gameIsActive = true
                  break
                }
            }

            if gameIsActive == false {
                print("tie")
            }

            
    } }
    
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
}
