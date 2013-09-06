function caretPos(field) {
	var pos = 0;

	if(document.selection) {
		field.focus();
		var sel = document.selction.createRange();
		sel.moveStart('character', -field.value.length);
		pos = sel.text.length;
	}
	else if(field.selectionStart || field.selectionStart == '0') {
		pos = field.selectionStart;
	}

	return (pos);
}

function ajax_autocomplete(varname) {
	var inputfield = document.getElementById(varname);
	var matter = inputfield.value;
	var index = caretPos(inputfield);
	var url = "autocomplete.rb?m=" + escape(matter) + "&p=" + index;
	var e1 = document.getElementById("dropdown");
	var req = new XMLHttpRequest();
	
	req.onreadystatechange = function() {
		if(req.readyState == 4) {
			if(req.status == 200) {
				e1.innerHTML = req.responseText;
			}
		}
	};
	req.open("GET", url, true);
	req.send(null);
}

/*var val;
var inputfield;

function loading() {
	inputfield = document.getElementById("autocomplete_value");
	
	if(inputfield.addEventListener) {
		inputfield.addEventListener('keyup', keyListener, false);
	}

	document.onkeydown = tabcatch;
}

function tabcatch(evt) {
	var evt = (evt) ? evt : ((event) ? event : null);
	if(evt.keyCode == 9) {
		return false;
	}
}

function keyListener(e) {
	if(e.keyCode == 9) {
		inputfield.value = val;
		ajax_autocomplete();
		if(e.preventDefault) {
			e.preventDefault();
		}
		return false;
	}
}

function caretPos(field) {
	var pos = 0;

	if(document.selection) {
		field.focus();
		var sel = document.selction.createRange();
		sel.moveStart('character', -field.value.length);
		pos = sel.text.length;
	}
	else if(field.selectionStart || field.selectionStart == '0') {
		pos = field.selectionStart;
	}

	return (pos);
}

function ajax_autocomplete() {
	var matter = inputfield.value;
	var index = caretPos(inputfield);
	var url = "autocomplete.rb?m=" + escape(matter) + "&p=" + index;
	var e1 = document.getElementById("dropdown");
	var req = new XMLHttpRequest();

	req.onreadystatechange = function() {
		if(req.readyState == 4) {
			if(req.status == 200) {
				e1.innerHTML = req.responseText;
				val = req.responseText.split("<br />")[0];
			}
		}
	};
	req.open("GET", url, true);
	req.send(null);
}
*/

