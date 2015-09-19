class Dragster
  constructor: ( @el ) ->
    if @supportsEventConstructors()
      @first = false
      @second = false

      @el.addEventListener "dragenter", @dragenter, true
      @el.addEventListener "dragleave", @dragleave, false
      @el.addEventListener "drop", @drop, false
    else
      throw new Error
      '''Your browser does not support CustomEvent.
      Include polyfill like this
      https://www.npmjs.com/package/custom-event-polyfill.'''

  dragenter: ( event ) =>
    return if event.relatedTarget and event.target is event.relatedTarget
    return if !event.relatedTarget and !event.timeStamp

    if @first
      @second = true
    else
      @first = true
      @el.dispatchEvent new CustomEvent "dragster:enter",
        bubbles: true
        cancelable: true
        detail:
          dataTransfer: event.dataTransfer

  dragleave: ( event ) =>
    if @second
      @second = false
    else if @first
      @first = false

    if !@first && !@second
      @el.dispatchEvent new CustomEvent "dragster:leave",
        bubbles: true
        cancelable: true
        detail:
          dataTransfer: event.dataTransfer

  removeListeners: ->
    @el.removeEventListener "dragenter", @dragenter, false
    @el.removeEventListener "dragleave", @dragleave, false
    @el.removeEventListener "drop", @drop, false

  supportsEventConstructors: ->
    try new CustomEvent("z") catch then return false
    return true

  drop: ( event ) =>
    event.preventDefault()
    @first = false
    @second = false

  reset: ->
    @first = false
    @second = false

if typeof module == 'undefined'
  window.Dragster = Dragster
else
  module.exports = Dragster
