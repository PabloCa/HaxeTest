package states;
import luxe.States;
import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Draw;
import phoenix.geometry.Geometry;

import componentes.Arrastrador;

import lib.AutoCanvas;
import mint.render.luxe.LuxeMintRender;
import luxe.Text;

import phoenix.Texture;
import luxe.components.sprite.SpriteAnimation;



class GameState extends State {

    var block : Sprite;
    var block2 : Sprite;
    var meta : Sprite;
    var rotacion : Int = 40;
    var arrastrando : Bool = false;
    var esCirculo : Bool = false;
    var posicionMouse : luxe.Vector;
    var arrastrador: Arrastrador;
    var fondo:Geometry;
    var text1: mint.TextEdit;
    var canvas: mint.Canvas;
    var delta_time_text : Text;
    var focus: ControllerFocus; 

    var player : Sprite;
    var anim : SpriteAnimation;
    var image : Texture;
    var max_left : Float = 0;
    var max_right : Float = 0;
    var move_speed : Float = 0;




    public function new(name:String) {
     super({ name:name });
    }

    override function onenter<T> (_:T) {



        fondo = Luxe.draw.box({
            x : 0, y : 0,
            w : Luxe.screen.w,
            h : Luxe.screen.h,
            color : new Color().rgb(0x4286f4)
        });
        //deltat
        delta_time_text = new luxe.Text({
            color : new Color(0,0,0,1).rgb(0xf6007b),
            pos : new Vector(0,Luxe.screen.h-80),
            font : Luxe.renderer.font,
            point_size : 20
        });

        
        crearVentana();   

        crearSprites();
        
        crearPlayer();

        crearAnimacion();



    } //ready


    function crearSprites(){
        meta = new Sprite({
            name: 'meta',
            pos: new phoenix.Vector(100,100,0,0),
            color: new Color(0,0,255,1.0),            
            size: new Vector(168, 168)
        });

        block = new Sprite({
            name: 'a sprite',
            pos: Luxe.screen.mid,
            color: new Color().rgb(0xf94b04),
            size: new Vector(128, 128), 

        });

        block2 = new Sprite({
            name: 'a sprite2',
            pos: new Vector(300, 450),
            color: new Color().rgb(0xf94b04),
            size: new Vector(128, 128), 

        });
        
        arrastrador = new Arrastrador({ name:'arrastrador' });
        block.add(arrastrador);
        arrastrador.setMeta(meta);
        arrastrador = new Arrastrador({ name:'arrastrador2' });
        block2.add(arrastrador);
        arrastrador.setMeta(meta);
    }

    function crearVentana(){
        var autoCanvas = new AutoCanvas(Luxe.camera.view, {
          name:'canvas',
          rendering: new LuxeMintRender(),
          options: { color:new Color().rgb(0x4286f4) },
          x: Luxe.screen.w-300, y:10, w: 300, h: 150
        });
        autoCanvas.auto_listen();
        canvas=autoCanvas;
        focus = new ControllerFocus(canvas);
        var window = new mint.Window({
            parent: canvas,name: 'window', title: 'window',
            visible: true, closable: false, collapsible: true,
            x:0, y:0, w:256, h: 131,
            h_max: 131, h_min: 131, w_min: 131,

        });

        text1 = new mint.TextEdit({
            parent: window, name: 'textedit1', text: 'ola', renderable: true,
            x: 10, y:32, w: 256-10-10, h: 22
        });

        var exit_button = new mint.Button({
          parent: window,
          name: 'botonInutil',
          x: 10, y: 60, w: 256-10-10, h: 22,
          text: 'botonInutil',
          text_size: 12,
          options: { },
          onclick: function(_, _) {
            trace('Lo que esta en TE es:'+text1.text+'\n bloque 1:'+ block.pos.x+'-'+block.pos.y+' g:'+block.geometry+'\n bloque 2:'+ block2.pos.x+'-'+block2.pos.y+' g:'+block2.geometry);
            
          }
        });
    }

    function crearPlayer(){
                    //fetch the player image
        image = Luxe.resources.texture('assets/player.png');

            //keep pixels crisp, same as create_apartment
        image.filter_min = image.filter_mag = FilterType.nearest;

            //work out the correct size based on a ratio with the screen size
        var frame_width = 32;
        var height = Luxe.screen.h/1.75;
        var ratio = (height/image.height);
        var width = ratio * frame_width;

            //this is an arbitrary ratio I made up :)
        move_speed = width*1.5;

            //screen edge boundary for walking
        max_right = Luxe.screen.w - (width/2);
        max_left = (width/2);

            //start with the idle texture
        player = new Sprite({
            name: 'player',
            texture: image,
            pos : new Vector(Luxe.screen.mid.x, Luxe.screen.h - (height/1.75)),
            size: new Vector(width, height)
        });
    }

    function crearAnimacion(){
            //create the animation from the previously loaded json,
            //the frameset structure allows us to specify things like
            //"animate frames 1-3 and then hold for 2 frames" etc.
        var anim_object = Luxe.resources.json('assets/anim.json');

            //create the animation component and add it to the sprite
        anim = player.add( new SpriteAnimation({ name:'anim' }) );

            //create the animations from the json
        anim.add_from_json_object( anim_object.asset.json );

            //set the idle animation to active
        anim.animation = 'idle';
        anim.play();        
    }
    

    override function onleave<T> (_:T) {
      trace("Leave menu state");
    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(elapsed:Float) {
        focus.update(elapsed);
        delta_time_text.text = 'dt : ' + elapsed + '\n average : ' + Luxe.debug.dt_average+'\n fps : ' + 1/Luxe.debug.dt_average;

        var moving = false;
        if (Controls.inputdown(1, 'Left')) {
            player.pos.x -= move_speed * elapsed;
            player.flipx = true;

            moving = true;
        }else if(Controls.inputdown(1, 'Right')){
            player.pos.x += move_speed * elapsed;
            player.flipx = false;

            moving = true;
        }
                   //limit to the screen edges
        if(player.pos.x >= max_right) {
            player.pos.x = max_right;
            moving = false;
        }
        if(player.pos.x <= max_left) {
            player.pos.x = max_left;
            moving = false;
        }

            //set the correct animation
        if(moving) {
            if(anim.animation != 'walk') {
                anim.animation = 'walk';
            }
        } else {
            if(anim.animation != 'idle') {
                anim.animation = 'idle';
            }
        }

    }


} //Main