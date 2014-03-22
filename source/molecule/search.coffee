###
Basic fieldset for search

@namespace Atoms.Molecule
@class Search

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

class Atoms.Molecule.Search extends Atoms.Class.Molecule

  @template : """<fieldset {{#if.id}}id="{{id}}"{{/if.id}} {{#if.style}}class="{{style}}"{{/if.style}}></fieldset>"""

  @available: ["Atom.Input", "Atom.Button"]

  @base : "Search"

  constructor: ->
    @default =
      children: [
        "Atom.Input": id: "input", type: "search", placeholder: "Type your search...", events: ["keyup"]
      ,
        "Atom.Button": icon: "Search"
      ]
    super

  inputKeyup: (event, atom) =>
    @trigger "keyup", event.keyCode
    if event.keyCode is 13 then @_search event, atom

  buttonTouch: (event, atom) =>
    @_search event, atom

  _search: (event, atom) ->
    value = @input.value()
    @bubble "enter", value, atom if value isnt ""
