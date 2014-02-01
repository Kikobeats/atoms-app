class First extends Atoms.Organism.Article

  @scaffold "source/first/first.yml"

  constructor: ->
    super
    @bind "in", (event) -> @_log "in", event
    @bind "out", (event) -> @_log "out", event
    @bind "active", (event) -> @_log "active", event
    @bind "inactive", (event) ->  @_log "inactive", event

  render: ->
    super
    new Atoms.App.Section.Form  parent: @, "source/first/form.yml"

    list = new Atoms.Molecule.ListContacts
      parent    : @
      container : @el.find("section#list") # "section#list"

    # Example of Async Process Render
    Atoms.Entity.Contact.create name: "@soyjavi", description: "Test", url: "sjsjjs"
    Atoms.Entity.Contact.create name: "@piniphone", description: "Test 2", when: new Date()
    Atoms.Entity.Contact.create name: "@tapquo"

    list.entityAtom "Li"
    list.entity Atoms.Entity.Contact.all()


  _log: (method, event) -> console.log "article > #{method}", event


  bubbleLiTouch: (event, atom) ->
    console.log ">>> bubble", atom, atom.attributes.entity
    # atom.entity.updateAttributes text: "Hello", description: "UPDATED!",

  bubbleFormSubmit: (event, form, hierarchy...) ->
    console.info "<article> bubbleFormSubmit", form.value()

first = new First()


class Atoms.Entity.Contact extends Atoms.Class.Entity

  @fields "id", "name", "description", "url", "when"

  parse: ->
    image       : @url
    date        : @when
    text        : @name
    description : @description


