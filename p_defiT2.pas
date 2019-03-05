program p_defit2;

uses sdl2, sdl2_image, SDL2_mixer;

var
        i, continue, randomX, count, points : INTEGER;
        droite : BOOLEAN;

        music : PMIX_Music;
        fenetre : PSDL_Window;
        sdlRenderer : PSDL_Renderer;
        rendererBalle : PSDL_Renderer;
        sdlRect1 : PSDL_Rect;

        vaisseau : PSDL_Surface;
        balle : PSDL_Surface;
        cible : PSDL_Surface;

        sdlTexture1 : PSDL_Texture;
        textureBalle : PSDL_Texture;
        textureCible : PSDL_Texture;
        textureBackground : PSDL_Texture;

        vaisseau_para : TSDL_rect;
        balle_origin : TSDL_rect;
        cible_para : TSDL_rect;
        sdlEvent : PSDL_Event;

const
        hv = 90;
        wv = hv;
        hf = 600;
        wf = 800;



procedure deplacement_cible;
begin
         if (droite = true) then
                begin
                        cible_para.x := cible_para.x+count+2;
                end else if (droite = false) then
                        begin
                                cible_para.x := cible_para.x-2-count;
         end; //if droite



         if(cible_para.x>wf-cible_para.w+3) then
                begin
                        cible_para.y := cible_para.y+cible_para.h;

                        if (droite = true) then
                        begin
                                droite := false;
                        end else if (droite = false) then
                        begin

                                droite := true;
                        end;//if droite = true
                        IF(count<10) then
                                count:=count+1;
                end;// si la cible touche le bord droit


         if(cible_para.x<0) then
                begin
                        cible_para.y := cible_para.y+cible_para.h;

                        if (droite = true) then
                        begin
                                droite := false;
                        end else if (droite = false) then
                        begin
                                droite := true;
                        end;//if droite

                end;// si la cible touche le bord gauche

end;// procedure_cible



procedure collision_balle_cible;
begin
        if (((balle_origin.x+10 > cible_para.x)
        AND (balle_origin.x-10 < (cible_para.x+cible_para.w)))
        AND ((balle_origin.y > cible_para.y)
        AND (balle_origin.y < (cible_para.y+cible_para.h))))then
        begin
                    balle_origin.x:= -500;
                    balle_origin.y := -500;
                    cible_para.x := 0;
                    cible_para.y := 0;
                    points:= points+1;
                    count:=count+1;
        end;
end;// fin procedure collision balle cible



procedure collision_vaisseau_cible;
var i : INTEGER;
begin
        if ((vaisseau_para.x OR (vaisseau_para.x + vaisseau_para.w) > (cible_para.x+cible_para.w))
        AND (vaisseau_para.x < cible_para.x + cible_para.w))
        AND ((vaisseau_para.y < (cible_para.y+cible_para.h))
        AND (vaisseau_para.y > cible_para.y)) then// AN
        begin
                SDL_DestroyTexture(sdlTexture1);
                continue:=0;
        end;
end; // procedure collision cible balle



//debut algo
BEGIN
points :=0;
droite := true;
continue :=1;
//initialisation systeme video, fenetre et audio
IF (SDL_INIT(SDL_INIT_VIDEO)<0) THEN Halt;
SDL_Init(SDL_INIT_AUDIO);

fenetre := SDL_CreateWindow('SUPER DESTROYER',SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,wf,hf,SDL_WINDOW_SHOWN);
IF (fenetre = nil) THEN Halt;

if Mix_OpenAudio(Mix_Default_frequency, mix_default_format,mix_default_channels, 4096)<0 then halt;

//choix de la musique de fond et param‚trage
music := Mix_LoadMUS('C:\FPC\3.0.4\bin\i386-win32\niveau.mp3');
if music = nil then Halt;
Mix_VolumeMusic(MIX_MAX_VOLUME);
Mix_PlayMusic(music,-1);

sdlRenderer := SDL_CreateRenderer (fenetre, -1, 0);

//d‚claration paramŠtres des diff‚rents objets
        cible_para.x := 0;
        cible_para.y := 0;
        cible_para.h := 25;
        cible_para.w := 25;

        vaisseau_para.x := (wf DIV 2)-(wv DIV 2);
        vaisseau_para.y := hf-hv;
        vaisseau_para.h := hv;
        vaisseau_para.w := wv;

        balle_origin.x:= -500;
        balle_origin.y := -500;
        balle_origin.h:= 5;
        balle_origin.w :=5;

IF (sdlRenderer = nil) THEN Halt;

new(sdlEvent);

        //choix images pour les diff‚rents ‚l‚ments et affichage
        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'nearest');
        vaisseau := SDL_LoadBMP('vaisseau.bmp');
        balle := SDL_LoadBMP('swirl_effect.bmp');
        cible := SDL_LoadBMP('swirl_effect.bmp');
        sdlTexture1 := IMG_LoadTexture(sdlRenderer, 'vaisseau.png');
        textureBackground := IMG_LoadTexture(sdlRenderer, 'background.jpg');

        textureCible := SDL_CreateTextureFromSurface(sdlRenderer, cible);
        textureBalle := SDL_CreateTextureFromSurface(sdlRenderer, balle);

        IF (sdlTexture1 = nil) THEN Halt;

        new( sdlEvent );

        //d‚but boucle de gameplay
        WHILE(continue=1) DO
        BEGIN
                WHILE(SDL_PollEvent(sdlEvent)=1) DO
                BEGIN
                        case sdlEvent^.type_ of
                        SDL_KEYDOWN:
                                BEGIN
                                CASE sdlEvent^.key.keysym.sym OF
                                SDLK_d :
                                        BEGIN
                                                IF (vaisseau_para.x < wf-hv) THEN
                                                        vaisseau_para.x := vaisseau_para.x+10;  //d‚placement vers la droite du vaisseau
                                        END;//d

                                SDLK_q :
                                        BEGIN
                                                IF (vaisseau_para.x > 0) THEN
                                                        vaisseau_para.x := vaisseau_para.x-10;  //d‚placement vers la gauche du vaisseau
                                        END;//q

                                SDLK_ESCAPE :
                                        BEGIN
                                                continue:=0;
                                        END;//ESCAPE

                                SDLK_SPACE :
                                        BEGIN
                                                if(balle_origin.y<=0-balle_origin.h) then// empeche de tirer un projectile tant qu'un autre est toujours … l'‚cran
                                                        BEGIN
                                                        balle_origin.x:=vaisseau_para.x+(vaisseau_para.w DIV 2)-3;
                                                        balle_origin.y := vaisseau_para.y; //on d‚place la balle sur le nez du vaisseau
                                                        END;
                                        END; //SPACE
                                END;//case of sdl_keydown
                        END;//case sdlEvent

                END;//WHILE sdl_pollevent

        END;// while de la boucle de gameplay

        balle_origin.y := balle_origin.y-7; //d‚placement de la balle

        deplacement_cible;


        SDL_renderclear(sdlrenderer);

        SDL_RenderCopy(sdlRenderer, textureBackground, nil, nil);
        SDL_RenderCopy(sdlRenderer, sdlTexture1, nil, @vaisseau_para);
        SDL_RenderCopy(sdlRenderer, textureBalle, nil, @balle_origin);
        SDL_RenderCopy(sdlRenderer, textureCible, nil, @cible_para);

        SDl_RenderPresent(sdlRenderer);
        collision_balle_cible;
        collision_vaisseau_cible;
                        IF (points>=5) then //si le joueur touche 5 fois la cible, le jeu s'arrˆte
                BEGIN
                        SDL_DestroyTexture(textureCible);
                        continue := 0;
                END;
        SDL_Delay(10);
END;// while continue


dispose(sdlRect1);
SDL_DestroyRenderer(SDLRenderer);
Mix_FreeMusic(music);
SDL_DestroyWindow (fenetre);

SDL_QUIT;
END.
