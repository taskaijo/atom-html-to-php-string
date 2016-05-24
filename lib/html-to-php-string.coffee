module.exports =
  activate: (state) ->
    atom.workspaceView.command 'htmlToPHPString:convert', => @convert()
    atom.workspaceView.command 'htmlToPHPString:deconvert', => @deconvert()

  convert: ->
    editor = atom.workspace.getActiveEditor()
    return if !editor

    selection = editor.getSelection()
    selectedText = selection.getText()
    convertText = selectedText.split('\n').map((line) =>
      trimedText = line.trimLeft()
      spaceCount = line.indexOf(trimedText)
      space = ''
      for i in [0...spaceCount]
        space += ' '
      return "#{space}echo \"#{line.trimLeft()}\".PHP_EOL;"
    ).join(' +\n')

    selection.insertText(convertText,
      select: true
    )

  deconvert: ->
    editor = atom.workspace.getActiveEditor()
    return if !editor

    selection = editor.getSelection()
    selectedText = selection.getText()
    convertText = selectedText.split('\n').map((line) =>
      trimedText = line.trim()
        .replace(/\s?\+\s?/, '')
        .replace(/^echo \"/, '')
        .replace(/\".PHP_EOL;$/, '')
      spaceCount = line.indexOf(trimedText)
      space = ''
      for i in [0...spaceCount-1]
        space += ' '
      return "#{space}#{trimedText}"
    ).join('\n')

    selection.insertText(convertText,
      select: true
    )
