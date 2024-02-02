'use strict';

const makeup = require('./makeup.js');

Object.assign(globalThis, makeup.m);
/* Feel free to add your custom code below */

// Reset all the FaceMorph effects
FaceMorph.clear()
let face_template = {}
let nose_template = {}
let lips_template = {}
let eyebrows_template = {}
let eyes_template = {}

function applyTemplate(template, value) {
    let result = {}
    for (let [morphParam, func] of Object.entries(template)) {
        result[morphParam] = func(value)
    }
    return result
}

function onDataUpdate(slider) {
    FaceMorph.face(applyTemplate(face_template, slider))
    FaceMorph.nose(applyTemplate(nose_template, slider))
    FaceMorph.lips(applyTemplate(lips_template, slider))
    FaceMorph.eyebrows(applyTemplate(eyebrows_template, slider))
    FaceMorph.eyes(applyTemplate(eyes_template, slider))
}

