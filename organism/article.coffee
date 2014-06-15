###
...

@namespace Atoms.Organism
@class Article

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

class Atoms.Organism.Article extends Atoms.Class.Organism

  @template : """<article {{#if.id}}id="{{id}}"{{/if.id}} {{#if.style}}class="{{style}}"{{/if.style}}></article>"""

  @available: ["Organism.Header", "Organism.Section", "Organism.Footer", "Molecule.Navigation", "Molecule.Form"]

  @base     : "Article"

  @events   : ["show", "hide"]

  ACTIVE_STATES = ["in", "back-out", "aside-show", "aside-hide", "aside-show-right", "aside-hide-right"]

  constructor: ->
    super
    Atoms.App.Article[@constructor.name] = @

  render: ->
    super
    for animation_end in Atoms.Core.Constants.ANIMATION.END.split " "
      @el.bind animation_end, @onAnimationEnd

  state: (name) ->
    @el.addClass("active").attr("data-state", name)

  section: (id) ->
    @tunnel "onArticleChange", @
    @tunnel "onSectionScroll"

    for child in @children when child.constructor.base is "Section"
      if child.attributes.id is id
        child.show()
        child.el.focus()
      else if child.el.hasClass "active"
        child.hide()
        child.el.blur()

    @aside() if @el.attr("data-state") is "aside-show"

  aside: (id) =>
    aside_instance = Atoms.App.Aside[id.toClassName()]
    if aside_instance?
      method = if @el.hasClass "aside" then "hide" else "show"
      do aside_instance[method]
      if method is "hide"
        @el.removeClass("aside").removeClass("right")

      if aside_instance.attributes.style is "right"
        method += "-right"

      @state "aside-#{method}"

  # Instance Events
  onAnimationEnd: (event) =>
    state = @el.attr "data-state"
    if state in ["in", "back-out"]
      @trigger "show"
    else if state in ["out", "back-in"]
      @trigger "hide"

    unless state in ACTIVE_STATES then @el.removeClass("active")
    if state in ["aside-show", "aside-show-right"]
      @el.addClass "aside"
      @el.addClass "right" if state is "aside-show-right"

    @el.removeAttr "data-state"

  # Children Bubble Events
  onSectionScroll: (event, section) ->
    if event.down and (event.percent > 5 or (event.height - event.scroll) < 128)
      event.addClass = true
    else
      event.addClass = false
    @tunnel "onSectionScroll", event
    false
