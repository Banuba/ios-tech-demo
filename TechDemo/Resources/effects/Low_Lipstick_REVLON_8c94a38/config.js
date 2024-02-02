function Effect() {
    var self = this;

    this.init = function() {
        Api.meshfxMsg("spawn", 0, 0, "!glfx_FACE");
        //Api.meshfxMsg("spawn", 1, 0, "Beauty09.bsm2");
        Api.meshfxMsg("spawn", 2, 0, "eyelash.bsm2");
        Api.meshfxMsg("spawn", 3, 0, "quad.bsm2");

        Api.meshfxMsg("shaderVec4", 0, 1, "0.388 0.090 0.075 0.85");

        // [0] sCoef -- color saturation
        // [1] vCoef -- shine brightness (intensity)
        // [2] sCoef1 -- shine saturation (color bleeding)
        // [3] bCoef -- darkness (more is less)
        Api.meshfxMsg("shaderVec4", 0, 2, "1.0 0.25 0.85 0.98");
        
        
        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        self.init();
    };

    this.faceActions = [function(){ Api.meshfxMsg("shaderVec4", 0, 0, "1."); }];
    this.noFaceActions = [function(){ Api.meshfxMsg("shaderVec4", 0, 0, "0."); }];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());