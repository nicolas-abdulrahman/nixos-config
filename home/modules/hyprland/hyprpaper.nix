{ pkgs, lib, ... }: 
let path = "/etc/nixos/users/sunshine/home"; in
{
    services.hyprpaper={
       enable = true;
        package = pkgs.hyprpaper;
       settings = {
         # ipc = "on";
         splash = false;
         splash_offset = 2.0;

         preload =
           [ "${path}/walpaper2.jpg" "${path}/walpaper3.jpg"  "${path}/walpaper4.png" 
                    "${path}/walpaper5.png" "${path}/walpaper6.png" "${path}/walpaper8.png"
"${path}/walpaper9.png"
                    "${path}/walpaper7.jpg"];

         wallpaper = [
           ", ${path}/walpaper7.png"
            ];
        };
    };
}
