{$i xpc.inc}          // standard compiler config options
{$mode delphi}        // use delphi's nicer (imho) syntax for helpers, generics
program hello_app;    // name of the program :)
uses
  xpc,                // defines some common types and helpful procedures
  kvm,                // 'keyboard/video/mouse' : basic console interface
  cw,                 // 'color write' : for drawing colored text quickly
  cx,                 // optional. prints exceptions in pretty colors.
  uapp,               // a framework for making console applications
  ukm;                // defines the keymap class

type
  THelloApp = class (uapp.TCustomApp)
    public
      // defaults for all of these are defined in TCustomApp.
      // but you'll usually wind up overriding all of them:
      procedure init; override;
      procedure keys(km : ukm.TKeyMap); override;
      procedure step; override;
      procedure done; override;
      // and here's a custom method just
      // so you can see how to do it:
      procedure cwecho( ext : boolean; ch : TChr );
    end;

procedure THelloApp.init;
  var x, y : byte;
  begin
    kvm.clrscr; x := kvm.width div 2; y := kvm.height div 10;
    cw.ccenterxy(x, y,   '|cHello |BWorld|g!');
    cw.ccenterxy(x, y+2, '|wpress ^C to quit');
    cw.ccenterxy(x, y+3, 'or type to experiment with cw.cwrite()');
    kvm.gotoxy(0, y+5);
  end;

procedure THelloApp.done;
  begin
    kvm.clrscr; cwriteln('|Rbye!|w');
  end;

procedure THelloApp.keys(km : ukm.TKeyMap);
  var ch : TChr;
  begin
    // this assigns every key in the keymap to our 'echo' method:
    for ch := #0 to #225 do km.crt[ ch ] := self.cwecho;
    // this lets us quit the app with ^C: (control+C)
    km.cmd[ ^C ] := quit;
  end;

procedure THelloApp.cwecho( ext : boolean; ch : TChr );
  begin
    if ext then  // non-ascii codes like home/end, alt+letter, etc.
      ok         // do-nothing. (inlined empty procedure from xpc.pas)
    else
      cw.cwrite(ch)
  end;

procedure THelloApp.step;
  begin
    // .step gets run repeatedly in a loop
  end;

begin
  uapp.Run(THelloApp);
end.
