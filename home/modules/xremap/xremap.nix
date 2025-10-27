{ pkgs, config, ... }:
let yaml =''
default_mode: default
virtual_modifiers: 
  - CapsLock
modmap:
  - name: main
    remap:
      CapsLock : 
        held: CapsLock
        alone: Esc

keymap:
  - name : main remap
    remap :
      super-i : 
        set_mode: command
      CapsLock-j: semicolon
      CapsLock-w: KEY_UP
      CapsLock-a: KEY_LEFT
      CapsLock-s: KEY_DOWN
      CapsLock-d: KEY_RIGHT
      # CapsLock-n: leftbrace
      CapsLock-u: question
      CapsLock-h: slash
      CapsLock-n: rightbrace
      CapsLock-m: backslash
      CapsLock-i: KEY_KPPLUS
      CapsLock-o: equal
      CapsLock-p: minus
    mode : default
  
  
  - name : command remap
    remap :
      super-i : 
        set_mode: default
    mode: command
''; in
{

   # pkgs.lib.writeText "template.yaml" yaml;
    services.xremap = {
        #userName = "sunshine";
        withWlroots = true;
       # withHypr = true; #     
       yamlConfig = yaml;
    };
}
