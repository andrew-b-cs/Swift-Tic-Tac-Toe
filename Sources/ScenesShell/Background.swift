import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {
    var gridHeight = 50
    var gridWidth = 300
    var rectanglesToRender : [Rectangle] = [Rectangle]()
    var rectangleFillStyles : [FillStyle] = [FillStyle]()
    var rectangleStrokeStyles : [StrokeStyle] = [StrokeStyle]()

    var ellipsesToRender : [Ellipse] = [Ellipse]()
    var ellipsesFillStyles : [FillStyle] = [FillStyle]()
    var ellipsesStrokeStyles : [StrokeStyle] = [StrokeStyle]()
    var textObjects : [Text] = [Text]()
    
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

    func makeText(x: Int, y: Int, text:String) -> Text {
            var textObject = Text(location:Point(x:x, y:y), text:"\(text)")
            textObject.font = "70pt Arial"
            return textObject
    }
    func renderOnClick(text: String){
        textObjects.append(makeText(x:200, y:200, text:"X"))
    }

    init() {
        func randomColor() -> Color {
            return Color(red: UInt8.random(in: 0...255), green: UInt8.random(in: 0...255), blue: UInt8.random(in: 0...255))
        }

        func makeRectangle(x:Int, y:Int, width:Int, height:Int) -> Rectangle {
            return Rectangle(rect: Rect(topLeft:Point(x:x,y:y), size:Size(width:width,height:height)), fillMode:.fillAndStroke)
        }

        func makeCircle(x:Int, y:Int, radius:Int) -> Ellipse {
            return Ellipse(center:Point(x:x,y:y), radiusX: radius, radiusY: radius, fillMode:.fillAndStroke)
        }
        
        func makeEllipse(x:Int, y:Int, radiusX:Int, radiusY:Int) -> Ellipse {
            return Ellipse(center:Point(x:x,y:y), radiusX: radiusX, radiusY: radiusY, fillMode:.fillAndStroke)
        }

        
        
        
        

        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))
        rectanglesToRender.append(makeRectangle(x:gridWidth+350, y:gridHeight+325, width: 610, height: 20))
        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))
        rectanglesToRender.append(makeRectangle(x:gridWidth+350, y:gridHeight+575, width: 610, height: 20))

       
        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))
        rectanglesToRender.append(makeRectangle(x:gridWidth + 525, y:gridHeight+150, width: 20, height: 600))
        rectangleFillStyles.append(FillStyle(color:Color(.black)))
        rectangleStrokeStyles.append(StrokeStyle(color:Color(.black)))
        rectanglesToRender.append(makeRectangle(x:gridWidth + 775, y:gridHeight+150, width: 20, height:600))

        
        

 
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

    

    override func setup(canvasSize: Size, canvas: Canvas) {
        // Position the ellipse at the center of the canvas
        screenSize = canvasSize

    }
    
    override func render(canvas:Canvas) {

        

        for x in 0..<rectanglesToRender.count {
            canvas.render(rectangleFillStyles[x], rectangleStrokeStyles[x], rectanglesToRender[x])
        }

        for x in 0..<ellipsesToRender.count {
            canvas.render(ellipsesFillStyles[x], ellipsesStrokeStyles[x], ellipsesToRender[x])
        }

        for x in 0..<textObjects.count {
            canvas.render(textObjects[x])
        }
    }
}
