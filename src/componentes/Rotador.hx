package componentes;

import luxe.Component;
import luxe.Sprite;



class Rotador extends Component {


    private var velocidad : Float = 40;
    private var sentido : Float = 1;

    var sprite : Sprite;

    override function init() {
        sprite = cast entity;
    }

    public function sentidoNegativo() {
        sentido = -1;
    }

    public function sentidoPositivo() {
        sentido = 1;
    }

    override function update( dt:Float ) {
        sprite.rotation_z += velocidad * dt * sentido;
    } 
}