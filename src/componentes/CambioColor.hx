package componentes;

import luxe.Component;
import luxe.Sprite;
import luxe.Color;
import luxe.Input;



class CambioColor extends Component {


    private var colorDefault : Color;
    private var colorAlternativo : Color;

    var sprite : Sprite;

    override function init() {
        sprite = cast entity;
    }

    public function setColores( cdefault : Color, calternativo : Color){
        colorDefault=cdefault;
        colorAlternativo=calternativo;
    }

    private function compararColores(color1:Color, color2 : Color){
        if(color1.b==color2.b && color1.g==color2.g && color1.r==color2.r) return true;
        else return false;
    }

    override function onmousemove( event:MouseEvent ) {

        if(sprite.point_inside(event.pos)) {
            if(!compararColores(sprite.color, colorAlternativo)){
                sprite.color=colorAlternativo;
            }
            
        }else{
            if(!compararColores(sprite.color, colorDefault)){
                sprite.color=colorDefault;
            }
             
        }                
    }

}