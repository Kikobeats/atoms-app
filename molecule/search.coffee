###
Basic fieldset for search

@namespace Atoms.Molecule
@class Search

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

class Atoms.Molecule.Search extends Atoms.Molecule.Form

  @template : """<form {{#if.style}}class="{{style}}"{{/if.style}} onsubmit="return false;"></form>"""

  @available: ["Atom.Input", "Atom.Button"]

  @events   : ["change", "submit"]

  @extends  : true

  @default  :
    events  : ["submit"]
    children: [
      "Atom.Input": id: "input", type: "search", placeholder: "Type your search...", events: ["keypress", "keyup"], required: true
    ,
      "Atom.Button": icon: "search"
    ]

  value: (value) ->
    @input.value value or null

  # Children Bubble Events
  onInputKeyup: (event, atom) =>
    @bubble "change", event unless event.keyCode is 13
    false

  onInputKeypress: (event, atom) =>
    @_bubbleSubmit event, atom if event.keyCode is 13
    false

  onButtonTouch: (event, atom) =>
    event.preventDefault()
    @_bubbleSubmit event, atom
    false

  _bubbleSubmit: (event, atom) ->
    atom?.el?[0].blur()
    value = @input.value()
    @bubble "submit", event if value isnt ""
