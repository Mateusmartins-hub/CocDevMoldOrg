var j$ = jQuery.noConflict();

var EfeitosLoad = new function(){

	var divBlock = "<div class=\"block-in-load\" />";
	var divLoadMessage = "<div class=\"load-message\">"+
							"<img src=\"/resource/ajaxGif\" />" + 
							"<div class=\"msg\" >Aguarde...</div>" + 
						 "</div>";

	//Trava tela e apresenta mensagem					  
	this.iniciar = function(){
		j$('form[id$=form_]').prepend(divBlock);
		j$('form[id$=form_]').prepend(divLoadMessage);
	}

	this.finalizar = function(){
		j$(".load-message").remove();
		j$(".block-in-load").remove();
	}

}();