import Igis
import Scenes


class Ball : RenderableEntity, EntityMouseClickHandler {
    var currentPlayer = "X"
    
    

    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Ball")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        // Position the ellipse at the center of the canvas
        // ellipse.center = canvasSize.center
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas:Canvas) {
        
    }

    func onEntityMouseClick(globalLocation: Point) {
        Background.renderOnClick(text: currentPlayer)
        
        if (currentPlayer == "X") {
            currentPlayer = "O"
        } else {
            currentPlayer = "X"
        }
        
    }

    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
}
