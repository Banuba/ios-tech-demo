//
//  JSConfig.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 07.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

enum JSConfig {
    static let eyeshadowCOSNOVA = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("speed")

    setState(
      {
        "eyeshadow": {
          "color": "0.97 0.87 0.89",
          "finish": "glitter_metallic",
          "coverage": "hi"
        }
      }
    )
    """
    
    static let eyeshadowGUCCI = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("speed")

     setState(
       {
         "eyeshadow": {
           "color": "0.917 0.698 0.619",
           "finish": "matte",
           "coverage": "hi"
         }
       }
     )
    """
    
    static let lipstickGucci = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("speed")

     setState(
       {
         "lipstick": {
           "color": "0.835 0.36 0.486",
           "finish": "balm",
           "coverage": "hi"
         }
       }
     )
    """
    
    static let lipstickRevlon = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("speed")

     setState(
       {
         "lipstick": {
           "color": "0.388 0.090 0.075",
           "finish": "satin",
           "coverage": "hi"
         }
       }
     )
    """
    
    static let foundationC110 = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("speed")

     setState(
       {
         "foundation": {
           "color": "0.796 0.608 0.463",
           "finish": "radiance",
           "coverage": "mid"
         }
       }
     )
    """
    
    static let foundationC190 = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })

    setState({})
    setMode("speed")

     setState(
       {
         "foundation": {
           "color": "0.714 0.537 0.380",
           "finish": "matte",
           "coverage": "mid"
         }
       }
     )
    """
    
    static let lookGucci = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("speed")

     setState(
       {
           "foundation": {
           "color": "0.894 0.682 0.505",
           "finish": "natural",
           "coverage": "lo"
         },
          "eyeliner": {
           "color": "0.635 0.776 0.898",
           "finish": "cream",
           "coverage": "hi"
         },
           "eyebrows": {
           "color": "0.396 0.384 0.388",
           "finish": "matte",
           "coverage": "mid"
         },
           "eyeshadow": {
           "color": "0.643 0.525 0.494",
           "finish": "shimmer",
           "coverage": "hi"
         },
           "lipstick": {
           "color": "1.0 0.439 0.486",
           "finish": "balm",
           "coverage": "hi"
         }
       }
     )
    """
    
    static let lookRevlon = """
    const { setState, setMode } = require("./js/index.js")

    Object.assign(globalThis, { setState, setMode })
    setState({})
    setMode("quality")

     setState(
       {
         "lipstick": {
           "color": "0.68, 0.07, 0.19",
           "finish": "matte_liquid",
           "coverage": "hi"
         },
           "eyebrows": {
           "color": "0.14, 0.11, 0.10",
           "finish": "matte",
           "coverage": "mid"
         },
           "eyeliner": {
           "color": "0.10, 0.06, 0.04",
           "finish": "matte_cream",
           "coverage": "hi"
         },
           "foundation": {
           "color": "0.87, 0.65, 0.48",
           "finish": "natural",
           "coverage": "mid"
         },
           "eyelashes": {
           "color": "0.0, 0.0, 0.00",
           "finish": "lengthening",
           "coverage": "hi"
         },
           "eyeshadow": {
           "color": "0.38, 0.30, 0.28",
           "finish": "glitter_sheer",
           "coverage": "hi"
         },
           "blush": {
           "color": "0.85, 0.53, 0.51",
           "finish": "shimmer",
           "coverage": "mid"
         }
       }
     )
    """
    
    static let octopusNoSound = """
    function Effect()
    {
        var self = this;

        self.loveDelay = 1350;
        self.jumpDelayStart = 1400;
        self.jumpDelay = 700;

        self.fallDownDelay = 500;

        /*
        this.meshes = [
            { file:"octopus.bsm2", anims:[
                { a:"start", t:1400 },
                { a:"idle", t:1733.33 },
                { a:"trigger_1", t:1700 },
                { a:"trigger_2_start", t:2500 },
                { a:"trigger_2_idle", t:1966.67 },
                { a:"trigger_2_end", t:933.333 },
                { a:"trigger_3", t:2166.67 },
            ] },
        ];
        */

        this.soundJump = function() {
            var now = (new Date()).getTime();
            if (now > self.soundT) {
                self.faceActions = [self.play];
            }
        };

        this.soundFallDown = function() {
            var now = (new Date()).getTime();

            if (now >= self.fallDownTime) {
                self.fallDownTime = Number.MAX_VALUE;
            }

            if (now > self.soundT) {
                self.faceActions = [self.play];
            }
        };

        this.play = function() {
            var now = (new Date()).getTime();

            if (now < self.t)
                return;

            if (self.onTop) {
                if (Api.isMouthOpen()) {
                    Api.hideHint();
                    if (Math.random() < 0.5) {
                        Api.meshfxMsg("animOnce", 0, 0, "trigger_1");
                        Api.meshfxMsg("animLoop", 0, 1, "idle");
                        self.t = now + 1700;
                    } else {
                        Api.meshfxMsg("animOnce", 0, 0, "trigger_3");
                        Api.meshfxMsg("animLoop", 0, 1, "idle");
                        self.t = now + 2166.67;
                    }
                } else if (isSmile(world.landmarks, world.latents)) {
                    Api.hideHint();
                    Api.meshfxMsg("animOnce", 0, 0, "trigger_2_start");
                    Api.meshfxMsg("animLoop", 0, 1, "trigger_2_idle");

                    self.fallDownTime = now + self.fallDownDelay;
                    self.t = now + 2500;
                    self.soundT = now + self.loveDelay;
                    self.faceActions = [self.soundFallDown];
                    self.onTop = false;
                }
            } else {
                if (isSmile(world.landmarks, world.latents)) {
                    Api.meshfxMsg("animOnce", 0, 0, "trigger_2_end");
                    Api.meshfxMsg("animLoop", 0, 1, "idle");
                    self.t = now + 933.333;
                    self.soundT = now + self.jumpDelay;
                    self.faceActions = [self.soundJump];
                    self.onTop = true;
                }
            }
        };

        this.init = function() {
            Api.meshfxMsg("spawn", 1, 0, "!glfx_FACE");

            Api.meshfxMsg("spawn", 0, 0, "octopus.bsm2");
            Api.meshfxMsg("animOnce", 0, 0, "start");
            Api.meshfxMsg("animLoop", 0, 1, "idle");

            self.fallDownTime = Number.MAX_VALUE;
            self.t = 0;
            self.soundT = (new Date()).getTime() + self.jumpDelayStart;
            self.faceActions = [self.soundJump];
            self.onTop = true;
            
            Api.playVideo("frx", true, 1);
            Api.showRecordButton();
        };

        this.restart = function() {
            Api.meshfxReset();
            Api.stopVideo("frx");
            // Api.stopSound("sfx.aac");
            self.init();
        };

        this.faceActions = [];
        this.noFaceActions = [];

        this.videoRecordStartActions = [this.restart];
        this.videoRecordFinishActions = [];
        this.videoRecordDiscardActions = [this.restart];
    }

    configure(new Effect());

    function GetMouthStatus(){
        return Api.isMouthOpen() || isSmile(world.landmarks, world.latents);
    }
    """
    
    static let octopusWithSound = """
    function Effect()
    {
        var self = this;

        self.loveDelay = 1350;
        self.jumpDelayStart = 1400;
        self.jumpDelay = 700;

        self.fallDownDelay = 500;

        /*
        this.meshes = [
            { file:"octopus.bsm2", anims:[
                { a:"start", t:1400 },
                { a:"idle", t:1733.33 },
                { a:"trigger_1", t:1700 },
                { a:"trigger_2_start", t:2500 },
                { a:"trigger_2_idle", t:1966.67 },
                { a:"trigger_2_end", t:933.333 },
                { a:"trigger_3", t:2166.67 },
            ] },
        ];
        */

        this.soundJump = function() {
            var now = (new Date()).getTime();
            if (now > self.soundT) {
                Api.playSound("Octopus_Jump.ogg", false, 1);
                self.faceActions = [self.play];
            }
        };

        this.soundFallDown = function() {
            var now = (new Date()).getTime();

            if (now >= self.fallDownTime) {
                Api.playSound("fall_down_to_ear.ogg", false, 1);
                self.fallDownTime = Number.MAX_VALUE;
            }

            if (now > self.soundT) {
                Api.playSound("Octopus_Love_Hearts.ogg", false, 1);
                self.faceActions = [self.play];
            }
        };

        this.play = function() {
            var now = (new Date()).getTime();

            if (now < self.t)
                return;

            if (self.onTop) {
                if (Api.isMouthOpen()) {
                    Api.hideHint();
                    if (Math.random() < 0.5) {
                        Api.meshfxMsg("animOnce", 0, 0, "trigger_1");
                        Api.meshfxMsg("animLoop", 0, 1, "idle");
                        Api.playSound("octopus_hello.ogg", false, 1);
                        self.t = now + 1700;
                    } else {
                        Api.meshfxMsg("animOnce", 0, 0, "trigger_3");
                        Api.meshfxMsg("animLoop", 0, 1, "idle");
                        Api.playSound("Long_talking.ogg", false, 1);
                        self.t = now + 2166.67;
                    }
                } else if (isSmile(world.landmarks, world.latents)) {
                    Api.hideHint();
                    Api.meshfxMsg("animOnce", 0, 0, "trigger_2_start");
                    Api.meshfxMsg("animLoop", 0, 1, "trigger_2_idle");

                    self.fallDownTime = now + self.fallDownDelay;
                    self.t = now + 2500;
                    self.soundT = now + self.loveDelay;
                    self.faceActions = [self.soundFallDown];
                    self.onTop = false;
                }
            } else {
                if (isSmile(world.landmarks, world.latents)) {
                    Api.meshfxMsg("animOnce", 0, 0, "trigger_2_end");
                    Api.meshfxMsg("animLoop", 0, 1, "idle");
                    Api.playSound("jump_from_ear.ogg", false, 1);
                    self.t = now + 933.333;
                    self.soundT = now + self.jumpDelay;
                    self.faceActions = [self.soundJump];
                    self.onTop = true;
                }
            }
        };

        this.init = function() {
            Api.meshfxMsg("spawn", 1, 0, "!glfx_FACE");

            Api.meshfxMsg("spawn", 0, 0, "octopus.bsm2");
            Api.meshfxMsg("animOnce", 0, 0, "start");
            Api.meshfxMsg("animLoop", 0, 1, "idle");
            Api.playSound("Octopus_Soundfont_Strings.ogg", true, 1);
            Api.playSound("Octopus_Intro.ogg", false, 1);

            self.fallDownTime = Number.MAX_VALUE;
            self.t = 0;
            self.soundT = (new Date()).getTime() + self.jumpDelayStart;
            self.faceActions = [self.soundJump];
            self.onTop = true;

            Api.showHint("Smile or open mouth");
            Api.playVideo("frx", true, 1);
            Api.showRecordButton();
        };

        this.restart = function() {
            Api.meshfxReset();
            Api.stopVideo("frx");
            // Api.stopSound("sfx.aac");
            self.init();
        };

        this.faceActions = [];
        this.noFaceActions = [];

        this.videoRecordStartActions = [this.restart];
        this.videoRecordFinishActions = [];
        this.videoRecordDiscardActions = [this.restart];
    }

    configure(new Effect());

    function GetMouthStatus(){
        return Api.isMouthOpen() || isSmile(world.landmarks, world.latents);
    }
    """
    
    static let trollGrandmaWithSound = """
    function Effect() {
        var self = this;
        this.play = function() {
            now = (new Date()).getTime();
            if (now > self.time) {
                Api.hideHint();
                self.faceActions = [];
            }
            if(Api.isMouthOpen()) {
                Api.hideHint();
                self.faceActions = [];
            };
        };

        this.init = function() {
            Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");
            Api.meshfxMsg("spawn", 0, 0, "Trollma_morphing.bsm2");
            Api.meshfxMsg("spawn", 1, 0, "TrollGrandma.bsm2");
            self.time = (new Date()).getTime() + 3000;
            self.faceActions = [self.play];
            Api.playSound("music.ogg",true,1);
            Api.showRecordButton();
        };
        this.restart = function() {
            Api.meshfxReset();
            self.init();
        };
        this.stopSound = function () {
            if(Api.getPlatform() == "iOS") {
                Api.hideHint();
                Api.stopSound("music.ogg");
            };
        };
        this.faceActions = [];
        this.noFaceActions = [];
        this.videoRecordStartActions = [self.stopSound];
        this.videoRecordFinishActions = [];
        this.videoRecordDiscardActions = [this.restart];
    }
    configure(new Effect());
    """
    
    static let trollGrandmaNoSound = """
    function Effect() {
        var self = this;
        this.play = function() {
            now = (new Date()).getTime();
            if (now > self.time) {
                Api.hideHint();
                self.faceActions = [];
            }
            if(Api.isMouthOpen()) {
                Api.hideHint();
                self.faceActions = [];
            };
        };

        this.init = function() {
            Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");
            Api.meshfxMsg("spawn", 0, 0, "Trollma_morphing.bsm2");
            Api.meshfxMsg("spawn", 1, 0, "TrollGrandma.bsm2");

            self.time = (new Date()).getTime() + 3000;
            self.faceActions = [self.play];
            Api.showRecordButton();
        };
        this.restart = function() {
            Api.meshfxReset();
            self.init();
        };
        this.faceActions = [];
        this.noFaceActions = [];
        this.videoRecordStartActions = [];
        this.videoRecordFinishActions = [];
        this.videoRecordDiscardActions = [this.restart];
    }
    configure(new Effect());
    """
}
