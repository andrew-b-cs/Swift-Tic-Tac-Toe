import Igis
import Scenes
import Foundation

class Ball : RenderableEntity, EntityMouseClickHandler {
    
    var xPlayer : Image 
    var yPlayer : Image
    var clearingBox : Image
    var background : Background?
    var xWin : Image
    var yWin : Image

    
    var lineWidth : Int //Width of each scoreboard line, used for rendering scoreboard and snapping player moves to each board position
    var gridSpace : Int //The width of the space inside each scoreboard box, used for rendering scoreboard and snapping player moves to each board position 
    var xPos : Int //X positition of the scoreboard 
    var yPos : Int //Y posittion of the scoreboard
    var placeAllowed = true //A boolean to determine whether the box a player is trying to go in is already full
    var isGameOver = false //A boolean to determine if the game is over

    var playerScale = 10 // The scale of the player images to be rendered
    var count = 1 // The play count for win detection
    var activePlayer = 1 //1 = "X", 2 = "O"
    var gameState = [0,0,0,0,0,0,0,0,0] //current board state spread out into a 1D array
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]] // The possible combinations that result in a winningcombinations 

    var gameIsActive = true // Variable to determine the state of the game so that the game can be stopped after a win is detected
    
    var quadrantPoint = Point(x:-1000, y:0) // The point used to determine where out clicks need to be to be within our game grid
    
    init() {
        
        // Create URLs for the images to render on screen
        guard let clearingBoxUrl = URL(string:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs7JymjngWBlKUaY4qul9pyUsfHOoL2Dm6hoShqOU4v92tmLNBV4bz5Quim8x4qKMygas&usqp=CAU") else {
            fatalError("Failed to crate URL")
        }
        
        guard let xPlayerUrl = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Letter_x.svg/1200px-Letter_x.svg.png") else {
            fatalError("Failed to crate URL")
        }

        guard let yPlayerUrl = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Letter_o.svg/1085px-Letter_o.svg.png") else {
            fatalError("Failed to crate URL")
        }

        guard let xWinUrl = URL(string:"https://codermerlin.com/users/andrew-bourinski/unknown-16.png") else {
            fatalError("Failed to crate URL")
        }

        guard let yWinUrl = URL(string:"https://codermerlin.com/users/andrew-bourinski/unknown-18.png") else {
            fatalError("Failed to crate URL")
        }


        // Create images to be rendered on screen
        
        xPlayer = Image(sourceURL:xPlayerUrl)
        yPlayer = Image(sourceURL:yPlayerUrl)
        clearingBox = Image(sourceURL:clearingBoxUrl)
        xWin = Image(sourceURL:xWinUrl)
        yWin = Image(sourceURL:yWinUrl)

        
        // Temporary variables, used for grid snapping and grid positioning
        lineWidth = 0
        gridSpace = 0
        xPos = 0
        yPos = 0
        
        super.init(name:"Ball")
    }

    // This function lets us access the attributes of our Background file within our scoreboard file
    
    func setBackground(layer:Background) {
        self.background = layer
    }

    
    
    override func setup(canvasSize: Size, canvas: Canvas) {

        // Sets up each image in canvas
        canvas.setup(xPlayer)
        canvas.setup(yPlayer)
        canvas.setup(clearingBox)
        canvas.setup(xWin)
        canvas.setup(yWin)


        // Sets a starting position for each image
        clearingBox.renderMode = .destinationRect(Rect(topLeft:Point(x:0, y:0), size:Size(width:500, height:500)))
        xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:120, y:30), size:Size(width:1200/6, height:2160/6)))
        yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:-1000, y:0), size:Size(width:1200/6, height:2160/6)))
        xWin.renderMode = .destinationRect(Rect(topLeft:Point(x:-1000, y:0), size:Size(width:495, height:126)))
        yWin.renderMode = .destinationRect(Rect(topLeft:Point(x:-1000, y:0), size:Size(width:502, height:123)))

     // Registers a listener to detect mouse clicks
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func teardown() {
        
        // Unregisters a listener to detect mouse clicks
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas:Canvas) {
     
        // Renders all images each render frame
        if clearingBox.isReady {
            canvas.render(clearingBox)
        }
        
        if xPlayer.isReady {
            canvas.render(xPlayer)
        }

        if yPlayer.isReady {
            canvas.render(yPlayer)
        }

        if xWin.isReady {
            canvas.render(xWin)
        }

        if yWin.isReady {
            canvas.render(yWin)
        }
    }

    
    
    func onEntityMouseClick(globalLocation: Point) {

        // Gets the tic tac toe board attributes from Background.swift
        if let background = background {
            lineWidth = background.getLineWidth() // The line width of each grid segment
            gridSpace = background.getGridSpace() // The space between each grid segment
            xPos = background.getX() // The topleft x position of our grid
            yPos = background.getY() // The topleft y position of our grid
        }

        let clickPoint = Point(x:globalLocation.x - (1200/playerScale)/2, y:globalLocation.y - ((2160/playerScale)/2)) // Sets the variable using our clickpoint so that it can be used for calculations

        if !isGameOver {

            // Code for the top 3 rows of the grid (checks if the click is within our grid then determines what space its in and tells our game logic a player has made a move)
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
        } else if clickPoint.x < xPos + (gridSpace * 4) - lineWidth*2  && clickPoint.y < yPos + gridSpace/2 + lineWidth{
            quadrantPoint.x = xPos + gridSpace*2 + gridSpace/4 + lineWidth*2
            quadrantPoint.y = yPos + gridSpace/8

            if gameState[2] == 0{
                gameState[2] = activePlayer
            } else {
                placeAllowed = false
            }
           
        }
      
        // Code for the middle 3 rows of the grid (same as above)
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
        } else if clickPoint.x < xPos + (gridSpace * 4) - lineWidth*2  && clickPoint.y < yPos + gridSpace/2 + lineWidth*2 + gridSpace {
            quadrantPoint.x = xPos + gridSpace*2 + gridSpace/4 + lineWidth*2
            quadrantPoint.y = yPos + gridSpace + gridSpace/8
            
            if gameState[5] == 0{
                gameState[5] = activePlayer
            } else {
                placeAllowed = false
            }
        }
        
        // Code for the bottom 3 rows of the grid (same as above)
        else if clickPoint.x < xPos + gridSpace - lineWidth*3 && clickPoint.y < yPos + gridSpace/2 + lineWidth*3 + gridSpace*3 {
            quadrantPoint.x = xPos + gridSpace/4
            quadrantPoint.y = yPos + gridSpace*2 + gridSpace/8 + lineWidth

            if gameState[6] == 0{
                gameState[6] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 2) - lineWidth*2 && clickPoint.y < yPos + gridSpace/2 + lineWidth*3 + gridSpace*3 {
            quadrantPoint.x = xPos + gridSpace + gridSpace/4 + lineWidth
            quadrantPoint.y = yPos + gridSpace*2 + gridSpace/8 + lineWidth

            if gameState[7] == 0{
                gameState[7] = activePlayer
            } else {
                placeAllowed = false
            }
        } else if clickPoint.x < xPos + (gridSpace * 4) - lineWidth*2  && clickPoint.y < yPos + gridSpace/2 + lineWidth*3 + gridSpace*3 {
            quadrantPoint.x = xPos + gridSpace*2 + gridSpace/4 + lineWidth*2
            quadrantPoint.y = yPos + gridSpace*2 + gridSpace/8 + lineWidth

            if gameState[8] == 0{
                gameState[8] = activePlayer
            } else {
                placeAllowed = false
            }
            
        }
        }

        // Checks the state of the game and renders the symbol for the active player in the space that was clicked
        
        if (activePlayer == 1 && placeAllowed && !isGameOver) {
            activePlayer = 2
            
            xPlayer.renderMode = .destinationRect(Rect(topLeft:quadrantPoint, size:Size(width:1200/playerScale, height:2160/playerScale)))
            
            //show who's turn it is to go
            yPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:120, y:30), size:Size(width:1200/6, height:2160/6)))
            
        } else if(placeAllowed && !isGameOver) {
            
            activePlayer = 1

            
            yPlayer.renderMode = .destinationRect(Rect(topLeft:quadrantPoint, size:Size(width:1200/playerScale, height:2160/playerScale)))
            
            //show who's turn it is to go 
            xPlayer.renderMode = .destinationRect(Rect(topLeft:Point(x:120, y:30), size:Size(width:1200/6, height:2160/6)))
            
        }
        
        placeAllowed = true

        // Checks if the current board state is a win and if so for what player
        
        for combination in winningCombinations {
            if gameState[combination[0]] != 0 &&
                 gameState[combination[0]] ==
                 gameState[combination[1]] &&
                 gameState[combination[1]] ==
                 gameState[combination[2]] {
                
                gameIsActive = false

                // If the game is won and X is the current player then X won
                if gameState[combination[0]] == 1 {
                    print("x won")
                    isGameOver = true
                    xWin.renderMode = .destinationRect(Rect(topLeft:Point(x:xPos - gridSpace*2 - lineWidth*3, y:gridSpace*2), size:Size(width:495, height:126)))

                    

                    // If the game is won and X is the current player then O won
                } else {
                    print("o won")
                    isGameOver = true
                    yWin.renderMode = .destinationRect(Rect(topLeft:Point(x:xPos - gridSpace*2 - lineWidth*3, y:gridSpace*2), size:Size(width:502, height:123)))
                }
            
            }

            
            for i in gameState {
                if i == 0 {
                    gameIsActive = true
                } 

                
            }

            // If the game is active due to the board being filled and a win is not detected then the result is a Tie
            if gameIsActive == false {
                print("tie")
                isGameOver = true
            }

            
    } }
    
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
}
