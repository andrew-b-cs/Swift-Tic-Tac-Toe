import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {
    
    var rectanglesToRender : [Rectangle] = [Rectangle]()
    var rectangleFillStyles : [FillStyle] = [FillStyle]()
    var rectangleStrokeStyles : [StrokeStyle] = [StrokeStyle]()

    var lineWidth = 20
    var gridSpace = 250
    var xPos = 600
    var yPos = 50
    




    
    var screenSize : Size = Size(width: 0, height: 0)

    func renderRect(x:Int, y:Int, width:Int, height:Int, canvas:Canvas, color: Color) {
        let rect = Rect(topLeft:Point(x:x,y:y), size:Size(width:width,height:height))
        let rectangle = Rectangle(rect:rect, fillMode:.fill)
        canvas.render(FillStyle(color:color), rectangle);
    }

    func renderRectangle(canvas:Canvas, rect: Rect) {
        let rectangle = Rectangle(rect:rect, fillMode:.stroke)
        canvas.render(rectangle);
    }


    init() {
        func makeRectangle(x:Int, y:Int, width:Int, height:Int) -> Rectangle {
            return Rectangle(rect: Rect(topLeft:Point(x:x,y:y), size:Size(width:width,height:height)), fillMode:.fillAndStroke)
        }
            
        
        
        

        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))
        // Horizontal Lines
        rectanglesToRender.append(makeRectangle(x:xPos, y: yPos + (gridSpace), width: (gridSpace * 3) + (lineWidth * 2), height: lineWidth))

        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))

        rectanglesToRender.append(makeRectangle(x:xPos, y: yPos + ((gridSpace * 2) + lineWidth), width: (gridSpace * 3) + (lineWidth * 2), height: lineWidth))

       
        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))

        // Vertical Lines
        rectanglesToRender.append(makeRectangle(x: xPos + ((gridSpace * 2) + lineWidth), y:yPos, width: lineWidth, height: (gridSpace * 3) + (lineWidth * 2)))

        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))

        rectanglesToRender.append(makeRectangle(x:xPos + gridSpace, y:yPos
                                               , width: lineWidth, height: (gridSpace * 3) + (lineWidth * 2)))

       
        

 
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

    //functions to pass in variables to ScoreBoard.swift 
     func getLineWidth() -> Int {
         return lineWidth
     }
     
     func getX() -> Int {
         return xPos
     }
     
     func getY() -> Int {
         return yPos
     }
     
     func getGridSpace() -> Int {
         return gridSpace
     }

    override func setup(canvasSize: Size, canvas: Canvas) {
        // Position the ellipse at the center of the canvas
        screenSize = canvasSize

    }
    
    override func render(canvas:Canvas) {

        

        for x in 0..<rectanglesToRender.count {
            canvas.render(rectangleFillStyles[x], rectangleStrokeStyles[x], rectanglesToRender[x])
        }

        
    }
}
