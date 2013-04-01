t = text

doctype 5
html ->
  head ->
    title 'Ferro'
    meta charset: 'utf-8'
    link
      href: 'css/options.css'
      media: 'all'
      rel: 'stylesheet'
      type: 'text/css'
    script src: 'js/options.js'
  body ->
    h1 'Ferro'
    p ->
      t 'Provides a better keyboard interface and session management. Hit '
      code 'Alt-Shift-F'
      t ', type, (optionally hit '
      code 'tab'
      t 'and type again) and hit '
      code 'enter'
      t '. TODO Note that Ferro works neither on the special '
      code 'chrome://'
      t 'pages, including this one, nor on the Chrome Web Store.'
    h3 'Saved Sessions'
    ul id: 'session-list', ->
    h3 'Keyboard Shortcuts'
    p ->
      t 'To change a keyboard shortcut, go to the extensions page ('
      code 'chrome://extensions'
      t ') and click the "Configure commands" link on the bottom right.'
    span '#prefix', ->
      code 'Alt-Shift-'
    table '.keys', ->
      tr ->
        th 'Default Shortcut'
        th 'Command'
      tr ->
        td ->
          code 'F'
        td 'Open Ferro popup'
      tr ->
        td ->
          code 'P'
        td 'Pin/Unpin current tab'
      tr ->
        td ->
          code 'D'
        td 'Duplicate tab'
      tr ->
        td ->
          code 'R'
        td 'Reload all tabs in window'
      tr ->
        td ->
          code 'K'
        td 'Kill tab'
    h3 'Available Commands'
    table ->
      tr ->
        th 'Name'
        th 'Description'
      sorted_commands = Object.keys(COMMANDS).sort()
      for i in [0...sorted_commands.length]
        name = sorted_commands[i]
        console.log "HWEJ"
        cmd = COMMANDS[name]
        tr ->
          td sentence_case name
          td cmd.desc
    h3 'Recommended Extensions'
    ul ->
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/dbepggeogbaibhgnhhndojpepiihcmeb', -> 'Vimium'
    	  ': Provides better keyboard navigation. You can even customize the shortcuts to better match the one true editor.'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/gijmaphaippejlhagngohjmehmanbehd', -> 'QuickShift'
    	  ': Move tabs to a different window or to a new location within the current window using your keyboard.'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/hdokiejnpimakedhajhdlcegeplioahd', -> 'Lastpass'
    	  ': Automatically generate, remember, and fill in passwords.'
      li ->
        a href: 'http://defunkt.io/dotjs/', -> 'Dotjs'
        ': Modify websites yourself with Javascript. Better than Greasemonkey.'
    footer ->
      a href: 'http://getferro.com', -> 'getferro.com'
