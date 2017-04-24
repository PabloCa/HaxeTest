package componentes;

import luxe.Component;
import luxe.Sprite;
import luxe.Input;
import luxe.Color;


class Arrastrador extends Component {

	var sprite : Sprite;
	var meta : Sprite;
	var posicionMouse : luxe.Vector;
	var rotador: Rotador;
	var cambioColor: CambioColor;
	var arrastrando : Bool = false;
	var esCirculo : Bool = false;

    override function init() {
        sprite = cast entity;
        rotador = new Rotador({ name:'rotador' });
        sprite.add(rotador);
        cambioColor = new CambioColor({ name:'cambioColor' });
        cambioColor.setColores(new Color().rgb(0xf94b04), new Color().rgb(0xfefefe));
        sprite.add(cambioColor);
    }

    override function onmousemove( event:MouseEvent ) {
        posicionMouse=event.pos;
    }


	public function setMeta( m:Sprite ) {
        meta=m;
    }

    override function update( delta:Float ){
    	if(posicionMouse!=null){
            if(sprite.point_inside(posicionMouse)) {
                //sprite.color=new Color().rgb(0xfefefe);
                if(Luxe.input.mousedown(luxe.MouseButton.left)) {
                    sprite.pos.x=posicionMouse.x;
                    sprite.pos.y=posicionMouse.y;
                    rotador.sentidoNegativo(); 
                    arrastrando=true;                                    
                }else rotador.sentidoPositivo();          
            }//else sprite.color=new Color().rgb(0xf94b04);            
        }
        if(Luxe.input.mousereleased(luxe.MouseButton.left)){          
            
            if(arrastrando && meta.point_inside(posicionMouse)){
                sprite.pos.x=meta.pos.x;
                sprite.pos.y=meta.pos.y;
                if(esCirculo){
                    trace('entroenweaitagenuina2');
                    sprite.geometry= Luxe.draw.box({
                        x : 0 , y : 0,
                        w : 128,
                        h : 128,
                    });
                }else{
                    trace('entroenweaitagenuina');
                    sprite.geometry= Luxe.draw.ngon({
                      x : 64, y : 64,
                      r:90,
                      sides : 3,
                      solid : true
                    });
                }
                esCirculo=!esCirculo;

            }
            arrastrando=false;
        }
    }
}