import Scenes
class InteractionLayer : Layer {

    let ball = Ball()

    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        insert(entity: ball, at: .front)
    }
}
