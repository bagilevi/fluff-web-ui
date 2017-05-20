// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

$(function(){
  $('#failures-container').on('click', '.failure-snippet', function(){
    $('.failure-details').hide();
    let $details = $('#failure-' + $(this).data('failure-id'));
    $details.show();
    window.applyCodeMirrorToFailureDetails($details);
    $('.failure-snippet').removeClass('current')
    $(this).addClass('current')
  });
});

window.applyCodeMirrorToFailureDetails = function($details) {
  let $textarea = $details.find('textarea');
  let startingLine = $textarea.data('starting-line') || 1;
  let failingLine = $textarea.data('failing-line');

  if ($details.data('codemirror') != 'applied') {
    $details.data('codemirror', 'applied');
    var cm = CodeMirror.fromTextArea(
      $textarea.get(0),
      {
        mode: "ruby",
        theme: "ambiance",
        lineNumbers: true,
        firstLineNumber: startingLine,
        readOnly: true,
        styleActiveLine: true
      }
    );
    let $cm = $details.find('.CodeMirror');
    $cm.css('height', '38em');

    cm.setCursor(failingLine - startingLine, 1);
    cm.scrollIntoView({line: failingLine - startingLine + 1, ch: 0});
    cm.scrollIntoView({line: failingLine - startingLine + 5, ch: 0});
  }
}
