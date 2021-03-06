package states;
import luxe.States;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;
import lib.AutoCanvas;
import mint.focus.Focus;
import mint.layout.margins.Margins;

import mint.render.luxe.LuxeMintRender;

class ControlsState extends State {

  var canvas: mint.Canvas;
  var focus: ControllerFocus;

  public function new(name:String) {
    super({ name:name });
  }

  override function onenter<T> (_:T) {
    trace("Enter options state");
    var layout = new Margins();

    var a_canvas = new AutoCanvas(Luxe.camera.view, {
      name:'canvas',
      rendering: new LuxeMintRender(),
      options: { color:new Color(1,1,1,0.0) },
      x: 0, y:0, w: Luxe.screen.w, h: Luxe.screen.h
    });
    a_canvas.auto_listen();

    canvas = a_canvas;
    focus = new ControllerFocus(canvas, function() {
      Main.machine.set("options_state");
    });

    var title = new mint.Label({
        parent: canvas,
        name: 'title',
        x:0, y:30, w:Luxe.screen.w, h:64,
        text: 'Controls',
        align:center,
        text_size: 56
    });

    var last_button: mint.Button = null;

    for (i in 0...Luxe.core.app.config.user.game.controllers) {
      var p = i + 1;
      var controller_button = new mint.Button({
        parent: canvas,
        name: 'controller_button+' + i,
        x: Luxe.screen.mid.x - (320 / 2), y: 0, w: 320, h: 64,
        text: 'Player ' + p,
        text_size: 28,
        options: { },
        onclick: function(_, _) {
          Main.machine.set("configure_controller_state", i);
        }
      });

      if (last_button == null) {
        layout.margin(controller_button, title, top, fixed, title.h + 50);
      } else {
        layout.margin(controller_button, last_button, top, fixed, last_button.h + 25);
      }
      last_button = controller_button;
    }

    var back_button = new mint.Button({
      parent: canvas,
      name: 'back_button',
      x: Luxe.screen.mid.x - (320 / 2), y: 0, w: 320, h: 64,
      text: 'Back',
      text_size: 28,
      options: { },
      onclick: function(_, _) {
        Main.machine.set("options_state");
      }
    });

    layout.margin(back_button, last_button, top, fixed, last_button.h + 25);
  }

  override function onleave<T> (_:T) {
    trace("Leave controls state");
    canvas.destroy();
  }

  override function update(elapsed:Float) {
    focus.update(elapsed);
  }
}
