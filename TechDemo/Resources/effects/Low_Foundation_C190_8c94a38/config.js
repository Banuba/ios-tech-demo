
function Effect()
{
    var self = this;

    this.init = function() {
        Api.meshfxMsg("spawn", 0, 0, "tri.bsm2");
        Api.meshfxMsg("shaderVec4", 0, 0, "0.714 0.537 0.380 0.6");
        Api.meshfxMsg("shaderVec4", 0, 1, "1.0 0.0 0.0 0.0");

        Api.showRecordButton();
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [];
}

function setColor(color)
{
    var c = JSON.parse(color);
    Api.meshfxMsg("shaderVec4", 0, 0, c[0] + " " + c[1] + " " + c[2] + " " + c[3]);
}

configure(new Effect());