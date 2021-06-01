// EDITOR
var editor = ace.edit("Editor");
editor.setTheme("ace/theme/monokai");
editor.session.setMode("ace/mode/java");
editor.setFontSize("20px");
editor.session.setTabSize(4);
editor.session.setUseSoftTabs(true);


// EDITOR1
var editor = ace.edit("Editor1");
editor.setTheme("ace/theme/monokai");
editor.session.setMode("ace/mode/java");
editor.setFontSize("20px");
editor.session.setTabSize(4);
editor.session.setUseSoftTabs(true);

// EDITOR2
var editor = ace.edit("Editor2");
editor.setTheme("ace/theme/monokai");
editor.session.setMode("ace/mode/java");
editor.setFontSize("20px");
editor.session.setTabSize(4);
editor.session.setUseSoftTabs(true);

//CONSOLA JS
var consola = ace.edit("Console");
consola.setTheme("ace/theme/monokai");
consola.session.setMode("ace/mode/javascript");
consola.setFontSize("20px");
consola.setReadOnly(true);

//CONSOLA PYTHON
var consola1 = ace.edit("Console1");
consola1.setTheme("ace/theme/monokai");
consola1.session.setMode("ace/mode/python");
consola1.setFontSize("20px");
consola1.setReadOnly(true);

//TOKEN JS
var consolaTJS = ace.edit("TokenJS");
consolaTJS.setTheme("ace/theme/terminal");
consolaTJS.session.setMode("ace/mode/javascript");
consolaTJS.setFontSize("20px");
consolaTJS.setReadOnly(true);

//TOKEN PYTHON
var consolaTPY = ace.edit("TokenPython");
consolaTPY.setTheme("ace/theme/terminal");
consolaTPY.session.setMode("ace/mode/python");
consolaTPY.setFontSize("20px");
consolaTPY.setReadOnly(true);